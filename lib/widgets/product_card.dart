import 'package:app/providers/ShopModel.dart';
import 'package:app/providers/product_provider.dart';
import 'package:app/screens/product_detail.dart';
import 'package:app/screens/themes/light_color.dart';
import 'package:app/widgets/extentions.dart';
import 'package:app/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final ShopModel product;
  //final ValueChanged<ShopModel> onSelected;

  ProductCard({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: LightColor.background,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: <BoxShadow>[
          BoxShadow(color: Color(0xfff8f8f8), blurRadius: 15, spreadRadius: 10),
        ],
      ),
     // margin: EdgeInsets.symmetric(vertical: !product.isSelected ? 20 : 0),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            left: 0,
            top: 0,
            child: IconButton(
              icon: Icon(
                product.isSelected ? Icons.favorite : Icons.favorite_border,
                color:
                    product.isSelected ? LightColor.red : LightColor.iconColor,
              ),
              onPressed: () {},
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(height: product.isSelected ? 15 : 0),
              CircleAvatar(
                backgroundImage: NetworkImage(product.image),
                radius: 60,
                backgroundColor: LightColor.orange.withAlpha(40),
              ),
              Center(
                child: TitleText(
                  text: product.name,
                  fontSize: product.isSelected ? 16 : 14,
                ),
              ),
              TitleText(
                text: "Min Rs.200",
                fontSize: product.isSelected ? 18 : 16,
              ),
            ],
          ),
          // SizedBox(height: 5),
        ],
      ),
    ).ripple(() {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(
              shop: product,
            ),
          ));
      Provider.of<ProductProvider>(context, listen: false)
          .fetchProducts(product.id.toString())
          .then((_) {});
    }, borderRadius: BorderRadius.all(Radius.circular(20)));
  }
}
