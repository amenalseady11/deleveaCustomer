import 'package:app/screens/themes/light_color.dart';
import 'package:app/screens/themes/theme.dart';
import 'package:app/utils/constants.dart';
import 'package:app/widgets/title_text.dart';
import 'package:flutter/material.dart';


class FavouritesScreen extends StatelessWidget {
  Widget emptyCart() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          width: double.infinity,
          height: 200,
          child: Image.asset(
            'assets/images/empty_cart.png',
            fit: BoxFit.fill,
          ),
        ),
        Text(
          'Favourites is Empty!!',
          style: TextStyle(color: kPrimaryColor, fontSize: 20),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppTheme.padding,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TitleText(
                text: 'Favourites',
                fontSize: 27,
                fontWeight: FontWeight.w400,
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.favorite,
                  color: LightColor.orange,
                ),
              )
            ],
          ),
          emptyCart()
        ],
      ),
    );
  }
}
