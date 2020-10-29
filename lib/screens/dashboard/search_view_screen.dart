import 'package:app/providers/category_provider.dart';
import 'package:app/screens/dashboard/shop_list_widget.dart';
import 'package:app/screens/themes/light_color.dart';
import 'package:app/screens/themes/theme.dart';
import 'package:app/widgets/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/extentions.dart';

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  bool _isLoading = false;
  String keyword = "";

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      children: [
        SizedBox(
          height: 20,
        ),
        _search(),
        _isLoading
            ? Container(
                child: LoadingListPage(),
                height: 300,
              )
            : ShopList(isSearch: true,)
      ],
    );
  }

  _searchShop() async {
    if (keyword.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductCategory>(context, listen: false)
          .searchShops(keyword)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  Widget _search() {
    return Container(
      margin: AppTheme.padding,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 45,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: LightColor.lightGrey.withAlpha(100),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: TextFormField(
                onChanged: (newValue) => keyword = newValue,
                onSaved: (newValue) => keyword = newValue,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search Products",
                    hintStyle: TextStyle(fontSize: 18),
                    prefixIcon: Icon(Icons.filter_list, color: Colors.black54)),
              ),
            ),
          ),
          SizedBox(width: 20),
          _icon(Icons.search, color: Colors.black54)
        ],
      ),
    );
  }

  Widget _icon(IconData icon, {Color color = LightColor.iconColor}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(13)),
          color: Theme.of(context).backgroundColor,
          boxShadow: AppTheme.shadow),
      child: Icon(
        icon,
        color: color,
      ),
    ).ripple(() {
      _searchShop();
    }, borderRadius: BorderRadius.all(Radius.circular(13)));
  }
}
