import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:app/providers/ShopModel.dart';
import 'package:app/providers/category_provider.dart';
import 'package:app/screens/dashboard/shop_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class ShopMapViewScreen extends StatefulWidget {
  static String routeName = "/shop-map";

  ShopMapViewScreen({Key key, this.shop}) : super(key: key);
  final ShopModel shop;

  @override
  _ShopMapViewScreenState createState() => _ShopMapViewScreenState();
}

class _ShopMapViewScreenState extends State<ShopMapViewScreen> {
  List<Marker> allMarkers = [];
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController _mapController;
  static CameraPosition _kPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 15.4746,
  );

  void _onShopItemClicked(int shopId) {
    final shopData = Provider.of<ProductCategory>(context, listen: false)
        .findShopById(shopId);
    changeCameraPos(shopData);
    addMarker(shopData);
  }

  void changeCameraPos(ShopModel shopModel) async {
    await _mapController.animateCamera(CameraUpdate.newLatLng(LatLng(
        double.parse(shopModel.latitude), double.parse(shopModel.longitude))));
    setState(() {});
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _controller.complete(controller);
    changeCameraPos(widget.shop);
  }

//  @override
  void initState() {
    addMarker(widget.shop);
//    _getCurrentLocation();
    super.initState();
  }

  void addMarker(ShopModel shopModel) {
    getMarker(shopModel).then((value) {
      setState(() {
        allMarkers.add(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Maps Explorer',
          style: Theme.of(context)
              .textTheme
              .headline6
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () {},
          )
        ],
      ),
      body: Stack(
//        fit: StackFit.expand,
        alignment: AlignmentDirectional.bottomStart,
        children: <Widget>[
          GoogleMap(
              mapType: MapType.normal,
              myLocationEnabled: true,
              initialCameraPosition: _kPosition,
              markers: Set.from(allMarkers),
              onMapCreated: _onMapCreated),
          ShopList(isSearch: false, handler: _onShopItemClicked)
          //   CardsCarouselWidget()
        ],
      ),
    );
  }

//  Future<void> _goToTheLake() async {
//    final GoogleMapController controller = await _controller.future;
//    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
//  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  Future<Marker> getMarker(ShopModel res) async {
    final Uint8List markerIcon =
        await getBytesFromAsset("assets/images/marker.png", 120);
    final Marker marker = Marker(
        markerId: MarkerId(res.id.toString()),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        onTap: () {
          print(res.name);
        },
        infoWindow: InfoWindow(title: res.name, snippet: res.landmark),
        position: LatLng(
          double.parse(res.latitude),
          double.parse(res.longitude),
        ));
    return marker;
  }
}
