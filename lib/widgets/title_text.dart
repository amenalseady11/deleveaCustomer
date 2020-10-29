import 'package:app/screens/themes/light_color.dart';
import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  const TitleText(
      {Key key,
      this.text,
      this.fontSize = 18,
      this.color = LightColor.titleTextColor,
      this.fontWeight = FontWeight.w800
      })
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: TextAlign.center,
         style: Theme.of(context).textTheme.headline4,
        );
  }
}