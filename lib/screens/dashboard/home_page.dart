import 'package:app/providers/category_provider.dart';
import 'package:app/screens/dashboard/shop_list_widget.dart';
import 'package:app/screens/sign_in/sign_in_screen.dart';
import 'package:app/screens/themes/theme.dart';
import 'package:app/widgets/carousel_widget.dart';
import 'package:app/widgets/product_icon.dart';
import 'package:app/widgets/shimmer_widget.dart';
import 'package:flutter/material.dart';
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

  @override
  void didChangeDependencies() {
    if (_isInit) {
      print('home');
      setState(() {
        _isLoading = true;
      });
      _isInit = false;
      try {
        Provider.of<ProductCategory>(context, listen: false)
            .fetchCategories()
            .then((_) {
          _isInit = false;

          setState(() {
            _isLoading = false;
          });
        });
        Provider.of<ProductCategory>(context, listen: false)
            .fetchCategoryShops(1)
            .then((_) {});
        _isInit = false;
      } catch (error) {
        Navigator.of(context).pushReplacementNamed(SignInScreen.routeName);
      }
    }
    super.didChangeDependencies();
  }

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
      height: 80,
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Container(
        height: double.infinity,
        child: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 150,
              child: CarouselWithIndicator(),
            ),
            _categoryWidget(),
            _isLoading
                ? Container(
                    child: LoadingListPage(),
                    height: 300,
                  )
                : ShopList(false)
          ],
        ),
      ),
    );
  }
}
