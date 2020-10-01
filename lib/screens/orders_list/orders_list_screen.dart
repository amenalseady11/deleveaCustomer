import 'package:app/providers/orders.dart';
import 'package:app/screens/orders_list/order_list_item.dart';
import 'package:app/utils/constants.dart';
import 'package:app/widgets/app_bar_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class OrdersList extends StatelessWidget {
  static const routeName = '/pastOrders';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: kSpacingUnit.w * 5),
          AppBarCommon('Order History'),
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
                      return ListView.builder(
                        itemCount: order.pastOrders.length,
                        itemBuilder: (ctx, i) =>
                            OrderListItem(order.pastOrders[i]),
                        scrollDirection: Axis.vertical,
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
}
