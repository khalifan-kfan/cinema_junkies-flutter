import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/custom/BorderIcon.dart';
import 'package:movies/utils/constants.dart';

import 'loginPage.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            color: COLOR_WHITE,
            child: Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 25, bottom: 10),
                    child: BorderIcon(
                      height: 100,
                      width: 100,
                      child: Icon(
                        Icons.person,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Text(
                    FirebaseAuth.instance.currentUser != null
                        ? FirebaseAuth.instance.currentUser.email
                        : "Your loged out",
                    style: TextStyle(
                      fontSize: 20,
                      color: COLOR_BLACK,
                    ),
                  )
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.email),
            title: Text(
              "Contact us",
              style: TextStyle(fontSize: 18),
            ),
            onTap: null,
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text(
              "Rate us",
              style: TextStyle(fontSize: 18),
            ),
            onTap: null,
          ),
          FirebaseAuth.instance.currentUser != null?ListTile(
            leading: Icon(Icons.arrow_back),
            title: Text(
              "Log out",
              style: TextStyle(fontSize: 18),
            ),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pop();
            },
          ): ListTile(
            leading: Icon(Icons.arrow_forward),
            title: Text(
              "Login",
              style: TextStyle(fontSize: 18),
            ),
            onTap: ()  {
              
              Navigator.of(context).pop();
               Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              "Settings",
              style: TextStyle(fontSize: 18),
            ),
            onTap: null,
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text(
              "About us",
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
