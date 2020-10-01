import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OfferCard extends StatefulWidget {

  @override
  _OfferCardState createState() => _OfferCardState();
}

class _OfferCardState extends State<OfferCard> {
  final PageController _controller = new PageController();
  double currentPage = 0;

  @override
  void initState() {
    _controller.addListener((){
      setState(() {
        currentPage = _controller.page;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Container(
          padding: new EdgeInsets.symmetric(
           vertical: 10,
            horizontal: 10
          ),
          decoration: new BoxDecoration(color: Colors.white),
          child: new Stack(
              alignment: FractionalOffset.topCenter,
              children: <Widget>[
                new PageView(
                  children: <Widget>[

                  ],
                  controller: _controller,
                ),
                Positioned(
                  bottom: 10,
                  child: new Container(
                    child: DotsIndicator(dotsCount: 3,),
                  ),
                )
              ]),
        ));
  }
}