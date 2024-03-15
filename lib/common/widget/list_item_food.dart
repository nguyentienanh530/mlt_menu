import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mlt_menu/common/widget/loading_screen.dart';
import 'package:mlt_menu/core/config/config.dart';
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
        clipBehavior: Clip.hardEdge,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(defaultBorderRadius)),
        child: Image.network(food.image == "" ? noImage : food.image,
            loadingBuilder: (context, child, loadingProgress) =>
                loadingProgress == null ? child : const LoadingScreen(),
            fit: BoxFit.cover));
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
        child: Text(food.name,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold)));
  }

  Widget _buildPriceDiscount(BuildContext context, FoodModel food) {
    double discountAmount = (food.price * food.discount.toDouble()) / 100;
    double discountedPrice = food.price - discountAmount;
    return food.isDiscount == false
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
                Expanded(
                    flex: 2,
                    child: FittedBox(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                            Ultils.currencyFormat(
                                double.parse(food.price.toString())),
                            style: TextStyle(
                                color: context.colorScheme.secondary,
                                fontWeight: FontWeight.bold)))),
                Expanded(
                    child: FittedBox(
                        alignment: Alignment.bottomRight,
                        child: _buildButtonCart(context, food)))
              ])
        : Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
                // TextStyle(
                //                   fontFamily: GoogleFonts.nunito().fontFamily,
                //                   decoration: TextDecoration.lineThrough,
                //                   decorationThickness: 3.0,
                //                   decorationColor: Colors.red,
                //                   decorationStyle: TextDecorationStyle.solid)
                Expanded(
                    flex: 2,
                    child: FittedBox(
                        alignment: Alignment.bottomLeft,
                        child: Row(children: [
                          Text(
                              Ultils.currencyFormat(
                                  double.parse(food.price.toString())),
                              style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  decorationThickness: 3.0,
                                  decorationColor: Colors.red,
                                  decorationStyle: TextDecorationStyle.solid)),
                          const SizedBox(width: 8),
                          Text(
                              Ultils.currencyFormat(
                                  double.parse(discountedPrice.toString())),
                              style: TextStyle(
                                  color: context.colorScheme.secondary,
                                  fontWeight: FontWeight.bold))
                        ]))),
                Expanded(
                    child: FittedBox(
                        alignment: Alignment.bottomRight,
                        child: _buildButtonCart(context, food)))
              ]);
  }

  Widget _buildButtonCart(BuildContext context, FoodModel food) {
    return GestureDetector(
        onTap: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => OrderFoodBottomSheet(foodModel: food));
        },
        child: SvgPicture.asset('assets/icon/cart.svg',
            height: 20,
            width: 20,
            colorFilter:
                const ColorFilter.mode(Colors.white, BlendMode.srcIn)));
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
    return GestureDetector(
        onTap: () {
          // FirebaseFirestore.instance
          //     .collection('food')
          //     .doc(list?[i].id)
          //     .update({'count': FieldValue.increment(1)});

          context.push(RouteName.foodDetail, extra: foodModel);
          // Get.toNamed(Routes.foodDetail, arguments: {
          //   'food': food,
          //   'heroTag': 'hero-tag-${food.id}+list'
          // });
        },
        child: LayoutBuilder(
            builder: (context, constraints) => Card(
                  child: SizedBox(
                      width: constraints.constrainHeight(),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Expanded(
                                flex: 2,
                                child: Stack(children: <Widget>[
                                  _buildImage(foodModel),
                                  foodModel.isDiscount == true
                                      ? _buildPercentDiscount(
                                          context, foodModel)
                                      : const SizedBox()
                                ])),
                            Expanded(
                                flex: 1,
                                child: Padding(
                                    padding: EdgeInsets.all(defaultPadding / 2),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              child: _buildTitle(
                                                  context, foodModel)),
                                          Expanded(
                                              child: _buildPriceDiscount(
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _buildListItemFood(list ?? <FoodModel>[]),
    );
  }
}

class Food {}
