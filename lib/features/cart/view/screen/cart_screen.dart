import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mlt_menu/common/bloc/bloc_helper.dart';
import 'package:mlt_menu/common/bloc/generic_bloc_state.dart';
import 'package:mlt_menu/common/dialog/app_alerts.dart';
import 'package:mlt_menu/common/dialog/retry_dialog.dart';
import 'package:mlt_menu/common/widget/common_bottomsheet.dart';
import 'package:mlt_menu/common/widget/empty_screen.dart';
import 'package:mlt_menu/features/cart/cubit/cart_cubit.dart';
import 'package:mlt_menu/features/order/bloc/order_bloc.dart';
import 'package:mlt_menu/features/order/data/model/food_order.dart';
import 'package:mlt_menu/features/order/data/model/order_model.dart';
import 'package:mlt_menu/features/print/cubit/is_use_print_cubit.dart';
import 'package:mlt_menu/features/print/cubit/print_cubit.dart';
import 'package:mlt_menu/features/table/cubit/table_cubit.dart';
import '../../../../core/utils/utils.dart';
import '../../../print/data/model/print_model.dart';
import '../../../table/bloc/table_bloc.dart';
import '../../../table/data/model/table_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => TableBloc(), child: CardView());
  }
}

// ignore: must_be_immutable
class CardView extends StatelessWidget {
  CardView({super.key});
  var cartState = OrderModel();
  @override
  Widget build(BuildContext context) {
    cartState = context.watch<CartCubit>().state;
    var table = context.watch<TableCubit>().state;
    var isUsePrint = context.watch<IsUsePrintCubit>().state;
    var print = context.watch<PrintCubit>().state;
    return Scaffold(
        appBar: _buildAppbar(context),
        body: cartState.foods.isEmpty
            ? const EmptyScreen()
            : BlocListener<OrderBloc, GenericBlocState<OrderModel>>(
                listenWhen: (previous, current) =>
                    previous.status != current.status ||
                    context.read<OrderBloc>().operation == ApiOperation.create,
                listener: (context, state) => switch (state.status) {
                      Status.loading => AppAlerts.loadingDialog(context),
                      Status.empty => const SizedBox(),
                      Status.failure => RetryDialog(
                          title: 'Xảy ra lỗi!',
                          onRetryPressed: () => context
                              .read<OrderBloc>()
                              .add(OrderCreated(orderModel: cartState))),
                      Status.success =>
                        AppAlerts.successDialog(context, btnOkOnPress: () {
                          table = table.copyWith(isUse: true);
                          context
                              .read<TableBloc>()
                              .add(TableUpdated(tableModel: table));
                          _handlePrint(context,
                              cartState: cartState,
                              isUsePrint: isUsePrint,
                              print: print,
                              table: table);
                          context.read<CartCubit>().onCartClear();
                          context.read<TableCubit>().onTableClear();

                          pop(context, 2);
                        }, desc: 'Cảm ơn quý khách!')
                    },
                child: _buildBody(context, cartState)));
  }

  void _handlePrint(BuildContext context,
      {required OrderModel cartState,
      required TableModel table,
      required bool isUsePrint,
      required PrintModel print}) {
    if (isUsePrint) {
      var listPrint = [];
      for (var element in cartState.foods) {
        listPrint
            .add('${table.name} - ${element.foodName} - ${element.quantity}');
      }
      logger.d(listPrint);
      Ultils.sendPrintRequest(print: print, listDataPrint: listPrint);
    }
  }

  _buildAppbar(BuildContext context) => AppBar(
      centerTitle: true,
      title: Text('Giỏ hàng', style: context.textStyleLarge));

  Widget _buildBody(BuildContext context, OrderModel orderModel) {
    return Column(
        children: [
      Expanded(
          child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: orderModel.foods.length,
              itemBuilder: (context, index) => _buildItemFood(
                  context, orderModel, orderModel.foods[index]))),
      Card(
          margin: const EdgeInsets.all(16),
          child: Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              child: Column(children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tổng tiền:', style: context.textStyleSmall),
                      Text(
                          Ultils.currencyFormat(
                              double.parse(cartState.totalPrice.toString())),
                          style: context.textStyleLarge!.copyWith(
                              color: context.colorScheme.secondary,
                              fontWeight: FontWeight.bold))
                    ]),
                const SizedBox(height: 8),
                AnimatedButton(
                    color: context.colorScheme.primary,
                    text: 'Lên đơn',
                    buttonTextStyle: context.textStyleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                    pressEvent: () => submitCreateOrder(context))
              ])))
    ]
            .animate(interval: 50.ms)
            .slideX(
                begin: -0.1,
                end: 0,
                curve: Curves.easeInOutCubic,
                duration: 500.ms)
            .fadeIn(curve: Curves.easeInOutCubic, duration: 500.ms));
  }

  void submitCreateOrder(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) => CommonBottomSheet(
            title: 'Kiểm tra kĩ trước khi lên đơn',
            textCancel: AppString.cancel,
            textConfirm: '${AppString.ok} lên đơn',
            onCancel: () => context.pop(),
            onConfirm: () => _handleCreateOrder(context)));
  }

  void _handleCreateOrder(BuildContext context) {
    context.pop();
    cartState = cartState.copyWith(orderTime: DateTime.now().toString());
    context.read<OrderBloc>().add(OrderCreated(orderModel: cartState));
  }

  Widget _buildItemFood(
      BuildContext context, OrderModel orderModel, FoodOrder foo) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Slidable(
          endActionPane: ActionPane(
              extentRatio: 0.3,
              motion: const ScrollMotion(),
              children: [
                Card(
                    color: context.colorScheme.errorContainer,
                    child: InkWell(
                        onTap: () =>
                            _handleDeleteItem(context, orderModel, foo),
                        child: SizedBox(
                            height: double.infinity,
                            width: context.sizeDevice.width * 0.25,
                            child: SvgPicture.asset('assets/icon/delete.svg',
                                fit: BoxFit.none,
                                colorFilter: const ColorFilter.mode(
                                    Colors.white, BlendMode.srcIn)))))
                // SlidableAction(
                //     borderRadius: BorderRadius.circular(defaultBorderRadius),
                //     flex: 1,
                //     onPressed: (ct) {
                //       _handleDeleteItem(context, orderModel, foo);
                //     },
                //     backgroundColor: context.colorScheme.error,
                //     foregroundColor: Colors.white,
                //     icon: Icons.delete_forever)
              ]),
          child: _buildItem(context, foo)),
    );
  }

  void _handleDeleteItem(
      BuildContext context, OrderModel orderModel, FoodOrder foo) {
    showModalBottomSheet(
        context: context,
        builder: (context) => CommonBottomSheet(
            title: 'Xóa món "${foo.foodName}"?',
            textCancel: AppString.cancel,
            textConfirm: AppString.ok,
            onCancel: () => context.pop(),
            onConfirm: () {
              var newListOrder = [...orderModel.foods];
              newListOrder
                  .removeWhere((element) => element.foodID == foo.foodID);
              double newTotalPrice = newListOrder.fold(
                  0,
                  (double total, currentFood) =>
                      total + currentFood.totalPrice);
              orderModel = orderModel.copyWith(
                  foods: newListOrder, totalPrice: newTotalPrice);
              context.read<CartCubit>().onCartChanged(orderModel);
              context.pop();
            },
            textConfirmColor: context.colorScheme.error));
  }

  Widget _buildItem(BuildContext context, FoodOrder foodOrder) {
    return Card(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              _buildImage(foodOrder),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(),
                Text(foodOrder.foodName,
                    style: context.textStyleMedium!
                        .copyWith(fontWeight: FontWeight.bold)),
                SizedBox(height: defaultPadding / 2),
                _buildQuality(context, foodOrder)
              ])
            ]),
            Padding(
                padding: EdgeInsets.only(right: defaultPadding / 2),
                child: _PriceFoodItem(
                    totalPrice: (foodOrder.totalPrice).toString()))
          ]),
          foodOrder.note.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(),
                        Text("Ghi chú: ",
                            style: context.textStyleMedium!
                                .copyWith(fontWeight: FontWeight.bold)),
                        Text(foodOrder.note, style: context.textStyleSmall)
                      ]))
              : const SizedBox()
        ]));
  }

  Widget _buildImage(FoodOrder food) {
    return Container(
        height: 50,
        width: 50,
        margin: EdgeInsets.all(defaultPadding / 2),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(0.3),
            image: DecorationImage(
                image: NetworkImage(
                    food.foodImage == "" ? noImage : food.foodImage),
                fit: BoxFit.cover)));
  }

  Widget _buildQuality(BuildContext context, FoodOrder foodOrder) {
    var quantity = ValueNotifier(foodOrder.quantity);
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      // LineText(title: "Số lượng: ", value: food.quantity.toString()),
      InkWell(
          onTap: () {
            if (quantity.value > 1) {
              quantity.value--;
              _handleUpdateFood(context, quantity.value, foodOrder);
            }
          },
          child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: context.colorScheme.secondary),
              child: const Icon(Icons.remove, size: 20))),
      ValueListenableBuilder(
          valueListenable: quantity,
          builder: (context, value, child) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(value.toString(),
                  style: context.textStyleSmall!
                      .copyWith(fontWeight: FontWeight.bold)))),
      InkWell(
          onTap: () {
            quantity.value++;
            _handleUpdateFood(context, quantity.value, foodOrder);
          },
          child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: context.colorScheme.secondary),
              child: const Icon(Icons.add, size: 20)))
    ]);
  }

  void _handleUpdateFood(
      BuildContext context, int quantity, FoodOrder foodOrder) {
    int index = cartState.foods
        .indexWhere((element) => element.foodID == foodOrder.foodID);

    if (index != -1) {
      var existingFoodOrder = cartState.foods[index];
      var updatedFoodOrder = existingFoodOrder.copyWith(
          quantity: quantity,
          totalPrice: quantity *
              Ultils.foodPrice(
                  isDiscount: existingFoodOrder.isDiscount,
                  foodPrice: existingFoodOrder.foodPrice,
                  discount: int.parse(existingFoodOrder.discount.toString())));

      List<FoodOrder> updatedFoods = List.from(cartState.foods);
      updatedFoods[index] = updatedFoodOrder;
      double newTotalPrice = updatedFoods.fold(
          0, (double total, currentFood) => total + currentFood.totalPrice);
      cartState =
          cartState.copyWith(foods: updatedFoods, totalPrice: newTotalPrice);
      context.read<CartCubit>().onCartChanged(cartState);

      logger.d(updatedFoods);
    } else {}
  }
}

class _PriceFoodItem extends StatelessWidget {
  final String totalPrice;

  const _PriceFoodItem({required this.totalPrice});
  // food.totalPrice.toString()
  @override
  Widget build(BuildContext context) {
    return Text(Ultils.currencyFormat(double.parse(totalPrice)),
        style: context.textStyleMedium!.copyWith(
            color: context.colorScheme.secondary, fontWeight: FontWeight.bold));
  }
}
