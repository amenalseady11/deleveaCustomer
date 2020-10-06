import 'package:app/providers/product_provider.dart';
import 'package:app/screens/dashboard/mainPage.dart';
import 'package:app/screens/forgot_password/forgot_password_screen.dart';
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
            primarySwatch: Colors.green,
            accentColor: Colors.greenAccent,
            fontFamily: 'Lato',
          ),
          home: SplashScreen(),
          routes: {
            SplashScreenIntro.routeName: (ctx) => SplashScreenIntro(),
            ProductDetailPage.routeName: (ctx) => ProductDetailPage(),
            CartScreen.routeName: (ctx) => CartScreen(),
            MainPage.routeName: (context) => MainPage(),
            ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
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
