import 'package:app/providers/ShopModel.dart';
import 'package:app/providers/category_provider.dart';
import 'package:app/screens/cart_screen.dart';
import 'package:app/screens/themes/light_color.dart';
import 'package:app/screens/themes/theme.dart';
import 'package:app/utils/constants.dart';
import 'package:app/widgets/products_grid.dart';
import 'package:app/widgets/shopping_cart_float_button_widget.dart';
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
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isLiked = true;

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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed('/Menu');
        },
        isExtended: true,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        icon: Icon(Icons.restaurant),
        label: Text('Menu'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CustomScrollView(
            primary: true,
            shrinkWrap: false,
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Theme.of(context).accentColor.withOpacity(0.9),
                expandedHeight: 300,
                elevation: 0,
                iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Hero(
                    tag: widget.shop.id,
                    child: CachedNetworkImage(
                      imageUrl: widget.shop.image,
                      fit: BoxFit.cover,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                                  value: downloadProgress.progress),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Wrap(
//              crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              widget.shop.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.display2,
                            ),
                          ),
                          SizedBox(
                            width: 45,
                            height: 45,
                            child: FlatButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(widget.shop.rate.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .body2
                                          .merge(TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor))),
                                  Icon(
                                    Icons.star_border,
                                    color: Theme.of(context).primaryColor,
                                    size: 18,
                                  ),
                                ],
                              ),
                              color: Theme.of(context)
                                  .accentColor
                                  .withOpacity(0.9),
                              shape: StadiumBorder(),
                            ),
                          ),
                          SizedBox(width: 10),
                          SizedBox(
                            width: 45,
                            height: 45,
                            child: FlatButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {
                                Navigator.of(context).pushNamed('/Chat');
                              },
                              child: Icon(
                                Icons.chat,
                                color: Theme.of(context).primaryColor,
                                size: 24,
                              ),
                              color: Theme.of(context)
                                  .accentColor
                                  .withOpacity(0.9),
                              shape: StadiumBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: Text(widget.shop.description),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                        leading: Icon(
                          Icons.stars,
                          color: Theme.of(context).hintColor,
                        ),
                        title: Text(
                          'Information',
                          style: Theme.of(context).textTheme.display1,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        "Product available pincodes - " + widget.shop.zipcodes,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.body2,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      color: Theme.of(context).primaryColor,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              widget.shop.landmark,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.body2,
                            ),
                          ),
                          SizedBox(width: 10),
                          SizedBox(
                            width: 42,
                            height: 42,
                            child: FlatButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {},
                              child: Icon(
                                Icons.directions,
                                color: Theme.of(context).primaryColor,
                                size: 24,
                              ),
                              color: Theme.of(context)
                                  .accentColor
                                  .withOpacity(0.9),
                              shape: StadiumBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      dense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      leading: Icon(
                        Icons.trending_up,
                        color: Theme.of(context).hintColor,
                      ),
                      title: Text(
                        'Trending This Week',
                        style: Theme.of(context).textTheme.display1,
                      ),
                      subtitle: Text(
                        'Double click on the food to add it to the cart',
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            .merge(TextStyle(fontSize: 11)),
                      ),
                    ),
                    ProductsGrid(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                        leading: Icon(
                          Icons.recent_actors,
                          color: Theme.of(context).hintColor,
                        ),
                        title: Text(
                          'What They Say ?',
                          style: Theme.of(context).textTheme.display1,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                        leading: Icon(
                          Icons.restaurant,
                          color: Theme.of(context).hintColor,
                        ),
                        title: Text(
                          'Featured Foods',
                          style: Theme.of(context).textTheme.display1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 32,
            right: 20,
            child: ShoppingCartFloatButtonWidget(
              iconColor: Theme.of(context).primaryColor,
              labelColor: Theme.of(context).hintColor,
              labelCount: 1,
            ),
          ),
        ],
      ),
    );
  }
}
