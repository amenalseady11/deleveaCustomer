import 'package:app/providers/product_provider.dart';
import 'package:app/widgets/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductProvider>(context);
    final products = productsData.items;
    return products.length > 0
        ? Container(
            height: 210,
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(10.0),
              itemCount: products.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, index) {
                double _marginLeft = 0;
                (index == 0) ? _marginLeft = 20 : _marginLeft = 0;
                return ChangeNotifierProvider.value(
                  // builder: (c) => products[i],
                  value: products[index],
                  child: ProductItem(
                    heroTag: 'shop_menu',
                    marginLeft: _marginLeft,
                  ),
                );
              },
            ),
          )
        : Container(
            child: LoadingListPage(),
            height: 200,
          );
  }
}
