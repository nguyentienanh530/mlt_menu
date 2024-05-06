import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:mlt_client_mobile/common/widget/loading_screen.dart';
import 'package:mlt_client_mobile/core/config/config.dart';
import '../../core/utils/utils.dart';
import '../../features/cart/view/widget/order_food_bottomsheet.dart';
import '../../features/food/data/model/food_model.dart';

// import 'package:get/get.dart';

// import '../pages/order_page/order_page.dart';

class ListItemFood extends StatelessWidget {
  final List<FoodModel>? list;

  // final getContext = Get.context;

  const ListItemFood({super.key, required this.list});
  Widget _buildImage(FoodModel food) {
    return Container(
        height: 150,
        width: double.infinity,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(defaultBorderRadius)),
        child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: food.image,
            placeholder: (context, url) => const LoadingScreen(),
            errorWidget: (context, url, error) =>
                const Icon(Icons.photo_library_outlined)));
  }

  Widget _buildPercentDiscount(BuildContext context, FoodModel food) {
    return Container(
        height: 30,
        width: 50,
        decoration: BoxDecoration(
            color: kRedColor,
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(defaultBorderRadius),
                topLeft: Radius.circular(defaultBorderRadius))),
        child: Center(
            child: Text("${food.discount}%",
                style: const TextStyle(fontWeight: FontWeight.bold))));
  }

  Widget _buildTitle(BuildContext context, FoodModel food) {
    return FittedBox(
        alignment: Alignment.centerLeft,
        fit: BoxFit.scaleDown,
        child: Text(food.name,
            overflow: TextOverflow.ellipsis,
            style: context.titleStyleLarge!
                .copyWith(fontWeight: FontWeight.bold)));
  }

  Widget _buildPriceDiscount(BuildContext context, FoodModel food) {
    double discountAmount = (food.price * food.discount.toDouble()) / 100;
    double discountedPrice = food.price - discountAmount;
    return food.isDiscount == false
        ? FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
                Ultils.currencyFormat(double.parse(food.price.toString())),
                style: context.titleStyleLarge!.copyWith(
                    color: context.colorScheme.secondary,
                    fontWeight: FontWeight.bold)),
          )
        : FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(children: [
              FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                      Ultils.currencyFormat(
                          double.parse(food.price.toString())),
                      style: context.titleStyleLarge!.copyWith(
                          decoration: TextDecoration.lineThrough,
                          decorationThickness: 3.0,
                          decorationColor: Colors.red,
                          decorationStyle: TextDecorationStyle.solid))),
              const SizedBox(width: 8),
              FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                      Ultils.currencyFormat(
                          double.parse(discountedPrice.toString())),
                      style: context.titleStyleLarge!.copyWith(
                          color: context.colorScheme.secondary,
                          fontWeight: FontWeight.bold)))
            ]));
  }

  Widget _buildButtonCart(BuildContext context, FoodModel food) {
    return OutlinedButton(
        style: ButtonStyle(
            foregroundColor:
                MaterialStatePropertyAll(context.colorScheme.secondary)),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => OrderFoodBottomSheet(foodModel: food));
        },
        child: const FittedBox(
            fit: BoxFit.scaleDown, child: Icon(Icons.shopping_cart_rounded)));
  }

  Widget _buildListItemFood(List<FoodModel> food) {
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: list!.length,
        itemBuilder: (context, index) => _buildItem(context, list![index]),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true);
  }

  Widget _buildItem(BuildContext context, FoodModel foodModel) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: GestureDetector(
          onTap: () {
            context.push(RouteName.foodDetail, extra: foodModel);
          },
          child: LayoutBuilder(
              builder: (context, constraints) => Card(
                    elevation: 10,
                    child: SizedBox(
                        width: (context.sizeDevice.width / 2) - 32,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Stack(children: <Widget>[
                                _buildImage(foodModel),
                                foodModel.isDiscount == true
                                    ? _buildPercentDiscount(context, foodModel)
                                    : const SizedBox()
                              ]),
                              Expanded(
                                  flex: 1,
                                  child: Padding(
                                      padding:
                                          EdgeInsets.all(defaultPadding / 2),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                                child: _buildTitle(
                                                    context, foodModel)),
                                            Expanded(
                                                child: _buildPriceDiscount(
                                                    context, foodModel)),
                                            Expanded(
                                                child: _buildButtonCart(
                                                    context, foodModel))
                                          ])))
                            ]
                                .animate(interval: 50.ms)
                                .slideX(
                                    begin: -0.1,
                                    end: 0,
                                    curve: Curves.easeInOutCubic,
                                    duration: 500.ms)
                                .fadeIn(
                                    curve: Curves.easeInOutCubic,
                                    duration: 500.ms))),
                  ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _buildListItemFood(list ?? <FoodModel>[]),
    );
  }
}

class Food {}
