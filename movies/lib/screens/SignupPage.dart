import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies/custom/BorderIcon.dart';
import 'package:movies/main.dart';
import 'package:movies/screens/LandingPage.dart';
import 'package:movies/screens/loginPage.dart';
import 'package:movies/utils/constants.dart';
import 'package:movies/utils/widget_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  
   TextEditingController _phone = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _pass = TextEditingController();
  TextEditingController _confirm_pass = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  Future<void> CreateUser(String memail, String mpassword,BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: memail, password: mpassword);
      if (userCredential.user != null) {
        // store user

        save(memail, _phone.text,context);
        showText("Tusanyuse okulaba ;-)");
      } else {
        // something went wrong
        showText("somewthing went wrong");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print("email already in use");
        showText("email already in use");
      }
    } catch (e) {
      print(e);
      showText("some firebase error");
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
    FirebaseAuth auth = FirebaseAuth.instance;
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);
    return SafeArea(
        child: Scaffold(
      backgroundColor: COLOR_WHITE,
      appBar: AppBar(
        title: Text("Easy Sign Up"),
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
                    addVerticalSpace(10),
                    Text(
                      "fill in your information",
                      style: TextStyle(fontSize: 25, color: COLOR_BLACK),
                    )
                  ],
                ),
                addVerticalSpace(30),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller:_email,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "* Required";
                      } else
                        return null;
                    },
                   /* onSaved: (String email) {
                      this._email = email;
                      setState(() {
                        _email = email;
                      });
                    },*/
                    decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(fontSize: 20),
                        filled: true),
                  ),
                ),
                addVerticalSpace(10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller:_phone,
                    keyboardType: TextInputType.phone,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "* Required";
                      } else if (value.length < 9) {
                        return "*invalid number";
                      } else
                        return null;
                    },
                    /*onSaved: (String phone) {
                      this._phone = phone;
                      setState(() {
                        _phone = phone;
                      });
                    },*/
                    decoration: InputDecoration(
                        labelText: "Phone",
                        labelStyle: TextStyle(fontSize: 20),
                        filled: true),
                  ),
                ),
                addHorizontalSpace(10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    //  keyboardType: TextInputType.,
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
                ),
                addHorizontalSpace(10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _confirm_pass,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "* Required";
                      } else if (_pass.text != _confirm_pass.text) {
                        return "*the two passwords should match";
                      } else {
                        return null;
                      }
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
                            CreateUser(_email.text, _pass.text,context);
                          } else {
                            Fluttertoast.showToast(
                                msg: "Fill the fields correctly",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        },
                        child: Text(
                          "Sign up",
                          style: TextStyle(fontSize: 20, color: COLOR_WHITE),
                        ),
                      ),
                    ),
                    addVerticalSpace(10),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: BorderIcon(
                          child: Text(
                            "Back",
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

  Future<void> save(String email, String number, BuildContext context) {
    DocumentReference users = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser.uid);
    Map<String, String> InforMap = new Map();
    InforMap["email"] = email;
    InforMap["number"] = number;
    users.set(InforMap).then((value) {
      print('Added');
      showText("Tusanyuse okulaba ;-)");
      Navigator.of(context).push(MaterialPageRoute(
           builder: (context) => LandingPage()));
    }).catchError((error) {
      print('failed');
      showText(error.toString());
    });
  }

  @override
  void dispose() {
    _pass.dispose();
    super.dispose();
  }
}
