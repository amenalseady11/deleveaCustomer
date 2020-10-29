import 'package:app/screens/dashboard/home_pager.dart';
import 'package:app/widgets/default_button.dart';
import 'package:flutter/material.dart';

import '../../utils/size_config.dart';
class LoginSuccessScreen extends StatelessWidget {
  static String routeName = "/login_success";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: SizedBox(),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: SizeConfig.screenHeight * 0.04),
            Image.asset(
              "assets/images/success.png",
              height: SizeConfig.screenHeight * 0.4, //40%
            ),
            SizedBox(height: SizeConfig.screenHeight * 0.08),
            Text(
              "Order Success",
              style: TextStyle(
                fontSize: getProportionateScreenWidth(30),
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Spacer(),
            SizedBox(
              width: SizeConfig.screenWidth * 0.6,
              child: DefaultButton(
                text: "Back to home",
                press: () {
                  Navigator.of(context)
                      .pushReplacementNamed(HomePager.routeName);
                },
              ),
            ),
            Spacer(),
          ],
        ));
  }
}
