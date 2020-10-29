import 'package:app/providers/product_provider.dart';
import 'package:app/screens/forgot_password/forgot_password_screen.dart';
import 'package:app/screens/maps/map_view.dart';
import 'package:app/screens/orders_list/orders_list_screen.dart';
import 'package:app/screens/productdetail/product_detail.dart';
import 'package:app/screens/profile/profile_screen.dart';
import 'package:app/screens/sign_in/login_success_screen.dart';
import 'package:app/screens/sign_in/sign_in_screen.dart';
import 'package:app/screens/sign_up/sign_up_screen.dart';
import 'package:app/screens/splash/splash_screen_intro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_map_location_picker/generated/l10n.dart'
    as location_picker;
import 'package:google_map_location_picker/generated/l10n.dart';
import 'package:provider/provider.dart';

import './providers/auth.dart';
import './providers/cart.dart';
import './providers/category_provider.dart';
import './providers/orders.dart';
import './screens/cart_screen.dart';
import './screens/splash_screen.dart';
import './utils/app_config.dart' as config;
import 'screens/dashboard/home_pager.dart';

void main() {
  //Stetho.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductCategory>(
          update: (ctx, auth, previousProducts) => ProductCategory(
            auth.token,
            auth.userId,
            previousProducts == null ? [] : previousProducts.items,
          ),
          // ignore: missing_return
          create: (BuildContext context) {},
        ),
        ChangeNotifierProxyProvider<Auth, ProductProvider>(
          update: (ctx, auth, previousProducts) => ProductProvider(
            auth.token,
            auth.userId,
            previousProducts == null ? [] : previousProducts.items,
          ),
          // ignore: missing_return
          create: (BuildContext context) {},
        ),
        // ignore: missing_required_param
        ChangeNotifierProxyProvider<Auth, Cart>(
          update: (ctx, auth, cart) => Cart(auth.token),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousOrders) => Orders(
            auth.token,
            auth.userId,
            previousOrders == null ? [] : previousOrders.pastOrders,
          ),
          // ignore: missing_return
          create: (BuildContext context) {},
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          localizationsDelegates: const [
            location_picker.S.delegate,
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const <Locale>[
            Locale('en', ''),
            Locale('ar', ''),
            Locale('pt', ''),
            Locale('tr', ''),
          ],
          title: 'MyShop',
          theme: ThemeData(
            fontFamily: 'Poppins',
            primaryColor: Colors.white,
            brightness: Brightness.light,
            accentColor: config.Colors().mainColor(1),
            focusColor: config.Colors().accentColor(1),
            hintColor: config.Colors().secondColor(1),
            textTheme: TextTheme(
              headline6: TextStyle(
                  fontSize: 20.0, color: config.Colors().secondColor(1)),
              headline5: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: config.Colors().secondColor(1)),
              headline4: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: config.Colors().secondColor(1)),
              headline3: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w700,
                  color: config.Colors().mainColor(1)),
              headline2: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w300,
                  color: config.Colors().secondColor(1)),
              subtitle2: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  color: config.Colors().secondColor(1)),
              subtitle1: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: config.Colors().mainColor(1)),
              bodyText1: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: config.Colors().mainColor(1)),
              bodyText2: TextStyle(
                  fontSize: 14.0, color: config.Colors().secondColor(1)),
              caption: TextStyle(
                  fontSize: 12.0, color: config.Colors().accentColor(1)),
            ),
          ),
          home: SplashScreen(),
          routes: {
            SplashScreenIntro.routeName: (ctx) => SplashScreenIntro(),
            ProductDetailPage.routeName: (ctx) => ProductDetailPage(),
            CartScreen.routeName: (ctx) => CartScreen(),
            HomePager.routeName: (context) => HomePager(),
            ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
            ShopMapViewScreen.routeName: (context) => ShopMapViewScreen(),
            SignInScreen.routeName: (context) => SignInScreen(),
            LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
            SignUpScreen.routeName: (context) => SignUpScreen(),
            ProfileScreen.routeName: (context) => ProfileScreen(),
            OrdersList.routeName: (context) => OrdersList(),
          },
        ),
      ),
    );
  }
}
