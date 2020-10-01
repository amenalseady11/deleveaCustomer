import 'package:app/utils/constants.dart';
import 'package:app/providers/cart.dart';
import 'package:app/screens/themes/light_color.dart';
import 'package:app/screens/themes/theme.dart';
import 'package:app/widgets/cart/order_button.dart';
import 'package:app/widgets/cart_item.dart';
import 'package:app/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShoppingCartPage extends StatelessWidget {
  const ShoppingCartPage({Key key}) : super(key: key);

  Widget emptyCart() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          width: double.infinity,
          height: 200,
          child: Image.asset(
            'assets/images/empty_cart.png',
            fit: BoxFit.fill,
          ),
        ),
        Text(
          'Cart is Empty!!',
          style: TextStyle(color: kPrimaryColor, fontSize: 20),
        )
      ],
    );
  }

  Widget _title() {
    return Container(
        margin: AppTheme.padding,
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TitleText(
                  text: 'Shopping',
                  fontSize: 27,
                  fontWeight: FontWeight.w400,
                ),
                TitleText(
                  text: 'Cart',
                  fontSize: 27,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.all(10),
              child: Icon(
                Icons.delete_outline,
                color: LightColor.orange,
              ),
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _title(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: FutureBuilder(
              future: Provider.of<Cart>(context).fetchCartItems(false),
              builder: (ctx, dataSnapshot) {
                if (dataSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  if (dataSnapshot.error != null) {
                    // ...
                    // Do error handling stuff
                    return Center(
                      child: emptyCart(),
                    );
                  } else {
                    return Consumer<Cart>(
                      builder: (ctx, cart, child) => Column(children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: cart.cartItems.length,
                          itemBuilder: (ctx, i) => CartItemWidget(
                            cart.cartItems[i].id,
                            cart.cartItems[i].product,
                            cart.cartItems[i].price,
                            cart.cartItems[i].quantity,
                            cart.cartItems[i].title,
                            cart.cartItems[i].image,
                          ),
                        ),
                        // ignore: null_aware_before_operator
                        cart.cartItems?.length < 1
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 30),
                                child: emptyCart(),
                              )
                            : Divider(
                                thickness: 1,
                                height: 70,
                              ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            TitleText(
                              text: '${cart.cartItems.length} Items',
                              color: LightColor.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            TitleText(
                              text: '₹${cart.totalAmount.toStringAsFixed(2)}',
                              fontSize: 18,
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        cart.cartItems.length > 0
                            ? OrderButton(cart: cart)
                            : SizedBox(height: 30),
                      ]),
                    );
                  }
                }
              }),
        ),
      ],
    );
  }
}
