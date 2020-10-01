import 'package:app/screens/themes/light_color.dart';
import 'package:flutter/material.dart';
import 'package:app/widgets/extentions.dart';

class IconDisplay extends StatelessWidget {
  IconData icon;
  Color color = LightColor.iconColor;
  double size = 20;
  double padding = 10;
  bool isOutLine = false;
  Function onPressed;

  IconDisplay(this.icon, {this.color, this.size, this.padding, this.isOutLine,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      padding: EdgeInsets.all(padding),
      // margin: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        border: Border.all(
            color: LightColor.iconColor,
            style: isOutLine ? BorderStyle.solid : BorderStyle.none),
        borderRadius: BorderRadius.all(Radius.circular(13)),
        color:
            isOutLine ? Colors.transparent : Theme.of(context).backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Color(0xfff8f8f8),
              blurRadius: 5,
              spreadRadius: 10,
              offset: Offset(5, 5)),
        ],
      ),
      child: Icon(icon, color: color, size: size),
    ).ripple(() {
      if (onPressed != null) {
        onPressed();
      }
    }, borderRadius: BorderRadius.all(Radius.circular(13)));
  }
}
