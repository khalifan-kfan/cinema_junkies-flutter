import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movies/screens/MtnPayPage.dart';

class SeatsSelection extends StatefulWidget {
  final DocumentSnapshot timeData;
  final DocumentSnapshot movie;
  final DocumentSnapshot day;
  final DocumentSnapshot hall;

  const SeatsSelection(
      {Key key, this.timeData, this.movie, this.day, this.hall})
      : super(key: key);

  @override
  select_state createState() {
    return select_state();
  }
}

class select_state extends State<SeatsSelection> {
  //List<int> allseats = new List<int>();
  List<int> selection;
  int price;

  @override
  void initState() {
    super.initState();
    //price = widget.price;
    price = 0;
    selection = new List<int>();
  }

  void positive_updaters(int i) {
    setState(() {
      selection.add(i);
      price = widget.day.data()["day_price"] * selection.length;
    });
  }

  void negative_updaters(int i) {
    setState(() {
      selection.remove(i);
      price = widget.day.data()["day_price"] * selection.length;
    });
  }

  @override
  void dispose() {
    super.dispose();
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
    // allseats.addAll(widget.timeData.data()["available_seats"]);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          actions: <Widget>[
            new IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  // we head on
                  if (selection.isEmpty) {
                    showText("select seats to proceed");
                  } else {
                    //pop to payments part
                    // private String transactionref;//st
                    Map<String, dynamic> selection_ = new Map();
                    selection_["userID"] =
                        FirebaseAuth.instance.currentUser.uid;
                    selection_["username"] =
                        FirebaseAuth.instance.currentUser.email;
                    selection_["cinema"] = widget.hall.data()["name"];
                    selection_["seats"] = selection;
                    selection_["amount"] = price;
                    selection_["date"] = widget.day.data()["absolute_date"];
                    selection_["price"] =
                        widget.day.data()["day_price"]; //why null
                    selection_["day_id"] = widget.day.id;
                    selection_["cinema_id"] = widget.hall.id;
                    selection_["time_id"] = widget.timeData.id;
                    selection_["Title"] = widget.movie.data()["Title"];
                    selection_["definition"] = widget.movie.data()["sound"];
                    selection_["movie_id"] = widget.movie.id;
                    selection_["pic_link"] =
                        widget.movie.data()["picture_link"];
                    selection_["time"] = widget.timeData.data()["movie_time"];

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MtnPaypage(
                                  selection_: selection_,
                                )));
                  }
                }),
          ],
          centerTitle: true,
          title: Text(price.toString()),
        ),
        body: GridView.count(
            crossAxisCount: 10,
            children: List.generate(50, (index) {
              if (widget.timeData
                  .data()["available_seats"]
                  .contains(index + 1)) {
                if (selection.contains(index + 1)) {
                  return GestureDetector(
                    onTap: () {
                      // selected

                      negative_updaters(index + 1);
                    },
                    child: new Card(
                      elevation: 10.0,
                      margin: EdgeInsets.all(3),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10),
                      ),
                      color: Colors.green,
                      child: new Container(
                        child: Align(
                          alignment: Alignment.center,
                          child: new Text((index + 1).toString()),
                        ),
                      ),
                    ),
                  );
                } else {
                  return GestureDetector(
                    onTap: () {
                      //not selected
                      positive_updaters(index + 1);
                    },
                    child: new Card(
                      elevation: 10.0,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10),
                      ),
                      color: Colors.blue,
                      child: new Container(
                        child: Align(
                          alignment: Alignment.center,
                          child: new Text((index + 1).toString()),
                        ),
                      ),
                    ),
                  );
                }
              } else {
                return new Card(
                  elevation: 10.0,
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  color: Colors.red,
                  child: new Container(
                    child: Align(
                      alignment: Alignment.center,
                      child: new Text((index + 1).toString()),
                    ),
                  ),
                );
              }
            })),
      ),
    );
  }
}
