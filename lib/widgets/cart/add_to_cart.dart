import 'package:app/providers/cart.dart';
import 'package:app/providers/product_model.dart';
import 'package:app/screens/themes/light_color.dart';
import 'package:app/utils/constants.dart';
import 'package:flutter/material.dart';

class AddToCartContainer extends StatefulWidget {
  final Cart _cart;
  final ProductModel _productModel;

  AddToCartContainer(this._cart, this._productModel);

  @override
  _AddToCartContainerState createState() => _AddToCartContainerState();
}

class _AddToCartContainerState extends State<AddToCartContainer> {
  int _quantity = 0;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: LightColor.iconColor, style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(13)),
                  color: Theme.of(context).backgroundColor,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Color(0xfff8f8f8),
                        blurRadius: 5,
                        spreadRadius: 10,
                        offset: Offset(5, 5)),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: IconButton(
                        icon: Icon(
                          Icons.remove,
                          color: LightColor.yellowColor,
                        ),
                        onPressed: () {
                          if (_quantity > 0) {
                            _quantity--;
                            addToCart();
                            setState(() {});
                          }
                        },
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    Text(
                      '$_quantity',
                      style: TextStyle(color: kTextColor, fontSize: 16),
                    ),
                    Flexible(
                      child: IconButton(
                        icon: Icon(
                          Icons.add,
                          color: LightColor.yellowColor,
                        ),
                        onPressed: () {
                          _quantity++;
                          addToCart();
                          setState(() {});
                        },
                        color: Theme.of(context).accentColor,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Text('ADD TO CART')

        ],
      ),
    );
  }

  void addToCart() async {
    await widget._cart
        .fetchIncompleteOrderId(
            productId: widget._productModel.id,
            merchantId: widget._productModel.merchant,
            quantity: _quantity)
        .then((value) {
      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Added item to cart!',
          ),
          duration: Duration(seconds: 2),
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: () {
              widget._cart.removeSingleItem(widget._productModel.id);
            },
          ),
        ),
      );
    });
  }
}
