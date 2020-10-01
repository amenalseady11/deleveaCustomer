import 'package:app/models/http_exception.dart';
import 'package:app/providers/auth.dart';
import 'package:app/screens/sign_in/sign_in_screen.dart';
import 'package:app/widgets/default_button.dart';
import 'package:app/widgets/form_error.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:app/utils/constants.dart';
import '../../../utils/size_config.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String email;
  String mobile;
  String userName;
  String password;
  bool remember = false;
  final List<String> errors = [];
  var _isLoading = false;

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
    });
    try {
      // Log user in
      await Provider.of<Auth>(context, listen: false)
          .signupUser(userName, password, email)
          .then((value) => {
                if (value) {_showDialog('Signup success', true)}
              });
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.errorCode == 101) {
        errorMessage = 'Password is weak';
      } else if (error.errorCode == 102) {
        errorMessage = 'Username already exists.';
      }
      else if (error.errorCode == 103) {
        errorMessage = 'This email address is already in use.';
      }
      _showDialog(errorMessage, false);
    } catch (error) {
      const errorMessage = 'Signup failed. please recheck your given data.';
      _showDialog(errorMessage, false);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showDialog(String message, bool isLogged) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isLogged ? 'Sign up' : 'An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
              if (isLogged)
                Navigator.of(context)
                    .pushReplacementNamed(SignInScreen.routeName);
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildNameField(),
          SizedBox(height: getProportionateScreenHeight(10)),
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(10)),
          buildMobileField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          _isLoading
              ? CircularProgressIndicator()
              : DefaultButton(
                  text: "Sign up",
                  press: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      // if all are valid then go to success screen
                      _submit();
                    }
                  },
                ),
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty && errors.contains(kPassNullError)) {
          setState(() {
            errors.remove(kPassNullError);
          });
        } else if (value.length >= 8 && errors.contains(kShortPassError)) {
          setState(() {
            errors.remove(kShortPassError);
          });
          return "";
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty && !errors.contains(kPassNullError)) {
          setState(() {
            errors.add(kPassNullError);
          });
          return "";
        } else if (value.length < 8 && !errors.contains(kShortPassError)) {
          setState(() {
            errors.add(kShortPassError);
          });
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Container(child: Icon(FontAwesomeIcons.lock)),
      ),
    );
  }

  TextFormField buildNameField() {
    return TextFormField(
      keyboardType: TextInputType.name,
      onSaved: (newValue) => userName = newValue,
      decoration: InputDecoration(
        labelText: "Full Name",
        hintText: "Enter your Name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Container(child: Icon(FontAwesomeIcons.userNinja)),
      ),
    );
  }

  TextFormField buildMobileField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      onSaved: (newValue) => mobile = newValue,
      decoration: InputDecoration(
        labelText: "Mobile Number",
        hintText: "Enter your mobile number",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Container(child: Icon(FontAwesomeIcons.mobile)),
      ),
    );
  }

  TextFormField buildAddressField() {
    return TextFormField(
      keyboardType: TextInputType.streetAddress,
      decoration: InputDecoration(
        labelText: "Address",
        hintText: "Enter your address",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Container(child: Icon(FontAwesomeIcons.streetView)),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty && errors.contains(kEmailNullError)) {
          setState(() {
            errors.remove(kEmailNullError);
          });
        } else if (emailValidatorRegExp.hasMatch(value) &&
            errors.contains(kInvalidEmailError)) {
          setState(() {
            errors.remove(kInvalidEmailError);
          });
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty && !errors.contains(kEmailNullError)) {
          setState(() {
            errors.add(kEmailNullError);
          });
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value) &&
            !errors.contains(kInvalidEmailError)) {
          setState(() {
            errors.add(kInvalidEmailError);
          });
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Container(child: Icon(FontAwesomeIcons.mailBulk)),
      ),
    );
  }
}
