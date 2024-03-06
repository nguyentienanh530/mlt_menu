import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:mlt_menu/common/widget/common_bottomsheet.dart';
import 'package:mlt_menu/common/widget/empty_screen.dart';
import 'package:mlt_menu/core/utils/app_string.dart';
import 'package:mlt_menu/core/utils/extensions.dart';
import 'package:mlt_menu/features/cart/cubit/cart_cubit.dart';
import 'package:mlt_menu/features/order/data/model/food_order.dart';
import 'package:mlt_menu/features/order/data/model/order_model.dart';

import '../../../../core/utils/contants.dart';
import '../../../../core/utils/utils.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cartState = context.watch<CartCubit>().state;
    return Scaffold(
        appBar: _buildAppbar(context),
        body: cartState.foods.isEmpty
            ? const EmptyScreen()
            : _buildBody(cartState));
  }

  _buildAppbar(BuildContext context) => AppBar(
      centerTitle: true,
      title: Text('Giỏ hàng', style: context.textStyleLarge));

  Widget _buildBody(OrderModel orderModel) {
    return ListView.builder(
        itemCount: orderModel.foods.length,
        itemBuilder: (context, index) =>
            _buildItemFood(context, orderModel, orderModel.foods[index]));
  }

  Widget _buildItemFood(
      BuildContext context, OrderModel orderModel, FoodOrder foo) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
        child: Slidable(
            endActionPane: ActionPane(
                extentRatio: 0.3,
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                      borderRadius: BorderRadius.circular(defaultBorderRadius),
                      flex: 1,
                      // spacing: 8,
                      padding: EdgeInsets.all(defaultPadding),
                      onPressed: (ct) {
                        _handleDeleteItem(context, orderModel, foo);
                      },
                      backgroundColor: context.colorScheme.error,
                      foregroundColor: Colors.white,
                      icon: Icons.delete_forever)
                ]),
            child: _buildItem(context, foo)));
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
              orderModel = orderModel.copyWith(foods: newListOrder);
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
    var quantity = foodOrder.quantity;
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      // LineText(title: "Số lượng: ", value: food.quantity.toString()),
      InkWell(
          onTap: () {
            // _handleDecrement(food, foodDto, quantity)
          },
          child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: context.colorScheme.secondary),
              child: const Icon(Icons.remove, size: 20))),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Text('$quantity',
              style: context.textStyleSmall!
                  .copyWith(fontWeight: FontWeight.bold))),
      InkWell(
          onTap: () {
            //  _handleIncrement(food, foodDto, quantity)
          },
          child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: context.colorScheme.secondary),
              child: const Icon(Icons.add, size: 20)))
    ]);
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
