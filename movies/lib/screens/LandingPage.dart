import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:movies/custom/BorderIcon.dart';
import 'package:movies/custom/OptionButton.dart';
//import 'package:movies/sample_data.dart';
import 'package:movies/screens/DetailPage.dart';
import 'package:movies/utils/DialogHelper.dart';
import 'package:movies/utils/constants.dart';
//import 'package:movies/utils/custom_functions.dart';
import 'package:movies/utils/widget_functions.dart';

class LandingPage extends StatefulWidget {
  @override
  LandingPage_ createState() {
    return LandingPage_();
  }
}

class LandingPage_ extends State<LandingPage> {
  int chosen;
  bool islogged_in;
  @override
  void initState() {
    super.initState();
    chosen = 1;
    FirebaseAuth.instance.authStateChanges().listen((User user) async {
      if (user == null) {
        // not logged in
        islogged_in = false;
      } else {
        islogged_in = true;
      }
    });
  }

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
                      physics: BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      child: Row(
                          // to make this list clickalbe
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  chosen = 1;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: chosen == 1
                                      ? Colors.lightBlue
                                      : COLOR_GREY.withAlpha(25),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 13),
                                margin: const EdgeInsets.only(left: 20),
                                child: Text(
                                  "New Movies",
                                  style: themeData.textTheme.headline5,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  chosen = 2;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: chosen == 2
                                      ? Colors.lightBlue
                                      : COLOR_GREY.withAlpha(25),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 13),
                                margin: const EdgeInsets.only(left: 20),
                                child: Text(
                                  "My Tickets",
                                  style: themeData.textTheme.headline5,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  chosen = 3;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: chosen == 3
                                      ? Colors.lightBlue
                                      : COLOR_GREY.withAlpha(25),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 13),
                                margin: const EdgeInsets.only(left: 20),
                                child: Text(
                                  "History",
                                  style: themeData.textTheme.headline5,
                                ),
                              ),
                            ),
                          ]
                          // .map((filter) => ChoiceOption(text: filter,position: chosen,))
                          //.toList()
                          ),
                    ),
                    addVerticalSpace(10),
                    if (chosen == 1)
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
                              return Center(
                                child: Padding(
                                  padding: sidePadding,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 10,
                                    backgroundColor: Colors.cyanAccent,
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
                                            Colors.red),
                                  ),
                                ),
                              );
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
                          })
                    else if (chosen == 2)
                      islogged_in
                          ? StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection("Users")
                                  .doc(FirebaseAuth.instance.currentUser.uid)
                                  .collection("Tickets")
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Text('Something went wrong');
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: Padding(
                                      padding: sidePadding,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 10,
                                        backgroundColor: Colors.cyanAccent,
                                        valueColor:
                                            new AlwaysStoppedAnimation<Color>(
                                                Colors.red),
                                      ),
                                    ),
                                  );
                                }
                                return Expanded(
                                  child: Padding(
                                      padding: sidePadding,
                                      child: ListView.builder(
                                          //padding: sidePadding,

                                          physics: BouncingScrollPhysics(),
                                          itemCount: snapshot.data.docs.length,
                                          itemBuilder: (context, index) {
                                            DocumentSnapshot ticket =
                                                snapshot.data.docs[index];
                                            return TicketItem(
                                              ticket: ticket,
                                              parent: this,
                                            );
                                          })),
                                );
                              })
                          : Padding(
                              padding: sidePadding,
                              child: Text(
                                  " Please click here to first login or sign up."),
                            )
                    else if (chosen == 3)
                      Text("History")
                  ],
                ),
                /*  Positioned(
                  bottom: 20,
                  width: size.width,
                  child: Center(
                    child: OptionButton(
                      text: "HI",
                      icon: Icons.map_rounded,
                      width: size.width * 0.35,
                    ),
                  ),
                )*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TicketItem extends StatelessWidget {
  final DocumentSnapshot ticket;
  final LandingPage_ parent;

  const TicketItem({Key key, this.ticket, this.parent}) : super(key: key);

  String Seats(List<dynamic> seats) {
    String result = "";
    for (int k = 0; k < seats.length; k++) {
      result += "${seats[k].toString()} ,";
    }
    return result;
  }

  void Save_Delete(DocumentSnapshot ticket) {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("History")
        .doc(ticket.id)
        .get()
        .then((value) {
      if (value == null) {
        FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser.uid)
            .collection("History")
            .doc(ticket.id)
            .set(ticket.data())
            .then((value) {
          FirebaseFirestore.instance
              .collection("Users")
              .doc(FirebaseAuth.instance.currentUser.uid)
              .collection("Tickets")
              .doc(ticket.id)
              .delete()
              .whenComplete(() {
            showText("sent to history");
            this.parent.setState(() {
              this.parent.chosen = 3;
            });
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    DateTime ticket_time = ticket.data()["time"].toDate();
    final df = new DateFormat('kk:mm');
    final dd = new DateFormat('dd-MM-yyyy');
    var space = 15.0;

    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 1),
        child: Card(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: Image.network(ticket.get("pic_link"))),
                Positioned(
                  width: 60,
                  top: 7,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 7),
                    child: ticket_time
                        .add(Duration(hours: 6))
                        .compareTo(new DateTime.now())>0
                        
                        ? BorderIcon(
                            height: 50,
                            width: 50,
                            child: Icon(
                              Icons.blur_on_outlined,
                              color: Colors.green,
                            ))
                        :GestureDetector(
                            onTap: () {
                              // save to history delete from here
                              Save_Delete(ticket);
                              showText("removing.......");
                            },
                            child: BorderIcon(
                              height: 50,
                              width: 50,
                              child: Icon(
                                Icons.blur_on_outlined,
                                color: Colors.red,
                              ),
                            ),
                          ),
                  ),
                ),
              ]),
              addVerticalSpace(space),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ticket.get("Title"),
                      style: themeData.textTheme.headline1,
                    ),
                    Text(
                      ticket.get("definition"),
                      style: themeData.textTheme.headline2,
                    ),
                  ],
                ),
              ),
              addVerticalSpace(space),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 7),
                child: Text(
                  "Owner:  ${ticket.get("username")}",
                  style: themeData.textTheme.headline5,
                ),
              ),
              addVerticalSpace(space),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dd.format(ticket.get("date").toDate()),
                      style: themeData.textTheme.headline3,
                    ),
                    Text(
                      df.format(ticket.get("time").toDate()),
                      style: themeData.textTheme.headline3,
                    ),
                  ],
                ),
              ),
              addVerticalSpace(space),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${ticket.get("seats").length.toString()} St(s)",
                      style: themeData.textTheme.headline3,
                    ),
                    Text(
                      "Nos. " + Seats(ticket.get("seats")),
                      style: themeData.textTheme.headline4,
                    ),
                  ],
                ),
              ),
              addVerticalSpace(space),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 7),
                child: Text("Amount: ${ticket.get("amount").toString()}",
                    style: themeData.textTheme.headline4),
              ),
              addVerticalSpace(space),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 7),
                child: ticket_time
                        .add(Duration(hours: 6))
                        .compareTo(new DateTime.now())>0
                    ? RaisedButton(
                        onPressed: () async {
                          //save to history and delete from ticket if date is 2 houra close
                          if (ticket_time.difference(DateTime.now()).inDays ==
                              0) {                          
                            return await  
                                showDialog(context: context, builder: (context) => DialogTicket(context));
                          } else {
                            showText(
                                "The time of use of this ticket is not in range yet");
                          }
                        },
                        textColor: Colors.white,
                        color: Colors.black,
                        child: Text("Use Ticket"),
                      )
                    : GestureDetector(
                        onTap: () {
                          showText("removing .....");
                          Save_Delete(ticket);
                        },
                        child: Text(
                            "Ticket is nolonger Usable,click here to send it to history"),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget DialogTicket(BuildContext context){
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 10,
      backgroundColor: Colors.transparent,
      child: Container(
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
                  Icons.book_online,
                  color: Colors.black,
                )),
          ),
          addVerticalSpace(24),
          Text("Use Ticket!",
              style: TextStyle(
                  fontSize: 20,
                  color: COLOR_BLACK,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          addVerticalSpace(8),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "If you continue, this ticket will be deleted, considered used. Please confirm in presence of a cinema atendant",
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              //mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    //dismiss
                    Navigator.of(context).pop();
                  },
                  child: Text("Not yet"),
                  textColor: COLOR_BLACK,
                ),
                RaisedButton(
                  onPressed: () {
                     showText("saving .....");
                     Save_Delete(ticket);
                  },
                  child: Text("Continue"),
                  textColor: COLOR_BLACK,
                ),
              ],
            ),
          )
        ],
      ),
    ),
    );
  
 
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
}

class ChoiceOption extends StatelessWidget {
  final String text;
  final int position;

  const ChoiceOption({Key key, this.text, this.position}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return GestureDetector(
      onTap: () {},
      child: Container(
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
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailPage(
                  itemData: itemData,
                )));
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
