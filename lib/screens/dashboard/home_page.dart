import 'dart:ui';

import 'package:app/providers/category_provider.dart';
import 'package:app/screens/dashboard/shop_list_widget.dart';
import 'package:app/screens/sign_in/sign_in_screen.dart';
import 'package:app/screens/themes/theme.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/carousel_widget.dart';
import 'package:app/widgets/default_button.dart';
import 'package:app/widgets/form_error.dart';
import 'package:app/widgets/product_icon.dart';
import 'package:app/widgets/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _isInit = true;
  var _isLoading = false;
  int catId = 1;
  var pinCode = "";
  final List<String> errors = [];
  final _formKey = GlobalKey<FormState>();




  void showCategoryProducts(int catId) async {
    _isLoading = true;
    await Provider.of<ProductCategory>(context, listen: false)
        .fetchCategoryShops(catId)
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }



  Widget _categoryWidget() {
    final catData = Provider.of<ProductCategory>(context);
    final categories = catData.items;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: AppTheme.fullWidth(context),
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: categories
            .map(
              (category) => ProductIcon(
                model: category,
                handler: showCategoryProducts,
                onSelected: (model) {
                  setState(() {
                    categories.forEach((item) {
                      item.isSelected = false;
                    });
                    model.isSelected = true;
                  });
                },
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _categoryTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 0),
        leading: Icon(
          Icons.category,
          color: Theme.of(context).hintColor,
        ),
        title: Text(
          'Categories',
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        child: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 150,
              child: CarouselWithIndicator(),
            ),
            _categoryTitle(),
            _categoryWidget(),
            _isLoading
                ? Container(
                    child: LoadingListPage(),
                    height: 300,
                  )
                : ShopList(isSearch: false,)
          ],
        ),
      ),
    );
  }
}
