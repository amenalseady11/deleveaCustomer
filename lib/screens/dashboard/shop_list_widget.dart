import 'package:app/providers/category_provider.dart';
import 'package:app/screens/themes/theme.dart';
import 'package:app/widgets/product_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopList extends StatelessWidget {
  final bool isSearch;

  ShopList(this.isSearch);

  @override
  Widget build(BuildContext context) {
    final catData = Provider.of<ProductCategory>(context);
    final shops = isSearch ? catData.searchShopList : catData.shopsList;
    return shops.length > 0
        ? Container(

            width: AppTheme.fullWidth(context),
            height: AppTheme.fullHeight(context),
            child: GridView(
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2 / 3,
                  mainAxisSpacing: .5,
                  crossAxisSpacing: 10),
              scrollDirection: Axis.vertical,
              children: shops
                  .map(
                    (product) => ProductCard(
                      product: product,
                    ),
                  )
                  .toList(),
            ),
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
