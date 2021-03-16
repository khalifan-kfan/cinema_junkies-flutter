import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movies/custom/BorderIcon.dart';
import 'package:movies/screens/DatesPriceCinemasPages.dart';

//import 'package:movies/custom/OptionButton.dart';
import 'package:movies/utils/constants.dart';
import 'package:movies/utils/DialogHelper.dart';
//import 'package:movies/utils/custom_functions.dart';
import 'package:movies/utils/widget_functions.dart';

class DetailPage extends StatelessWidget {
  final DocumentSnapshot itemData;
  //final Future<FirebaseApp> _init =Firebase.initializeApp();
  const DetailPage({Key key, @required this.itemData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);
    final double padding = 25;
    final sidePadding = EdgeInsets.symmetric(horizontal: padding);
    return SafeArea(
      child: Scaffold(
        backgroundColor: COLOR_WHITE,
        body: Container(
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Image.network(itemData.data()["picture_link"],
                            fit: BoxFit.cover),
                        Positioned(
                          width: size.width,
                          top: padding,
                          child: Padding(
                            padding: sidePadding,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: BorderIcon(
                                    height: 50,
                                    width: 50,
                                    child: Icon(
                                      Icons.keyboard_backspace,
                                      color: COLOR_BLACK,
                                    ),
                                  ),
                                ),
                                BorderIcon(
                                  height: 50,
                                  width: 50,
                                  child: Icon(
                                    Icons.calendar_today,
                                    color: COLOR_BLACK,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    addVerticalSpace(padding),
                    Padding(
                      padding: sidePadding,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text( 
                                itemData.data()["Title"],
                                style: themeData.textTheme.headline1,
                              ),
                              addVerticalSpace(5),
                              Text(
                                "Cinema junk",
                                style: themeData.textTheme.subtitle2,
                              ),
                            ],
                          ),
                          // put calculated release date
                          InkWell(
                              onTap: () {
                                FirebaseAuth.instance
                                    .authStateChanges()
                                    .listen((User user) async {
                                  if (user == null) {
                                    //dialog
                                     print('User is currently signed out!');
                                    return await DialogHelper.loging(context);
                                   
                                  } else {
                                    // navigate further
                                     Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => 
                                    DatesPriceCinemasPages(movie: itemData,)));
                                    print('User is signed in!');
                                  }
                                });
                               
                              },
                              child: BorderIcon(
                                child: Text(
                                  "Book",
                                  style: themeData.textTheme.headline5,
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                              )),
                        ],
                      ),
                    ),
                    addVerticalSpace(padding),
                    Padding(
                      padding: sidePadding,
                      child: Text(
                        "More Information",
                        style: themeData.textTheme.headline4,
                      ),
                    ),
                    addVerticalSpace(padding),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          // card like items
                          InformationTile(
                            content: itemData.data()["director"],
                            name: "Director",
                          ),
                          InformationTile(
                            content: itemData.data()["lead_actors"],
                            name: "Leads",
                          ),
                          InformationTile(
                            content: itemData.data()["definition"],
                            name: "difinition",
                          ),
                          InformationTile(
                            content: itemData.data()["sound"],
                            name: "Sound",
                          )
                        ],
                      ),
                    ),
                    addVerticalSpace(padding),
                    Padding(
                      padding: sidePadding,
                      child: Text(
                        itemData.data()["description"],
                        textAlign: TextAlign.justify,
                        style: themeData.textTheme.bodyText2,
                      ),
                    ),
                    addVerticalSpace(100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InformationTile extends StatelessWidget {
  final String content;
  final String name;

  const InformationTile({Key key, @required this.content, @required this.name})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final Size size = MediaQuery.of(context).size;
    final double tileSize = size.width * 0.30;
    return Container(
      margin: const EdgeInsets.only(left: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BorderIcon(
              width: tileSize,
              height: tileSize,
              child: Text(
                content,
                style: themeData.textTheme.headline3,
              )),
          addVerticalSpace(10),
          Text(
            name,
            style: themeData.textTheme.headline6,
          )
        ],
      ),
    );
  }
}
