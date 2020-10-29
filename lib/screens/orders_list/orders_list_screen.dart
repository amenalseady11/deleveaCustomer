import 'package:app/providers/orders.dart';
import 'package:app/screens/orders_list/order_list_item.dart';
import 'package:app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersList extends StatelessWidget {
  static const routeName = '/pastOrders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: Provider.of<Orders>(context).fetchPastOrders(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.error != null) {
                    // ...
                    // Do error handling stuff
                    return Center(
                      child: Text('An error occurred!'),
                    );
                  } else {
                    return Consumer<Orders>(builder: (ctx, order, child) {
                      return Column(
                        children: [
                          order.pastOrders.length < 1
                              ? emptyCart()
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: order.pastOrders.length,
                                  itemBuilder: (ctx, i) =>
                                      OrderListItem(order.pastOrders[i]),
                                  scrollDirection: Axis.vertical,
                                )
                        ],
                      );
                    });
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

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
          'Order history is Empty!!',
          style: TextStyle(color: kPrimaryColor, fontSize: 20),
        )
      ],
    );
  }
}
