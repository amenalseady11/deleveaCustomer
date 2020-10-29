import 'package:app/providers/category_provider.dart';
import 'package:app/providers/product_provider.dart';
import 'package:app/screens/productdetail/product_detail.dart';
import 'package:app/screens/themes/theme.dart';
import 'package:app/widgets/shop_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopList extends StatelessWidget {
  final bool isSearch;
  final Function handler;

  ShopList({this.handler, this.isSearch});

  @override
  Widget build(BuildContext context) {
    final catData = Provider.of<ProductCategory>(context);
    final shops = isSearch ? catData.searchShopList : catData.shopsList;
    return shops.length > 0
        ? Container(
            width: AppTheme.fullWidth(context),
            height: AppTheme.fullHeight(context) * .4,
            child: ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: shops.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailPage(
                              shop: shops[index],
                            ),
                          ));
                      await Provider.of<ProductProvider>(context, listen: false)
                          .fetchProducts(shops[index].id.toString())
                          .then((_) {});
                    },
                    child: ShopCardWidget(
                      handler: handler,
                      shopModel: shops[index],
                    ),
                  );
                }),
          )
        : Center(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              height: 200,
              width: 250,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8,
                      color: Theme.of(context).backgroundColor,
                      offset: Offset(0, 2),
                    )
                  ],
                  image: DecorationImage(
                      image: AssetImage("assets/images/ic_no_data.png"))),
            ),
          );
  }
}
