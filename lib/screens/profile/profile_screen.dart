import 'package:app/providers/auth.dart';
import 'package:app/screens/orders_list/orders_list_screen.dart';
import 'package:app/screens/profile/profile_list_item.dart';
import 'package:app/screens/sign_in/sign_in_screen.dart';
import 'package:app/utils/constants.dart';
import 'package:app/widgets/app_bar_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: 896, width: 414, allowFontScaling: true);

    var profileInfo = FutureBuilder(
      future: Provider.of<Auth>(context, listen: false).getUserDetails(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.error != null) {
            // ...
            // Do error handling stuff
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Center(
                child: Text('Something went wrong!! Please try again later.'),
              ),
            );
          } else {
            return Consumer<Auth>(builder: (ctx, authData, child) {
              return Wrap(
                direction: Axis.vertical,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Container(
                    height: kSpacingUnit.w * 10,
                    width: kSpacingUnit.w * 10,
                    margin: EdgeInsets.only(top: kSpacingUnit.w * 3),
                    child: Stack(
                      children: <Widget>[
                        CircleAvatar(
                          radius: kSpacingUnit.w * 5,
                          backgroundImage: AssetImage('assets/images/user.png'),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            height: kSpacingUnit.w * 2.5,
                            width: kSpacingUnit.w * 2.5,
                            decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              heightFactor: kSpacingUnit.w * 1.5,
                              widthFactor: kSpacingUnit.w * 1.5,
                              child: Icon(
                                LineAwesomeIcons.pen,
                                color: kDarkPrimaryColor,
                                size: ScreenUtil().setSp(kSpacingUnit.w * 1.5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: kSpacingUnit.w * 2),
                  Text(
                    authData.userData.name==null?'Username':authData.userData.name,
                    style: kTitleTextStyle,
                  ),
                  SizedBox(height: kSpacingUnit.w * 0.5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(height: kSpacingUnit.w * 0.8),
                        _userDataFields("Email: ", authData.userData.email),
                        SizedBox(height: kSpacingUnit.w * 0.8),
                        _userDataFields(
                            "Mobile: ",
                            authData.userData.phone == null
                                ? "8888888888"
                                : authData.userData.phone),
                        SizedBox(height: kSpacingUnit.w * 0.8),
                        _userDataFields(
                            "Address: ",
                            authData.userData.postalAddress == null
                                ? 'Vazhakal, Kakkanad'
                                : authData.userData.postalAddress),
                        SizedBox(height: kSpacingUnit.w * 0.8),
                        _userDataFields(
                            "City: ",
                            authData.userData.city == null
                                ? 'Ernakulam'
                                : authData.userData.city),
                      ],
                    ),
                  )
                ],
              );
            });
          }
        }
      },
    );

    return Builder(
      builder: (context) {
        return Scaffold(
          body: Column(
            children: <Widget>[
              SizedBox(height: kSpacingUnit.w * 5),
              AppBarCommon('My Profile'),
              profileInfo,
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    ProfileListItem(
                      icon: LineAwesomeIcons.user_shield,
                      text: 'Privacy',
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.of(context).pushNamed(OrdersList.routeName),
                      child: ProfileListItem(
                        icon: LineAwesomeIcons.alternate_first_order,
                        text: 'Order History',
                      ),
                    ),
                    ProfileListItem(
                      icon: LineAwesomeIcons.cog,
                      text: 'Settings',
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed(SignInScreen.routeName);
                        Provider.of<Auth>(context, listen: false).logout();
                      },
                      child: ProfileListItem(
                        icon: LineAwesomeIcons.alternate_sign_out,
                        text: 'Logout',
                        hasNavigation: true,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Row _userDataFields(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: kCaptionTextStyle,
        ),
        Text(
          value,
          style: kCaptionTextStyle,
        ),
      ],
    );
  }
}
