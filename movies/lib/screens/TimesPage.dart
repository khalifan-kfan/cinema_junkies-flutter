import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movies/screens/SeatsSelection.dart';
import 'package:movies/utils/constants.dart';

class TimesPage extends StatelessWidget {
  final DocumentSnapshot movie;
  final DocumentSnapshot day;
  final DocumentSnapshot hall;

  const TimesPage({
    Key key,
    @required this.movie,
    @required this.day,
    @required this.hall,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final df = new DateFormat('dd-MM-yyyy');
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          title: Text(
            df.format(day.data()["absolute_date"].toDate()),
          ),
        ),
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
                        .doc(day.id)
                        .collection("Halls")
                        .doc(hall.id)
                        .collection("Times")
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
                          DocumentSnapshot timeData = snapshot.data.docs[index];
                          return TimeItem(
                              timeData: timeData,
                              movie: movie,
                              day: day,
                              hall: hall);
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

class TimeItem extends StatelessWidget {
  final DocumentSnapshot timeData;
  final DocumentSnapshot movie;
  final DocumentSnapshot day;
  final DocumentSnapshot hall;

  const TimeItem(
      {Key key,
      @required this.timeData,
      @required this.movie,
      @required this.day,
      @required this.hall})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final df = new DateFormat('kk:mm');
    return GestureDetector(
      onTap: () {
        // to choser
         Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => 
         SeatsSelection(timeData: timeData ,movie: movie,day: day,hall: hall)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        height: 70,
        decoration: BoxDecoration(
          color: COLOR_GREY.withAlpha(25),
          borderRadius: BorderRadius.circular(8.0),
        ),
        //padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Text(df.format(timeData.data()["movie_time"].toDate()),
                  style: themeData.textTheme.headline1),
            ),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(timeData.data()["available_seats"].length.toString()),
                  Text("Free seats", style: themeData.textTheme.headline4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
