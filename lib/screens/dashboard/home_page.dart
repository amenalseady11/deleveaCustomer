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

  @override
  void didChangeDependencies() {
    if (_isInit) {
      SizeConfig().init(context);
      setState(() {
        _isLoading = true;
      });
      _isInit = false;
      try {
        Provider.of<ProductCategory>(context, listen: false)
            .fetchCategories()
            .then((_) {
          setState(() {
            _isLoading = false;
          });
        });
        Provider.of<ProductCategory>(context, listen: false)
            .fetchZipCode()
            .then((value) => {if (!value) _showModal()});
        Provider.of<ProductCategory>(context, listen: false)
            .fetchCategoryShops(1)
            .then((_) {});
      } catch (error) {
        Navigator.of(context).pushReplacementNamed(SignInScreen.routeName);
      }
    }
    super.didChangeDependencies();
  }

  TextFormField buildPincodeField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      onSaved: (newValue) => pinCode = newValue,
      onChanged: (value) {
        if (value.isNotEmpty && errors.contains(kPinCodeNullError)) {
          setState(() {
            errors.remove(kPinCodeNullError);
          });
        } else if (value.length != 6 && errors.contains(kPinCodeInvalidError)) {
          setState(() {
            errors.remove(kPinCodeInvalidError);
          });
          return "";
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty && !errors.contains(kPinCodeNullError)) {
          setState(() {
            errors.add(kPinCodeNullError);
          });
          return "";
        } else if (value.length != 6 &&
            !errors.contains(kPinCodeInvalidError)) {
          setState(() {
            errors.add(kPinCodeInvalidError);
          });
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Pincode",
        hintText: "Enter your Pincode",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Container(child: Icon(FontAwesomeIcons.city)),
      ),
    );
  }

  void updateZipcode() async {
    await Provider.of<ProductCategory>(context, listen: false)
        .updateZipCode(pinCode);
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

  void _showModal() {
    showModalBottomSheet(
        isDismissible: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      buildPincodeField(),
                      errors.length > 0
                          ? FormError(errors: errors)
                          : SizedBox(
                              height: 1,
                            ),
                      SizedBox(height: 20),
                      DefaultButton(
                        text: "Submit",
                        press: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            updateZipcode();
                            Navigator.of(context).pop();
                            // if all are valid then go to success screen
                            //
                          }
                        },
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ));
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
