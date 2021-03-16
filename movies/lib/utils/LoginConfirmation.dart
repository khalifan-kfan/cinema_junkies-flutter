import 'package:flutter/material.dart';
import 'package:movies/custom/BorderIcon.dart';
import 'package:movies/screens/loginPage.dart';
import 'package:movies/utils/constants.dart';
import 'package:movies/utils/widget_functions.dart';

class LoginConfirmation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 10,
      backgroundColor: Colors.transparent,
      child: _biuldKid(context),
    );
  }

  _biuldKid(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
          color: COLOR_WHITE,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
           topLeft: Radius.circular(12), topRight: Radius.circular(12))),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BorderIcon(
                height: 70,
                width: 70,
                child: Icon(
                  Icons.person,
                  color: Colors.black,
                )),
          ),
          addVerticalSpace(24),
          Text("Login!",
              style: TextStyle(
                  fontSize: 20,
                  color: COLOR_BLACK,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          addVerticalSpace(8),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Please, first login to continue! ",
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              //mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    //dismiss
                    Navigator.of(context).pop();
                  },
                  child: Text("Not yet"),
                  textColor: COLOR_BLACK,
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Text("Login"),
                  textColor: COLOR_BLACK,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
