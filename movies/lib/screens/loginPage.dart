import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:movies/custom/BorderIcon.dart';
import 'package:movies/main.dart';
import 'package:movies/screens/SignupPage.dart';
import 'package:movies/screens/LandingPage.dart';
import 'package:movies/utils/constants.dart';
import 'package:movies/utils/widget_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<LoginPage> {
 
  TextEditingController _pass = TextEditingController();
   TextEditingController _email = TextEditingController();

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  Future<void> SignInUser(String memail, String mpassword,BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: memail, password: mpassword);

      if (userCredential.user != null) {
        // back to landing page
        showText("Tusanyuse okulaba ;-)");
         Navigator.of(context).push(MaterialPageRoute(
           builder: (context) => LandingPage()));
        //main();

      } else {
        // something went wrong
        showText("somewthing went wrong");
        showText("somewthing went wrong");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print("no such user");
        showText(e.toString());
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        showText(e.toString());
      }
    } catch (e) {
      showText(e.toString());
      print(e);
    }
  }

  void showText(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    
    final ThemeData themeData = Theme.of(context);
    return SafeArea(
        child: Scaffold(
      backgroundColor: COLOR_WHITE,
      appBar: AppBar(
        title: Text("Login n' Book"),
      ),
      body: Center(
          child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 18.0),
        child: Form(
            key: formkey,
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    addVerticalSpace(10),
                    BorderIcon(
                        height: 150,
                        width: 150,
                        child: Icon(
                          Icons.person,
                          color: COLOR_BLACK,
                        )),
                    addVerticalSpace(30),
                    Text(
                      "Please login",
                      style: TextStyle(fontSize: 25, color: COLOR_BLACK),
                    )
                  ],
                ),
                addVerticalSpace(60),
                TextFormField(
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "* Required";
                    } else
                      return null;
                  },
                 controller: _email,
                  decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(fontSize: 20),
                      filled: true),
                ),
                addVerticalSpace(20),
                TextFormField(
                  controller: _pass,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "* Required";
                    } else if (value.length < 6) {
                      return "Password should be atleast 6 characters";
                    } else
                      return null;
                  },
                  // onSaved: (String password) {
                  // this._password = password;
                  //},
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(fontSize: 20),
                      filled: true),
                ),
                addVerticalSpace(20),
                Column(
                  children: <Widget>[
                    ButtonTheme(
                      height: 50,
                      disabledColor: COLOR_GREY,
                      child: RaisedButton(
                        disabledElevation: 4,
                        onPressed: () {
                          if (formkey.currentState.validate()) {
                            // firebase login
                            SignInUser(_email.text, _pass.text,context);
                          } else {
                            showText("Fill the fields correctly");
                          }
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(fontSize: 20, color: COLOR_WHITE),
                        ),
                      ),
                    ),
                    addVerticalSpace(10),
                    InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                           builder: (context) => SignupPage()));
                        },
                        child: BorderIcon(
                          child: Text(
                            "Need an Account?",
                            style: themeData.textTheme.headline5,
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                        )),
                  ],
                )
              ],
            )),
      )),
    ));
  }

  @override
  void dispose() {
    _pass.dispose();
    super.dispose();
  }
}

/*Fluttertoast.showToast(
        msg: "This is Center Short Toast",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );*/
