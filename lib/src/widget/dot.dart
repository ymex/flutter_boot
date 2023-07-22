import 'package:flutter/material.dart';

class Dot extends StatelessWidget {

  final double size;
  final Color color;

  const Dot({super.key, this.size  = 8 , this.color = Colors.grey});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: color),
      ),
    );
  }
}