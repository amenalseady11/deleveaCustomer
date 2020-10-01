import 'package:app/providers/cart.dart';
import 'package:app/providers/orders.dart';
import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'package:app/utils/constants.dart';

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  orderItem() async {
    setState(() {
      _isLoading = true;
    });

    LocationResult result = await showLocationPicker(
      context,
      mapKey,
      initialCenter: LatLng(9.2648, 76.7870),
//                      automaticallyAnimateToCurrentLocation: true,
//                      mapStylePath: 'assets/mapStyle.json',
      myLocationButtonEnabled: true,
      layersButtonEnabled: true,
//                      resultCardAlignment: Alignment.bottomCenter,
    );
    print("result = $result");
    await Provider.of<Orders>(context, listen: false)
        .createShippingAddress(result.address, widget.cart.orderId);
    setState(() {
      _isLoading = false;
    });
    await widget.cart.fetchCartItems(true);
    setState(() {
      if (result != null) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Order Success'),
            content: Text(
              'Order Placed Successfully',
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        shape: StadiumBorder(),
        padding: EdgeInsets.all(0.0),
        child: _isLoading
            ? CircularProgressIndicator()
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF00b09b),
                      Color(0xFF96c93d),
                    ],
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 70.0, vertical: 15.0),
                child: Text(
                  'Order Now',
                  style: TextStyle(fontSize: 15.0, color: Colors.white),
                ),
              ),
        onPressed: () async {
          orderItem();
        },
      ),
    );
  }
}
