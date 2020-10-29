import 'package:app/providers/auth.dart';
import 'package:app/screens/dashboard/home_pager.dart';
import 'package:app/screens/splash/splash_screen_intro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      checkIsLoggedIn();
    });
  }

  void checkIsLoggedIn() async {
    setState(() {});
    final isLoggedIn =
        await Provider.of<Auth>(context, listen: false).tryAutoLogin();
    if (isLoggedIn != null && isLoggedIn)
      Navigator.of(context).pushReplacementNamed(HomePager.routeName);
    else {
      Navigator.of(context).pushReplacementNamed(SplashScreenIntro.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/images/ic_launcher.png",
              fit: BoxFit.fill,
              height: 200,
              width: 200,
            ),
            SizedBox(
              height: 10,
            ),
            Text('Loading...'),
          ],
        )),
      ),
    );
  }
}
