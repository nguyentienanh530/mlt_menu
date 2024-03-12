import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mlt_menu/features/cart/view/widget/order_food_bottomsheet.dart';
import '../../core/config/config.dart';
import '../../core/utils/utils.dart';
import '../../features/food/data/model/food_model.dart';
import 'loading_screen.dart';

class GridItemFood extends StatelessWidget {
  final List<FoodModel>? list;
  final bool? isScroll;

  const GridItemFood({super.key, required this.list, this.isScroll = false});
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
        child: Text(food.name, overflow: TextOverflow.ellipsis));
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
                              style: context.textStyleSmall!.copyWith(
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
          // Get.toNamed(Routes.order, arguments: {'food': food});
          // Get.bottomSheet(
          //     SizedBox(
          //         height: size.height * 0.75, child: OrderScreen(food: food)),
          //     ignoreSafeArea: false,
          //     isScrollControlled: true,
          //     enableDrag: false,
          //     useRootNavigator: true);

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
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
    // var foods = <FoodModel>[].obs;
    // foods.value = list!;

    // return Obx(() => _buildListItemFood(list!));
    return _buildGridItemFood(context, list!);
  }
}
