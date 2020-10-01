import 'package:app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class DrawerHeaderWidget extends StatefulWidget {
  @override
  _DrawerHeaderState createState() => _DrawerHeaderState();
}

class _DrawerHeaderState extends State<DrawerHeaderWidget> {
  var _isInit = false;

  @override
  void initState() {
    _isInit = true;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {}
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(gradient: kPrimaryGradientColor),
      child: Container(
        child: Row(
          children: <Widget>[
            Icon(
              Icons.account_circle,
              size: 80,
              color: Color.fromRGBO(1, 14, 13, 0.6),
            ),
            SizedBox(
              width: 8,
            ),
            GestureDetector(
                onTap: () {},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Hello',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color.fromRGBO(111, 112, 109, 1)),
                    ),
                    Text("User",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: Color.fromRGBO(111, 112, 109, 1)))
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
