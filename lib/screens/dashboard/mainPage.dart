import 'package:app/screens/dashboard/favourites_screen.dart';
import 'package:app/screens/dashboard/home_page.dart';
import 'package:app/screens/dashboard/search_view_screen.dart';
import 'package:app/screens/profile/profile_screen.dart';
import 'package:app/screens/shopping_cart_page.dart';
import 'package:app/screens/themes/light_color.dart';
import 'package:app/screens/themes/theme.dart';
import 'package:flutter/material.dart';

import '../../widgets/BottomNavigationBar/bottom_navigation_bar.dart';
import '../../widgets/extentions.dart';
import '../../widgets/title_text.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);
  static String routeName = "/home";

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isHomePageSelected = true;
  int tabPosition = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget _appBar() {
    return Container(
      padding: AppTheme.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RotatedBox(
            quarterTurns: 4,
            child: _icon(Icons.sort, color: Colors.black54),
          ),
          TitleText(
            text: 'DELEVEA',
            fontSize: 27,
            fontWeight: FontWeight.w700,
          ),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(13)),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Color(0xfff8f8f8),
                      blurRadius: 10,
                      spreadRadius: 10),
                ],
              ),
              child: Image.asset("assets/images/user.png"),
            ),
          ).ripple(() {}, borderRadius: BorderRadius.all(Radius.circular(13)))
        ],
      ),
    );
  }

  Widget _icon(IconData icon, {Color color = LightColor.iconColor}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(13)),
          color: Theme.of(context).backgroundColor,
          boxShadow: AppTheme.shadow),
      child: Icon(
        icon,
        color: color,
      ),
    ).ripple(() {
      Navigator.of(context).pushNamed(ProfileScreen.routeName);
    }, borderRadius: BorderRadius.all(Radius.circular(13)));
  }

  void onBottomIconPressed(int index) {
    setState(() {
      tabPosition = index;
      isHomePageSelected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                height: AppTheme.fullHeight(context) - 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xfffbfbfb),
                      Color(0xfff7f7f7),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _appBar(),

                    // _title(),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        switchInCurve: Curves.easeInToLinear,
                        switchOutCurve: Curves.easeOutBack,
                        child: Builder(
                          builder: (context) {
                            switch (tabPosition) {
                              case 0:
                                return HomeScreen();
                              case 1:
                                return Align(
                                    alignment: Alignment.topCenter,
                                    child: SearchView());
                              case 2:
                                return Align(
                                  alignment: Alignment.topCenter,
                                  child: ShoppingCartPage(),
                                );
                              default:
                                return Align(
                                    alignment: Alignment.topCenter,
                                    child: FavouritesScreen());
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: CustomBottomNavigationBar(
                onIconPresedCallback: onBottomIconPressed,
              ),
            )
          ],
        ),
      ),
    );
  }
}
