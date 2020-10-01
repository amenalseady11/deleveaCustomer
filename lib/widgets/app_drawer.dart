import 'package:app/screens/cart_screen.dart';
import 'package:app/screens/profile/profile_screen.dart';
import 'package:app/screens/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:app/utils/constants.dart';
import '../providers/auth.dart';
import '../utils/size_config.dart';
import 'drawer_header.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: <Widget>[
          DrawerHeaderWidget(),
          Divider(),
          ListTile(
            leading:
                Icon(Icons.account_circle, size: 30, color: kPrimaryLightColor),
            title: Text(
              'MY PROFILE',
              style:
                  TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.of(context).pushNamed(ProfileScreen.routeName);

            },
          ),
          ListTile(
            leading: Icon(Icons.favorite, size: 30, color: kPrimaryLightColor),
            title: Text(
              'WISH LIST',
              style:
                  TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.firstOrder,
                size: 30, color: kPrimaryLightColor),
            title: Text(
              'ORDERS',
              style:
                  TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
          ),
          ListTile(
            leading:
                Icon(Icons.exit_to_app, size: 30, color: kPrimaryLightColor),
            title: Text(
              'LOGOUT',
              style:
                  TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context)
                  .pushReplacementNamed(SignInScreen.routeName);

              // Navigator.of(context)
              //     .pushReplacementNamed(UserProductsScreen.routeName);
              Provider.of<Auth>(context, listen: false).logout();
              SizeConfig().init(context);
            },
          ),
        ],
      ),
    );
  }
}
