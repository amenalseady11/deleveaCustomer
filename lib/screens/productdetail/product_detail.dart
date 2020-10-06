import 'package:app/providers/ShopModel.dart';
import 'package:app/providers/category_provider.dart';
import 'package:app/screens/cart_screen.dart';
import 'package:app/screens/themes/light_color.dart';
import 'package:app/screens/themes/theme.dart';
import 'package:app/utils/constants.dart';
import 'package:app/widgets/icon_widget.dart';
import 'package:app/widgets/products_grid.dart';
import 'package:app/widgets/title_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatefulWidget {
  ProductDetailPage({Key key, this.shop}) : super(key: key);
  static const routeName = '/product-detail';
  final ShopModel shop;

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  String initialPincode = "";
  final _pinCodeController = TextEditingController();
  String pinCode;
  var _isLoading = false;
  var _isAvailable = false;

  @override
  void initState() {
    super.initState();
    pinCode = Provider.of<ProductCategory>(context, listen: false).pincode;
    _pinCodeController.text = pinCode;
    checkAvailability(pinCode);

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInToLinear));
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool isLiked = true;

  Widget _appBar() {
    return Container(
      padding: AppTheme.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconDisplay(
            Icons.arrow_back_ios,
            color: Colors.black54,
            size: 15,
            padding: 12,
            isOutLine: true,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          IconDisplay(isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? LightColor.red : LightColor.lightGrey,
              size: 15,
              padding: 12,
              isOutLine: false, onPressed: () {
            setState(() {
              isLiked = !isLiked;
            });
          }),
        ],
      ),
    );
  }

  Widget _productImage() {
    return AnimatedBuilder(
      builder: (context, child) {
        return AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: animation.value,
          child: child,
        );
      },
      animation: animation,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          TitleText(
            text: "DELEVEA",
            fontSize: 80,
            color: LightColor.lightGrey,
          ),
          CachedNetworkImage(
            imageUrl: widget.shop.image,
          )
        ],
      ),
    );
  }

  void checkAvailability(String pinCode) {
    var zipCodes = widget.shop.zipcodes.split(",");
    for (var i in zipCodes) {
      if (i.trim() == pinCode) {
        _isAvailable = true;
        break;
      } else
        _isAvailable = false;
    }
    setState(() {
      _isLoading = false;
    });
  }

  Widget _detailWidget() {
    return DraggableScrollableSheet(
      maxChildSize: 1,
      initialChildSize: .5,
      minChildSize: .5,
      builder: (context, scrollController) {
        return Container(
          padding: AppTheme.padding.copyWith(bottom: 0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              color: Colors.white),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(height: 5),
                Container(
                  alignment: Alignment.center,
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                        color: LightColor.iconColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                          child:
                              TitleText(text: widget.shop.name, fontSize: 25)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(Icons.star,
                                  color: LightColor.yellowColor, size: 17),
                              Icon(Icons.star,
                                  color: LightColor.yellowColor, size: 17),
                              Icon(Icons.star,
                                  color: LightColor.yellowColor, size: 17),
                              Icon(Icons.star,
                                  color: LightColor.yellowColor, size: 17),
                              Icon(Icons.star_border, size: 17),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                _description(),
                //_availableColor(),
                SizedBox(
                  height: 20,
                ),
                _availableProducts(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _availableProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TitleText(
          text: _isAvailable ? "Item Available" : "Item is not available",
          fontSize: 14,
          color: _isAvailable ? Colors.green : Colors.red,
        ),
        Row(
          children: [
            Container(
                width: 120,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Enter PinCode'),
                  controller: _pinCodeController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'PinCode is empty!';
                    }
                    return null;
                  },
                  onChanged: (newValue) => pinCode = newValue,
                  onSaved: (value) {
                    pinCode = value;
                  },
                )),
            SizedBox(
              width: 20,
            ),
            _isLoading
                ? CircularProgressIndicator()
                : FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: kPrimaryColor,
                    onPressed: () {
                      checkAvailability(pinCode);
                    },
                    child: Text(
                      "Check",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
          ],
        ),
        SizedBox(height: 20),
        ProductsGrid()
      ],
    );
  }

  Widget _description() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TitleText(
          text: widget.shop.description,
          fontSize: 14,
        ),
        //Text(AppData.description),
      ],
    );
  }

  FloatingActionButton _flotingButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(context, CartScreen.routeName);
      },
      backgroundColor: LightColor.orange,
      child: Icon(Icons.shopping_basket,
          color: Theme.of(context).floatingActionButtonTheme.backgroundColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //   floatingActionButton: _flotingButton(),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Color(0xfffbfbfb),
              Color(0xfff7f7f7),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  _appBar(),
                  _productImage(),
                ],
              ),
              _detailWidget()
            ],
          ),
        ),
      ),
    );
  }
}
