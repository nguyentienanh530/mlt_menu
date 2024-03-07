import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:badges/badges.dart' as badges;
import 'package:mlt_menu/core/utils/utils.dart';
import 'package:mlt_menu/features/cart/cubit/cart_cubit.dart';

class CartButton extends StatelessWidget {
  const CartButton({super.key, required this.onPressed});
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    var cart = context.watch<CartCubit>().state;
    return IconButton(
        onPressed: onPressed,
        icon: badges.Badge(
            badgeStyle: badges.BadgeStyle(
                badgeColor: context.colorScheme.errorContainer),
            position: badges.BadgePosition.topEnd(top: -14),
            badgeContent: Text(cart.foods.length.toString(),
                style: context.textStyleSmall!
                    .copyWith(fontWeight: FontWeight.bold)),
            child: SvgPicture.asset('assets/icon/cart.svg',
                height: 20,
                width: 20,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn))));
  }
}
