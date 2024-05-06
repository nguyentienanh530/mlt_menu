import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:mlt_client_mobile/features/cart/view/widget/order_food_bottomsheet.dart';
import '../../core/config/config.dart';
import '../../core/utils/utils.dart';
import '../../features/food/data/model/food_model.dart';
import 'loading_screen.dart';

class GridItemFood extends StatelessWidget {
  final List<FoodModel>? list;
  final bool? isScroll;

  const GridItemFood({super.key, required this.list, this.isScroll = false});
  Widget _buildImage(FoodModel food, double height) {
    return Container(
        height: height,
        clipBehavior: Clip.hardEdge,
        width: double.infinity,
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
        clipBehavior: Clip.hardEdge,
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

  Widget _buildGridItemFood(BuildContext contextt, List<FoodModel> food) {
    // var shortestSide = contextt.sizeDevice.shortestSide;
    // shortestSide < 600 ? 2 : 2
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: defaultPadding),
        child: GridView.builder(
            shrinkWrap: true,
            physics: isScroll!
                ? const BouncingScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            itemCount: food.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: contextt.sizeDevice.height * 0.35,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                crossAxisCount: 2),
            itemBuilder: (context, index) => _buildItem(context, food[index])));
  }

  Widget _buildItem(BuildContext context, FoodModel foodModel) {
    return GestureDetector(
        onTap: () {
          // FirebaseFirestore.instance
          //     .collection('food')
          //     .doc(list?[i].id)
          //     .update({'count': FieldValue.increment(1)});

          context.push(RouteName.foodDetail, extra: foodModel);
        },
        child: LayoutBuilder(
            builder: (context, constraints) => Card(
                  elevation: 10,
                  child: SizedBox(
                      width: constraints.constrainHeight(),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Stack(children: <Widget>[
                              _buildImage(
                                  foodModel, constraints.maxHeight * 0.65),
                              foodModel.isDiscount == true
                                  ? _buildPercentDiscount(context, foodModel)
                                  : const SizedBox()
                            ]),
                            Expanded(
                                child: Padding(
                                    padding: EdgeInsets.all(defaultPadding / 2),
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
                )));
  }

  @override
  Widget build(BuildContext context) {
    // var foods = <FoodModel>[].obs;
    // foods.value = list!;

    // return Obx(() => _buildListItemFood(list!));
    return _buildGridItemFood(context, list!);
  }
}
