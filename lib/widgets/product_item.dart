import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:app/providers/product_model.dart';
import 'package:app/screens/themes/light_color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import 'cart/add_to_cart.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final product = Provider.of<ProductModel>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return Container(
      height: 120,
      child: Row(
        children: <Widget>[
          CachedNetworkImage(
              imageUrl: product.image,
              fit: BoxFit.cover,
              width: deviceSize.width * .3),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4),
            width: deviceSize.width * .3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: Text(
                    product.title,
                    style: TextStyle(color: LightColor.black, fontSize: 13),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Rs ${product.price}',
                  style: TextStyle(color: LightColor.black, fontSize: 13),
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.star, color: LightColor.yellowColor, size: 15),
                    Icon(Icons.star, color: LightColor.yellowColor, size: 15),
                    Icon(Icons.star, color: LightColor.yellowColor, size: 15),
                    Icon(Icons.star, color: LightColor.yellowColor, size: 15),
                    Icon(Icons.star_border, size: 17),
                  ],
                )
              ],
            ),
          ),
          AddToCartContainer(cart, product),

        ],
      ),
    );
  }
}
