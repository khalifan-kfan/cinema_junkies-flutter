import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movies/custom/BorderIcon.dart';
import 'package:movies/custom/OptionButton.dart';
//import 'package:movies/sample_data.dart';
import 'package:movies/screens/DetailPage.dart';
import 'package:movies/utils/constants.dart';
//import 'package:movies/utils/custom_functions.dart';
import 'package:movies/utils/widget_functions.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);
    double padding = 25;
    final sidePadding = EdgeInsets.symmetric(horizontal: padding);
    return WillPopScope(
       onWillPop: () => Future.value(false),
          child: SafeArea(
        child: Scaffold(
          body: Container(
            width: size.width,
            height: size.height,
            child: Stack(
              children: [
                Column(
                  // widgets to start from line start
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    addVerticalSpace(padding),
                    Padding(
                      padding: sidePadding,
                      child: Row(
                        // space between two upper icons
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BorderIcon(
                            height: 50,
                            width: 50,
                            child: Icon(
                              Icons.menu,
                              color: COLOR_BLACK,
                            ),
                          ),
                          BorderIcon(
                            height: 50,
                            width: 50,
                            child: Icon(
                              Icons.settings,
                              color: COLOR_BLACK,
                            ),
                          ),
                        ],
                      ),
                    ),
                    addVerticalSpace(20),
                    Padding(
                      padding: sidePadding,
                      child: Text(
                        "Uganda",
                        style: themeData.textTheme.bodyText2,
                      ),
                    ),
                    addVerticalSpace(10),
                    Padding(
                      padding: sidePadding,
                      child: Text(
                        "Kampala",
                        style: themeData.textTheme.headline1,
                      ),
                    ),
                    Padding(
                        padding: sidePadding,
                        child: Divider(
                          height: 25,
                          color: COLOR_GREY,
                        )),
                    addVerticalSpace(10),
                    SingleChildScrollView(
                      // horizontal scroller
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      child: Row(
                        // to make this list clickalbe
                        children: ["New Movies", "My Tickets", "My History"]
                            .map((filter) => ChoiceOption(text: filter))
                            .toList(),
                      ),
                    ),
                    addVerticalSpace(10),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("Movies")
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Something went wrong');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text("Loading....");
                          }
                          return Expanded(
                            child: Padding(
                                padding: sidePadding,
                                child: ListView.builder(
                                    //padding: sidePadding,
                                    physics: BouncingScrollPhysics(),
                                    itemCount: snapshot.data.docs.length,
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot movies =
                                          snapshot.data.docs[index];
                                      return MovieItem(
                                        itemData: movies,
                                      );
                                    })),
                          );
                        }),
                  ],
                ),
                Positioned(
                  bottom: 20,
                  width: size.width,
                  child: Center(
                    child: OptionButton(
                      text: "HI",
                      icon: Icons.map_rounded,
                      width: size.width * 0.35,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChoiceOption extends StatelessWidget {
  final String text;

  const ChoiceOption({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: COLOR_GREY.withAlpha(25),
        borderRadius: BorderRadius.circular(20.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
      margin: const EdgeInsets.only(left: 20),
      child: Text(
        text,
        style: themeData.textTheme.headline5,
      ),
    );
  }
}

class MovieItem extends StatelessWidget {
  final DocumentSnapshot itemData;

  const MovieItem({Key key, this.itemData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => DetailPage(itemData: itemData,)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: Image.network(itemData.get("picture_link"))),
                Positioned(
                    top: 15,
                    right: 15,
                    child: BorderIcon(
                        child: Icon(
                      Icons.favorite_border,
                      color: COLOR_BLACK,
                    )))
              ],
            ),
            addVerticalSpace(15),
            Row(
              children: [
                Text(
                  itemData.get("Title"),
                  style: themeData.textTheme.headline1,
                ),
                addHorizontalSpace(10),
                Text(
                  itemData.get("sound"),
                  style: themeData.textTheme.bodyText2,
                )
              ],
            ),
            addVerticalSpace(10),
            Text(
              "Dif:${itemData.get("definition")} / Director: ${itemData.get("director")} / lead: ${itemData.get("lead_actors")}",
              style: themeData.textTheme.headline5,
            )
          ],
        ),
      ),
    );
  }
}
