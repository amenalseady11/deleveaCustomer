// ignore: must_be_immutable
import 'package:app/providers/cart.dart';
import 'package:app/providers/product_model.dart';
import 'package:app/widgets/shopping_cart_float_button_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductSingleView extends StatefulWidget {
  final ProductModel product;

  ProductSingleView({Key key, this.product}) : super(key: key);

  @override
  productWidgetState createState() {
    return productWidgetState();
  }
}

class productWidgetState extends State<ProductSingleView> {
  int cartCount = 0;
  int quantity = 1;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

//  double price = 13.95;
  double totalPrice = 0.00;

  @override
  void initState() {
    totalPrice = widget.product.price;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 120),
            padding: EdgeInsets.only(bottom: 15),
            child: CustomScrollView(
              primary: true,
              shrinkWrap: false,
              slivers: <Widget>[
                SliverAppBar(
                  backgroundColor:
                      Theme.of(context).accentColor.withOpacity(0.9),
                  expandedHeight: 300,
                  elevation: 0,
                  iconTheme:
                      IconThemeData(color: Theme.of(context).primaryColor),
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: Hero(
                      tag: widget.product.id,
                      child: CachedNetworkImage(
                        imageUrl: widget.product.image,
                        // <===   Add your own image to assets or use a .network image instead.
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Wrap(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: Text(
                                widget.product.title,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: Theme.of(context).textTheme.headline3,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    widget.product.discount,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Text(widget.product.description),
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                          leading: Icon(
                            Icons.recent_actors,
                            color: Theme.of(context).hintColor,
                          ),
                          title: Text(
                            'Reviews',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 32,
            right: 20,
            child: ShoppingCartFloatButtonWidget(
              iconColor: Theme.of(context).primaryColor,
              labelColor: Theme.of(context).hintColor,
              labelCount: this.cartCount,
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: 140,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).focusColor.withOpacity(0.15),
                        offset: Offset(0, -2),
                        blurRadius: 5.0)
                  ]),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'Quantity',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  this.quantity =
                                      this.decrementQuantity(this.quantity);
                                });
                              },
                              iconSize: 30,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 10),
                              icon: Icon(Icons.remove_circle_outline),
                              color: Theme.of(context).hintColor,
                            ),
                            Text(quantity.toString(),
                                style: Theme.of(context).textTheme.subtitle1),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  this.quantity =
                                      this.incrementQuantity(this.quantity);
                                });
                              },
                              iconSize: 30,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 10),
                              icon: Icon(Icons.add_circle_outline),
                              color: Theme.of(context).hintColor,
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: FlatButton(
                              onPressed: () {},
                              padding: EdgeInsets.symmetric(vertical: 14),
                              color: Theme.of(context).accentColor,
                              shape: StadiumBorder(),
                              child: Icon(
                                Icons.favorite,
                                color: Theme.of(context).primaryColor,
                              )),
                        ),
                        SizedBox(width: 10),
                        Stack(
                          fit: StackFit.loose,
                          alignment: AlignmentDirectional.centerEnd,
                          children: <Widget>[
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 110,
                              child: FlatButton(
                                onPressed: () {
                                  setState(() {
                                    this.cartCount += this.quantity;
                                    addToCart();
                                  });
                                },
                                padding: EdgeInsets.symmetric(vertical: 14),
                                color: Theme.of(context).accentColor,
                                shape: StadiumBorder(),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Text(
                                    'Add to Cart',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                totalPrice.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    .merge(TextStyle(
                                        color: Theme.of(context).primaryColor)),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  incrementQuantity(int quantity) {
    if (quantity <= 99) {
      this.totalPrice = widget.product.price * ++quantity;
      return quantity;
    } else {
      return quantity;
    }
  }

  void addToCart() async {
    await Provider.of<Cart>(context, listen: false)
        .fetchIncompleteOrderId(
            productId: widget.product.id,
            merchantId: widget.product.merchant,
            quantity: quantity)
        .then((value) {
      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
            'Added item to cart!',
          ),
          duration: Duration(seconds: 2),
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: () {},
          ),
        ),
      );
    });
  }

  decrementQuantity(int quantity) {
    if (quantity > 1) {
      this.totalPrice = widget.product.price * --quantity;
      return quantity;
    } else {
      return quantity;
    }
  }

  String getPrice(double price) {
    return '\$' + price.toString();
  }
}
