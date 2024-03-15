import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../common/bloc/bloc_helper.dart';
import '../../../../common/bloc/generic_bloc_state.dart';
import '../../../../common/dialog/app_alerts.dart';
import '../../../../common/dialog/retry_dialog.dart';
import '../../../../common/widget/empty_screen.dart';
import '../../../../core/utils/utils.dart';
import '../../../order/bloc/order_bloc.dart';
import '../../../order/data/model/order_model.dart';
import '../../../print/cubit/is_use_print_cubit.dart';
import '../../../print/cubit/print_cubit.dart';
import '../../../print/data/model/print_model.dart';
import '../../../table/bloc/table_bloc.dart';
import '../../../table/cubit/table_cubit.dart';
import '../../../table/data/model/table_model.dart';
import '../../cubit/cart_cubit.dart';
import '../widget/item_cart.dart';

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

                          context.pop();
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
      title: Text('Giỏ hàng', style: context.titleStyleMedium));

  Widget _buildBody(BuildContext context, OrderModel orderModel) {
    return Column(
        children: [
      Expanded(child: ItemCart(orderModel: orderModel)),
      Card(
          elevation: 10,
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Tổng tiền:'),
                Text(
                    Ultils.currencyFormat(
                        double.parse(cartState.totalPrice.toString())),
                    style: TextStyle(
                        color: context.colorScheme.secondary,
                        fontWeight: FontWeight.bold))
              ]),
              const SizedBox(height: 8),
              AnimatedButton(
                  color: context.colorScheme.tertiaryContainer,
                  text: 'Lên đơn',
                  buttonTextStyle: context.titleStyleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                  pressEvent: () => submitCreateOrder(context))
            ]),
          ))
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
    showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
                cancelButton: CupertinoActionSheetAction(
                    isDestructiveAction: true,
                    onPressed: () => context.pop(),
                    child: Text(AppString.cancel)),
                title: Text('Kiểm tra kĩ trước khi lên đơn',
                    style: context.titleStyleSmall),
                actions: [
                  CupertinoActionSheetAction(
                      isDefaultAction: true,
                      onPressed: () => _handleCreateOrder(context),
                      child: Text('${AppString.ok} lên đơn'))
                ]));
  }

  void _handleCreateOrder(BuildContext context) {
    context.pop();
    cartState = cartState.copyWith(orderTime: DateTime.now().toString());
    context.read<OrderBloc>().add(OrderCreated(orderModel: cartState));
  }

  // Widget _buildItemFood(
  //     BuildContext context, OrderModel orderModel, FoodOrder foo, int index) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //     child: Slidable(
  //         endActionPane: ActionPane(
  //             extentRatio: 0.22,
  //             motion: const ScrollMotion(),
  //             children: [

  //               // SlidableAction(
  //               //     borderRadius: BorderRadius.circular(defaultBorderRadius),
  //               //     flex: 1,
  //               //     onPressed: (ct) {
  //               //       _handleDeleteItem(context, orderModel, foo);
  //               //     },
  //               //     backgroundColor: context.colorScheme.error,
  //               //     foregroundColor: Colors.white,
  //               //     icon: Icons.delete_forever)
  //             ]),
  //         child: ),
  //   );
  // }

  // Card(
  //                   color: context.colorScheme.errorContainer,
  //                   child: InkWell(
  //                       onTap: () =>
  //                           _handleDeleteItem(context, orderModel, foo),
  //                       child: SizedBox(
  //                           height: double.infinity,
  //                           width: context.sizeDevice.width * 0.05,
  //                           child: SvgPicture.asset('assets/icon/delete.svg',
  //                               fit: BoxFit.none,
  //                               colorFilter: const ColorFilter.mode(
  //                                   Colors.white, BlendMode.srcIn)))))
}
