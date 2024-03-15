import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widget/common_bottomsheet.dart';
import '../../../../core/utils/utils.dart';
import '../../../order/data/model/food_order.dart';
import '../../../order/data/model/order_model.dart';
import '../../cubit/cart_cubit.dart';

// ignore: must_be_immutable
class ItemCart extends StatelessWidget {
  ItemCart({super.key, required this.orderModel, this.onTapDeleteFood});
  OrderModel orderModel;
  final void Function()? onTapDeleteFood;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: orderModel.foods.length,
        itemBuilder: (context, index) =>
            _buildItem(context, orderModel.foods[index], index + 1));
  }

  Widget _buildItem(BuildContext context, FoodOrder foodOrder, int index) {
    return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 10,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, index, foodOrder),
              Row(children: [
                Expanded(child: _buildImage(foodOrder)),
                Expanded(
                    flex: 3,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(),
                          FittedBox(
                              child: Text(foodOrder.foodName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold))),
                          SizedBox(height: defaultPadding / 2),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildQuality(context, foodOrder),
                                Padding(
                                    padding: EdgeInsets.only(
                                        right: defaultPadding / 2),
                                    child: _buildPriceFood(context,
                                        (foodOrder.totalPrice).toString()))
                              ])
                        ]))
              ]),
              foodOrder.note.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(),
                            const Text("Ghi chú: ",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(foodOrder.note, style: context.textStyleSmall)
                          ]))
                  : const SizedBox()
            ]));
  }

  Widget _buildPriceFood(BuildContext context, String totalPrice) {
    return Text(Ultils.currencyFormat(double.parse(totalPrice)),
        style: TextStyle(
            color: context.colorScheme.secondary, fontWeight: FontWeight.bold));
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
                  style: const TextStyle(fontWeight: FontWeight.bold)))),
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
    int index = orderModel.foods
        .indexWhere((element) => element.foodID == foodOrder.foodID);

    if (index != -1) {
      var existingFoodOrder = orderModel.foods[index];
      var updatedFoodOrder = existingFoodOrder.copyWith(
          quantity: quantity,
          totalPrice: quantity *
              Ultils.foodPrice(
                  isDiscount: existingFoodOrder.isDiscount,
                  foodPrice: existingFoodOrder.foodPrice,
                  discount: int.parse(existingFoodOrder.discount.toString())));

      List<FoodOrder> updatedFoods = List.from(orderModel.foods);
      updatedFoods[index] = updatedFoodOrder;
      double newTotalPrice = updatedFoods.fold(
          0, (double total, currentFood) => total + currentFood.totalPrice);
      orderModel =
          orderModel.copyWith(foods: updatedFoods, totalPrice: newTotalPrice);
      context.read<CartCubit>().onCartChanged(orderModel);

      logger.d(updatedFoods);
    } else {}
  }

  Widget _buildHeader(BuildContext context, int index, FoodOrder foodOrder) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        height: 40,
        color: context.colorScheme.primary.withOpacity(0.3),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('#$index', style: const TextStyle(fontWeight: FontWeight.bold)),
          _buildIconDeleteItemFood(context, foodOrder)
        ]));
  }

  Widget _buildIconDeleteItemFood(BuildContext context, FoodOrder foodOrder) {
    return GestureDetector(
        onTap: () => _handleDeleteItem(context, orderModel, foodOrder),
        child: Container(
            height: 25,
            width: 25,
            decoration: BoxDecoration(
                color: context.colorScheme.errorContainer.withOpacity(0.2),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: context.colorScheme.errorContainer)),
            child: Icon(Icons.delete,
                size: 15, color: context.colorScheme.errorContainer)));
  }

  void _handleDeleteItem(
      BuildContext context, OrderModel orderModel, FoodOrder foo) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) => CommonBottomSheet(
            title: 'Xóa món "${foo.foodName}"?',
            textCancel: AppString.cancel,
            textConfirm: AppString.ok,
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
}
