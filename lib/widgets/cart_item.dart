import 'package:app/screens/themes/light_color.dart';
import 'package:app/widgets/title_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItemWidget extends StatelessWidget {
  final int id;
  final int productId;
  final double price;
  final int quantity;
  final String title;
  final String imgUrl;

  CartItemWidget(
    this.id,
    this.productId,
    this.price,
    this.quantity,
    this.title,
    this.imgUrl,
  );

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: ValueKey(id),
        background: Container(
          color: Theme.of(context).errorColor,
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          margin: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 4,
          ),
        ),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) {
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Are you sure?'),
              content: Text(
                'Do you want to remove the item from the cart?',
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                ),
                FlatButton(
                  child: Text('Yes'),
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                ),
              ],
            ),
          );
        },
        onDismissed: (direction) {
          Provider.of<Cart>(context, listen: false).removeItem(id);
        },
        child: Container(
          height: 80,
          child: Row(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1.2,
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        height: 70,
                        width: 70,
                        child: Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: LightColor.lightGrey,
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: -20,
                      bottom: -20,
                      child: CachedNetworkImage(
                        imageUrl: imgUrl,
                        fit: BoxFit.cover,
                        height: 100,
                        width: 100,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                  child: ListTile(
                      title: TitleText(
                        text: title,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      subtitle: Row(
                        children: <Widget>[
                          TitleText(
                            text: '₹ ',
                            color: LightColor.red,
                            fontSize: 12,
                          ),
                          TitleText(
                            text: 'Total: ₹${(price * quantity)}',
                            fontSize: 14,
                          ),
                        ],
                      ),
                      trailing: Container(
                        width: 35,
                        height: 35,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: LightColor.lightGrey.withAlpha(150),
                            borderRadius: BorderRadius.circular(10)),
                        child: TitleText(
                          text: 'x${quantity}',
                          fontSize: 12,
                        ),
                      )))
            ],
          ),
        ) /*Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                  child: Text('₹$price'),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: ₹${(price * quantity)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),*/
        );
  }
}
