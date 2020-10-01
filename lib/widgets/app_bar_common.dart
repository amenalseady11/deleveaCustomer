import 'package:app/screens/themes/theme.dart';
import 'package:flutter/material.dart';

import 'package:app/utils/constants.dart';
import 'icon_widget.dart';

class AppBarCommon extends StatelessWidget {
  final String title;

  AppBarCommon(this.title);

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: AppTheme.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          IconDisplay(
            Icons.arrow_back_ios,
            color: Colors.black54,
            size: 15,
            padding: 12,
            isOutLine: true,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          SizedBox(
            width: 50,
          ),
          Text(
            title,
            style: kTitleTextStyle.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );;
  }
}
