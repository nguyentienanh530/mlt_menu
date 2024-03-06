import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CartButton extends StatelessWidget {
  const CartButton({super.key, required this.onPressed});
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: onPressed,
        icon: SvgPicture.asset('assets/icon/cart.svg',
            height: 20,
            width: 20,
            colorFilter:
                const ColorFilter.mode(Colors.white, BlendMode.srcIn)));
  }
}
