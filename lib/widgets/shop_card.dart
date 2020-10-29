import 'package:app/providers/ShopModel.dart';
import 'package:app/screens/maps/map_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ShopCardWidget extends StatelessWidget {
  final ShopModel shopModel;
  final Function handler;

  ShopCardWidget({Key key, this.handler,this.shopModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      margin: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).focusColor.withOpacity(0.1),
              blurRadius: 15,
              offset: Offset(0, 5)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // Image of the card
          CachedNetworkImage(
            imageUrl: shopModel.image,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                CircularProgressIndicator(value: downloadProgress.progress),
            errorWidget: (context, url, error) => Icon(Icons.error),
            imageBuilder: (context, imageProvider) => Container(
              width: 250,
              height: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        shopModel.name,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      Text(
                        shopModel.description,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Text(
                        shopModel.landmark + ", " + shopModel.city,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.caption,
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: List.generate(5, (index) {
                          return index < shopModel.rate
                              ? Icon(Icons.star,
                                  size: 18, color: Color(0xFFFFB24D))
                              : Icon(Icons.star_border,
                                  size: 18, color: Color(0xFFFFB24D));
                        }),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: FlatButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      print('Go to map');
                      if(handler==null) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ShopMapViewScreen(
                                shop: shopModel,
                              ),
                        ));
                      }else
                        handler(shopModel.id);
                    },
                    child: Icon(Icons.directions,
                        color: Theme.of(context).primaryColor),
                    color: Theme.of(context).accentColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
