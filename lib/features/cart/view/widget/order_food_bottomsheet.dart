import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:mlt_menu/common/dialog/app_alerts.dart';
import 'package:mlt_menu/common/widget/common_text_field.dart';
import 'package:mlt_menu/core/config/config.dart';
import 'package:mlt_menu/features/cart/cubit/cart_cubit.dart';
import 'package:mlt_menu/features/order/data/model/food_order.dart';
import 'package:mlt_menu/features/order/data/model/order_model.dart';
import '../../../../core/utils/utils.dart';
import '../../../food/data/model/food_model.dart';

class OrderFoodBottomSheet extends StatefulWidget {
  const OrderFoodBottomSheet({super.key, required this.foodModel});
  final FoodModel foodModel;
  @override
  State<OrderFoodBottomSheet> createState() => _OrderFoodBottomSheetState();
}

class _OrderFoodBottomSheetState extends State<OrderFoodBottomSheet> {
  final TextEditingController _noteCtrl = TextEditingController();
  var _foodModel = FoodModel();
  final _quantity = ValueNotifier(1);
  final _totalPrice = ValueNotifier<num>(1.0);
  num _priceFood = 0;
  final fToast = FToast();

  @override
  void initState() {
    _foodModel = widget.foodModel;
    _priceFood = Ultils.foodPrice(
        isDiscount: _foodModel.isDiscount,
        foodPrice: _foodModel.price,
        discount: int.parse(_foodModel.discount.toString()));
    _totalPrice.value = _quantity.value * _priceFood;
    fToast.init(context);

    super.initState();
  }

  @override
  void dispose() {
    _noteCtrl.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var order = context.watch<CartCubit>().state;
    return SizedBox(
        height: context.sizeDevice.height * 0.8,
        child: Form(
            child: Column(children: [
          AppBar(
              backgroundColor: context.colorScheme.primaryContainer,
              centerTitle: true,
              title: Text(_foodModel.name,
                  textAlign: TextAlign.center,
                  style: context.textStyleLarge!
                      .copyWith(fontWeight: FontWeight.bold))),
          Expanded(
              child: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppString.priceSell,
                                style: context.textStyleSmall),
                            const SizedBox(height: 10),
                            _Price(
                                price: Ultils.foodPrice(
                                    isDiscount: _foodModel.isDiscount,
                                    foodPrice: _foodModel.price,
                                    discount: int.parse(
                                        _foodModel.discount.toString()))),
                            const SizedBox(height: 10),
                            Text(AppString.quantity,
                                style: context.textStyleSmall),
                            const SizedBox(height: 10),
                            _buildQuantity(),
                            const SizedBox(height: 10),
                            Text(AppString.note, style: context.textStyleSmall),
                            const SizedBox(height: 10),
                            _Note(noteCtrl: _noteCtrl),
                            const SizedBox(height: 20)
                          ])))),
          Card(
              color: context.colorScheme.primaryContainer,
              margin: const EdgeInsets.all(16),
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(children: [
                    _buildTotalPrice(),
                    const SizedBox(height: 8),
                    _buildButtonAddToCart(order)
                  ])))
        ])));
  }

  void _handleOnTapAddToCart(OrderModel order) async {
    var table = '1MLT';

    if (table == '') {
      AppAlerts.warningDialog(context,
          desc: AppString.dontSelectTable,
          textCancel: AppString.ok, btnCancelOnPress: () {
        context.go(RouteName.home);
      });
    } else {
      if (checkExistFood(order)) {
        fToast.showToast(
            child: AppAlerts.errorToast(msg: 'Món ăn đã có trong giỏ hàng.'));
      } else {
        var newFoodOrder = FoodOrder(
            foodID: _foodModel.id,
            foodImage: _foodModel.image,
            foodName: _foodModel.name,
            quantity: _quantity.value,
            totalPrice: _totalPrice.value,
            note: _noteCtrl.text);
        var newFoods = [...order.foods, newFoodOrder];
        order =
            order.copyWith(tableName: table, foods: newFoods, status: 'new');
        context.read<CartCubit>().onCartChanged(order);
        context.pop();
        fToast.showToast(
            child: AppAlerts.successToast(msg: AppString.addedToCart));
      }
    }
  }

  bool checkExistFood(OrderModel orderModel) {
    var isExist = false;
    for (FoodOrder e in orderModel.foods) {
      if (e.foodID == _foodModel.id) {
        isExist = true;
        break;
      }
    }
    return isExist;
  }

  Widget _buildButtonAddToCart(OrderModel orderModel) {
    return InkWell(
        onTap: () {
          // _.formKey.currentState!.save();
          _handleOnTapAddToCart(orderModel);
        },
        child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width / 1.15,
            decoration: BoxDecoration(
              color: context.colorScheme.primary,
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            ),
            child: Center(
                child:
                    Text(AppString.addToCart, style: context.textStyleSmall))));
  }

  Widget _buildTotalPrice() {
    return ValueListenableBuilder(
        valueListenable: _totalPrice,
        builder: (context, total, child) =>
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(AppString.totalPrice, style: context.textStyleSmall),
              Text(Ultils.currencyFormat(double.parse(total.toString())),
                  style: context.textStyleSmall!.copyWith(
                      color: context.colorScheme.secondary,
                      fontWeight: FontWeight.bold))
            ]));
  }

  Widget _buildQuantity() {
    return ValueListenableBuilder(
        valueListenable: _quantity,
        builder: (context, quantity, child) => Card(
            color: context.colorScheme.primary,
            child: Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCounter(context,
                          svg: SvgPicture.asset("assets/image/minus.svg",
                              colorFilter: const ColorFilter.mode(
                                  Colors.white, BlendMode.srcIn)), onTap: () {
                        decrementQuaranty();
                      }),
                      Text(quantity.toString(),
                          style: context.textStyleSmall!
                              .copyWith(fontWeight: FontWeight.bold)),
                      _buildCounter(context,
                          svg: SvgPicture.asset("assets/image/add.svg"),
                          onTap: () {
                        incrementQuaranty();
                      })
                    ]))));
  }

  void decrementQuaranty() {
    if (_quantity.value > 1) {
      _quantity.value--;
      _totalPrice.value = _quantity.value * _priceFood;
    }
  }

  void incrementQuaranty() {
    _quantity.value++;
    _totalPrice.value = _quantity.value * _priceFood;
  }

  Widget _buildCounter(BuildContext context, {Widget? svg, Function()? onTap}) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            decoration: BoxDecoration(
                color: context.colorScheme.secondary,
                borderRadius: BorderRadius.circular(8)),
            height: 40,
            width: 40,
            padding: const EdgeInsets.all(12),
            child: svg));
  }
}

class _Price extends StatelessWidget {
  final num? price;
  const _Price({this.price});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: context.colorScheme.primary,
        child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppString.priceSell, style: context.textStyleSmall),
                  Text(Ultils.currencyFormat(double.parse(price.toString())),
                      style: context.textStyleSmall)
                ])));
  }
}

class _Note extends StatelessWidget {
  const _Note({required this.noteCtrl});
  final TextEditingController noteCtrl;
  @override
  Widget build(BuildContext context) {
    return Card(
        child: CommonTextField(
            controller: noteCtrl,
            prefixIcon: const Icon(Icons.sticky_note_2_outlined),
            hintText: 'thêm ghi chú cho đầu bếp',
            onChanged: (value) => noteCtrl.text = value));
  }
}
