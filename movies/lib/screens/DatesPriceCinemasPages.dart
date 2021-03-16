import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movies/screens/TimesPage.dart';
//import 'package:movies/custom/BorderIcon.dart';
import 'package:movies/utils/constants.dart';
import 'package:movies/utils/widget_functions.dart';

class DatesPriceCinemasPages extends StatelessWidget {
  final DocumentSnapshot movie;

  const DatesPriceCinemasPages({Key key, @required this.movie})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          title: Text("Pick date 'n Cinema"),
        )
        ,
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("Movies")
                        .doc(movie.id)
                        .collection("Days")
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Loading....");
                      }
                      return ListView.builder(
                        //padding: sidePadding,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot dateData = snapshot.data.docs[index];
                          return DateItem(itemDay: dateData, movie: movie);
                        },
                      );
                    }),
              ),
            ],
          ),
        ),
        
      ),
    
    );
  }
}

class DateItem extends StatelessWidget {
  final DocumentSnapshot itemDay;
  final DocumentSnapshot movie;

  const DateItem({Key key, @required this.itemDay, @required this.movie})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final df = new DateFormat('dd-MM-yyyy');
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      height: 170,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Text(df.format(itemDay.data()["absolute_date"].toDate()),
                style: themeData.textTheme.headline1),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Divider(
                height: 25,
                color: COLOR_GREY,
              )),
          addVerticalSpace(5),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Price:", style: themeData.textTheme.headline1),
                Text(itemDay.data()["day_price"].toString()),
              ],
            ),
          ),
          addVerticalSpace(5),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Movies")
                  .doc(movie.id)
                  .collection("Days")
                  .doc(itemDay.id)
                  .collection("Halls")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading....");
                }
                return Flexible(
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot cinemaData = snapshot.data.docs[index];
                        return Row(
                          children: [
                            Cinemaitem(
                                itemDay: itemDay,
                                movie: movie,
                                cinemaData: cinemaData),
                          ],
                        );
                      }),
                );
              }),
        ],
      ),
    );
  }
}

class Cinemaitem extends StatelessWidget {
  final DocumentSnapshot itemDay;
  final DocumentSnapshot movie;
  final DocumentSnapshot cinemaData;

  const Cinemaitem(
      {Key key,
      @required this.itemDay,
      @required this.movie,
      @required this.cinemaData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return GestureDetector(
      onTap: () {
        //move to next page with all content
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => 
          TimesPage(movie: movie, day: itemDay, hall: cinemaData)));
      },
      child: Container(
        decoration: BoxDecoration(
          color: COLOR_GREY.withAlpha(25),
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
        margin: const EdgeInsets.only(left: 20),
        child: Text(
          cinemaData.data()["name"],
          style: themeData.textTheme.headline5,
        ),
      ),
    );
  }
}
