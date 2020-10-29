import 'package:app/providers/category_provider.dart';
import 'package:app/screens/dashboard/favourites_screen.dart';
import 'package:app/screens/dashboard/home_page.dart';
import 'package:app/screens/dashboard/notifications_screen.dart';
import 'package:app/screens/orders_list/orders_list_screen.dart';
import 'package:app/screens/profile/profile_screen.dart';
import 'package:app/screens/sign_in/sign_in_screen.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/default_button.dart';
import 'package:app/widgets/drawer_widget.dart';
import 'package:app/widgets/form_error.dart';
import 'package:app/widgets/shopping_cart_icon.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class HomePager extends StatefulWidget {
  int currentTab = 2;
  String currentTitle = 'Home';
  Widget currentPage = HomeScreen();
  static String routeName = "/home";

  HomePager({
    Key key,
  }) : super(key: key);

  @override
  _HomePagerState createState() {
    return _HomePagerState();
  }
}

class _HomePagerState extends State<HomePager> {
  var _isInit = true;
  var _isLoading = false;
  var pinCode = "";
  final List<String> errors = [];
  final _formKey = GlobalKey<FormState>();

  initState() {
    super.initState();
    _selectTab(2);
  }
  void _selectTab(int tabItem) {
    setState(() {
      widget.currentTab = tabItem;
      switch (tabItem) {
        case 0:
          widget.currentTitle = 'Notifications';
          widget.currentPage = NotificationsWidget();
          break;
        case 1:
          widget.currentTitle = 'Profile';
          widget.currentPage = ProfileScreen();
          break;
        case 2:
          widget.currentTitle = 'Home';
          widget.currentPage = HomeScreen();
          break;
        case 3:
          widget.currentTitle = 'My Orders';
          widget.currentPage = OrdersList();
          break;
        case 4:
          widget.currentTitle = 'Favorites';
          widget.currentPage = FavoritesWidget();
          break;
      }
    });
  }

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.currentTitle,
          style: Theme.of(context)
              .textTheme
              .title
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor,
              labelColor: Theme.of(context).accentColor),
        ],
      ),
      body: widget.currentPage,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).accentColor,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        iconSize: 22,
        elevation: 0,
        backgroundColor: Colors.transparent,
        selectedIconTheme: IconThemeData(size: 28),
        unselectedItemColor: Theme.of(context).focusColor.withOpacity(1),
        currentIndex: widget.currentTab,
        onTap: (int i) {
          this._selectTab(i);
        },
        // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "f"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "f"),
          BottomNavigationBarItem(
              label: "f",
              icon: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).accentColor.withOpacity(0.4),
                        blurRadius: 40,
                        offset: Offset(0, 15)),
                    BoxShadow(
                        color: Theme.of(context).accentColor.withOpacity(0.4),
                        blurRadius: 13,
                        offset: Offset(0, 3))
                  ],
                ),
                child:
                    new Icon(Icons.home, color: Theme.of(context).primaryColor),
              )),
          BottomNavigationBarItem(
            label: "f",
            icon: new Icon(Icons.fastfood),
          ),
          BottomNavigationBarItem(
            label: "g",
            icon: new Icon(Icons.favorite),
          ),
        ],
      ),
    );
  }
}
