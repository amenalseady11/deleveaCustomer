import 'package:app/models/order_data.dart';
import 'package:app/screens/themes/light_color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class OrderListItem extends StatelessWidget {
  final OrderData orderData;

  OrderListItem(this.orderData);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
          color: LightColor.lightGrey.withAlpha(100),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: orderData.image,
            height: double.infinity,
            width: 100,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(orderData.title,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                    fontWeight: FontWeight.w700,
                  )),
              SizedBox(height: 16),
              Text(
                'Total: ₹${(orderData.price)}',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
          Container(
            width: 35,
            height: 35,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: LightColor.lightGrey.withAlpha(150),
                borderRadius: BorderRadius.circular(10)),
            child: Text('x${1}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                )),
          ),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: LightColor.lightGrey.withAlpha(150),
                borderRadius: BorderRadius.circular(4)),
            child: Text(
              orderData.orderStatus == 1 ? 'Accepted' : 'Pending',
              style: TextStyle(
                  color: orderData.orderStatus == 1 ? Colors.green : Colors.orange,
                  fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
