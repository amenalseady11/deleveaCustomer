import 'package:app/providers/auth.dart';
import 'package:app/screens/orders_list/orders_list_screen.dart';
import 'package:app/screens/profile/profile_list_item.dart';
import 'package:app/screens/sign_in/sign_in_screen.dart';
import 'package:app/utils/constants.dart';
import 'package:app/widgets/app_bar_common.dart';
import 'package:app/widgets/profile_avatar_widget.dart';
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
                          backgroundImage: AssetImage('assets/images/user.jpg'),
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
       /*           Padding(
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
                  )*/
                ],
              );
            });
          }
        }
      },
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: Column(
        children: <Widget>[
          ProfileAvatarWidget(),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            leading: Icon(
              Icons.person,
              color: Theme.of(context).hintColor,
            ),
            title: Text(
              'About',
              style: Theme.of(context).textTheme.display1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical professor Read More',
              style: Theme.of(context).textTheme.body1,
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            leading: Icon(
              Icons.shopping_basket,
              color: Theme.of(context).hintColor,
            ),
            title: Text(
              'Recent Orders',
              style: Theme.of(context).textTheme.display1,
            ),
          ),

        ],
      ),
    );
  }


}
