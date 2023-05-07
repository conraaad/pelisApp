
import 'package:flutter/material.dart';

class ScalingText extends StatelessWidget {
  final String text;

  const ScalingText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            text,
            style: TextStyle(
              fontSize: (constraints.maxWidth / text.length),
            ),
          ),
        );
      },
    );
  }
}
