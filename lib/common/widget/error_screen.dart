import 'package:flutter/material.dart';
import '../../core/utils/utils.dart';

class ErrorScreen extends StatelessWidget {
  final String? errorMsg;
  const ErrorScreen({super.key, this.errorMsg});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              margin: EdgeInsets.all(defaultPadding),
              decoration: const BoxDecoration(
                  color: Colors.black38, shape: BoxShape.circle),
              padding: const EdgeInsets.all(27),
              child: Image.asset("assets/image/error.png", width: 214)),
          const SizedBox(height: 16),
          Center(
              child:
                  Text(AppString.errorTitle, style: context.titleStyleLarge)),
          const SizedBox(height: 16),
          Center(
              child: Text(errorMsg!,
                  style: context.textStyleSmall, textAlign: TextAlign.center))
        ]);
  }
}
