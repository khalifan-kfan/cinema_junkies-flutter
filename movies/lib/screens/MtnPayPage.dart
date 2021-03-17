import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:movies/screens/LandingPage.dart';
import 'package:movies/utils/widget_functions.dart';

import 'package:uuid/uuid.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:movies/utils/constants.dart';

class MtnPaypage extends StatefulWidget {
  final Map<String, dynamic> selection_;

  const MtnPaypage({Key key, this.selection_}) : super(key: key);

  @override
  _pay_page createState() {
   return _pay_page();
  }
}

class _pay_page extends State<MtnPaypage> {
  String Token = "";
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController _number = TextEditingController();
  List<int> list = new List<int>();
  Future<void> send(BuildContext context) async {
    //step 1
    var url =
        'https://sandbox.momodeveloper.mtn.com/collection/v1_0/requesttopay';
    var base = 'https://ericssonbasicapi2.azure-api.net';
    var uuid = Uuid();
    var idx = uuid.v4();
    final Map<String, String> payment = new Map();
    payment["amount"] = widget.selection_["name"];
    payment["currency"] = "EUR";
    payment["externalId"] = idx;
    payment["payer"] = widget.selection_["username"];
    payment["payerMessage"] = "Pay for Cinema Ticket";
    payment["payerNote"] = "Enter pin to confirm";

    Token_getter().then((value) async {
      //SharedPreferences prefs = await SharedPreferences.getInstance();
      //prefs.setString('Token', value);
      //prefs.setInt(
        //  'TokenTime',
        //  (DateTime.now().add(const Duration(hours: 1)))
       //       .microsecondsSinceEpoch);
      // await prefs.setInt('counter', counter)
      HttpClient mm = new HttpClient();
      HttpClientRequest rq = await mm.postUrl(Uri.parse(url));
      rq.headers.set('Authorization', "Bearer" + " " + value);
      //  rq.headers.set('X-Callback-Url', base);
      rq.headers.set('X-Reference-Id', idx);
      rq.headers.set('X-Target-Environment', 'sandbox');
      rq.headers.set('Content-Type', 'application/json');
      rq.headers.set('Ocp-Apim-Subscription-Key', MY_SECRET_SUBSCRIPTION_KEY);

      rq.add(utf8.encode(json.encode(payment)));
      HttpClientResponse rp = await rq.close();
      //check status code
      if (rp.statusCode > 200 || rp.statusCode > 400) {
        showText("momo error:" + rp.statusCode.toString());
      } else {
        print("ACCEPTED 200");
        // track transation message
        trackTransaction(idx, value, 5, context);
      }
      mm.close();
    });
  }

  Future<String> trackTransaction(
      var idx, var val, var counter, BuildContext context) async {
    //track transaction to see if successfull
    var Url =
        'https://sandbox.momodeveloper.mtn.com/collection/v1_0/requesttopay/' +
            idx;
    await http.get(
      Url,
      headers: <String, String>{
        'Authorization': "Bearer" + " " + val,
        'Ocp-Apim-Subscription-Key': MYSECRET_USER_ID,
        'X-Target-Environment': 'sandbox',
      },
    ).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;
      print(json.decode(res));
      if (statusCode < 200 || statusCode > 400 || json == null) {
        print("Issue tracking transaction please wait");
        showText("Issue tracking transaction");
        if (counter >= 1) {
          new Timer(const Duration(milliseconds: 500), () {
            trackTransaction(idx, val, counter--, context);
          });
        } else {
          showText("Something went wrong, please retry");
        }
      } else {
        final parsed = json.decode(res).cast<Map<String, dynamic>>();
        if (parsed['status'].toString().toLowerCase().contains('success')) {
          showText("transaction successfull");
          widget.selection_["transactionref"] = idx;
          UpdateSeats(idx, context);
        } else if (parsed['status'].toString().toLowerCase().contains('fail') ||
            parsed['status'].toString().toLowerCase().contains('reject')) {
          showText("transaction failed");
        } else if (parsed['status']
            .toString()
            .toLowerCase()
            .contains('pending')) {
          new Timer(const Duration(milliseconds: 700), () {
            trackTransaction(idx, val, counter--, context);
          });
        }
      }
    });

    /* {
            "amount": 100,
            "currency": "UGX",
            "financialTransactionId": 23503452,
            "externalId": 947354,
            "payer": {
              "partyIdType": "MSISDN",
              "partyId": 4656473839
            },
            "status": "SUCCESSFUL"
          }*/
  }

  @override
  Widget build(BuildContext context) {
    final dataf = new DateFormat('dd-MM-yyyy');
    final timef = new DateFormat('kk:mm');

    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);
    final double padding = 25;
    final sidePadding = EdgeInsets.symmetric(horizontal: padding);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: COLOR_WHITE,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          title: Text("Momo Pay"),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              addVerticalSpace(30),
              Padding(
                padding: sidePadding,
                child: SizedBox(
                  height: 200,
                  child: Image.network(widget.selection_["pic_link"],
                      fit: BoxFit.cover),
                ),
              ),
              addVerticalSpace(30),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.selection_["Title"],
                  style: themeData.textTheme.headline1,
                ),
              ),
              addVerticalSpace(10),
              Padding(
                padding: sidePadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(dataf.format(widget.selection_["date"].toDate()),
                        style: themeData.textTheme.headline4),
                    Text(timef.format(widget.selection_["time"].toDate()),
                        style: themeData.textTheme.headline4),
                  ],
                ),
              ),
              addVerticalSpace(20),
              Padding(
                padding: sidePadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.selection_["definition"],
                        style: themeData.textTheme.headline6),
                    Text(widget.selection_["seats"].length.toString()+"St(s)",
                        style: themeData.textTheme.headline6),
                    Text(widget.selection_["amount"].toString(),
                        style: themeData.textTheme.headline6),
                  ],
                ),
              ),
              addVerticalSpace(30),
              Padding(
                padding: sidePadding,
                child: Form(
                  key: formkey,
                  child: TextFormField(
                    controller: _number,
                      keyboardType: TextInputType.phone,

                    validator: (String value) {
                      if (value.isEmpty) {
                        return "* Required";
                      } else if (value.length < 10) {
                        return "Password should be atleast 10 numbers";
                      } else
                        return null;
                    },
                    // onSaved: (String password) {
                    // this._password = password;
                    //},

                    decoration: InputDecoration(
                        labelText: "phone number",
                        labelStyle: TextStyle(fontSize: 20),
                        fillColor: Colors.orangeAccent,
                        filled: true),
                  ),
                ),
              ),
              addVerticalSpace(20),
              Container(
                alignment: Alignment.center,
                child: RaisedButton(
                  onPressed: () {
                    if (formkey.currentState.validate()) {
                      // show pay genete ticket
                      CircularProgressIndicator();
                      send(context);

                    } else {
                      showText("Fill the fields correctly");
                    }
                  },
                  color: Colors.orangeAccent,
                  child: Text("PAY"),
                  textColor: COLOR_BLACK,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> Token_getter() async {
    // need a header that starts with basic
    //and then the subscrition key
    var tokenUrl = 'https://sandbox.momodeveloper.mtn.com/collection/token/';
   // SharedPreferences prefs = await SharedPreferences.getInstance();
    //String token = (prefs.getString('Token') ?? "");
   // var time = (prefs.getInt('TokenTime') ?? "");
    //print("token:" + token);

      await http
          .post(
        tokenUrl,
        headers: <String, String>{
          'Authorization': ENCODED,
          'Ocp-Apim-Subscription-Key': MY_SECRET_SUBSCRIPTION_KEY,
        },
        body: jsonEncode(<String, String>{}),
      )
          .then((http.Response response) async {
        final String res = response.body;
        final int statusCode = response.statusCode;
        if (statusCode < 200 || statusCode > 400 || json == null) {
          print("Error while fetching data");
          showText("Error while fetching data"+ statusCode.toString());
        } else {
          print(json.decode(res));
          final parsed = json.decode(res).cast<Map<String, dynamic>>();
          // parsed.map<Token_>((json) => Token_.fromJson(json));
          // await prefs.setInt('counter', counter)
          return parsed['access_token'];
          
        }
      });
  
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

  void UpdateSeats(String id, BuildContext context) {
    //first remove picked seats
    //seats = (ArrayList<Integer>) informap.get("seats");
    FirebaseFirestore.instance
        .collection("Movies")
        .doc(widget.selection_["movie_id"])
        .collection("Days")
        .doc(widget.selection_["day_id"])
        .collection("Halls")
        .doc(widget.selection_["cinema_id"])
        .collection("Times")
        .doc(widget.selection_["time_id"])
        .get()
        .then((DocumentSnapshot document) {
      for (int i = 0; i < widget.selection_["seats"].length; i++) {
        if (widget.selection_["seats"]
            .contains(document.data()["available_seats"][i])) {
          widget.selection_["seats"].remove(i);
          document.data()["available_seats"].remove(i);
        } else {
          // more implementation abort
        }
      }
      FirebaseFirestore.instance
          .collection("Movies")
          .doc(widget.selection_["movie_id"])
          .collection("Days")
          .doc(widget.selection_["day_id"])
          .collection("Halls")
          .doc(widget.selection_["cinema_id"])
          .collection("Times")
          .doc(widget.selection_["time_id"])
          .update({"available_seats": document.data()["available_seats"]}).then(
              (result) {
        print("Success!");
        store_transaction(id, context);
      });
    });
  }

  void store_transaction(String idx, BuildContext context) {
    widget.selection_["username"] =
        FirebaseAuth.instance.currentUser.email; //14
    widget.selection_["userID"] = FirebaseAuth.instance.currentUser.uid; //15
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("Tickets")
        .add(widget.selection_)
        .then((value) {
      if (value.id != null) {
        FirebaseFirestore.instance
            .collection("Transaction")
            .add(widget.selection_)
            .then((value_) {
          if (value_.id != null) {
            showText("Thank you check your tickets");
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LandingPage()));
          }
        });
      }
    });
  }
}

class Token_ {
  final int expires_in;
  final String token_type;
  final String access_token;

  Token_({this.expires_in, this.token_type, this.access_token});

  factory Token_.fromJson(Map<String, dynamic> json) {
    return Token_(
      expires_in: json['expires_in'],
      token_type: json['token_type'],
      access_token: json['access_token'],
    );

  }
}
