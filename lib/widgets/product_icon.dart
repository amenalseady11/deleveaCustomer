import 'package:app/providers/category.dart';
import 'package:app/screens/themes/light_color.dart';
import 'package:app/screens/themes/theme.dart';
import 'package:app/widgets/extentions.dart';
import 'package:app/widgets/title_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProductIcon extends StatelessWidget {
  // final String imagePath;
  // final String text;
  final ValueChanged<CategoryModel> onSelected;
  final CategoryModel model;

  ProductIcon({Key key, this.model, this.onSelected, this.handler})
      : super(key: key);
  final Function handler;

  Widget build(BuildContext context) {
    return model.id == null
        ? Container(width: 5)
        : InkWell(
            splashColor: Theme.of(context).accentColor.withOpacity(0.08),
            highlightColor: Colors.transparent,
            onTap: () {
              handler(model.id);
              onSelected(model);
              },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: model.id,
                  child: CachedNetworkImage(
                    imageUrl: model.image,
                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                        CircularProgressIndicator(value: downloadProgress.progress),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    imageBuilder: (ctx, imageProvider) => Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: imageProvider,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    model.title,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ],
            ),
          );
  }
}
