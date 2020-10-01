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
        ? ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(10.0),
            itemCount: products.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              // builder: (c) => products[i],
              value: products[i],
              child: ProductItem(),
            ),
          )
        : Container(
            child: LoadingListPage(),
            height: 200,
          );
  }
}
