import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movies/screens/Landingpage.dart';
import 'package:movies/utils/constants.dart';
import 'dart:ui';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    double screenWidth = window.physicalSize.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cinema Junkie',
      theme: ThemeData(
          primaryColor: COLOR_WHITE,
          accentColor: COLOR_DARK_BLUE,
          textTheme: screenWidth < 500 ? TEXT_THEME_SMALL : TEXT_THEME_DEFAULT,
          fontFamily: "Montserrat"),
      home: LandingPage(),
    );
    /* return Scaffold(
      body: Center(
        child: FlatButton(
          onPressed: () {
            Navigator.push(ctx, PageTwo());
          },
          child: Text("GO to Next"),
        ),
      ),
    );*/
  }
}

/*
Widget listItem(BuildContext ctx, DocumentSnapshot snapshot) {
  
  return ListTile(
    title: Row(
      children: [
        Expanded(
          child: Text(
            snapshot['Title'],
            style: Theme.of(ctx).textTheme.headline1,
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: Color(0xffddddff),
          ),
          padding: const EdgeInsets.all(10.0),
          child: Text(
            snapshot['sound'],
            style: Theme.of(ctx).textTheme.bodyText2,
          ),
        )
      ],
    ),
  );
}*/

class PageTwo extends MaterialPageRoute<Null> {
  PageTwo()
      : super(builder: (BuildContext ctx) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(ctx).canvasColor,
              elevation: 1.0,
            ),
            body: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("Movies").snapshots(),
              builder: (ctx, snapshot) {
                if (!snapshot.hasData) return const Text('loading....');
                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (ctx, index) {
                    DocumentSnapshot movies = snapshot.data.docs[index];
                    return ListTile(
                      leading: Image.network(movies.get('picture_link')),
                      title: Text(movies['Title']),
                      subtitle: Text(movies['sound']),
                    );
                  },
                );
              },
            ),
          );
        });
}

class PageThree extends MaterialPageRoute<Null> {
  PageThree()
      : super(builder: (BuildContext ctx) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Last Page"),
              backgroundColor: Theme.of(ctx).accentColor,
              elevation: 2.0,
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(ctx);
                    })
              ],
            ),
            body: Center(
              child: MaterialButton(
                onPressed: () {
                  Navigator.popUntil(
                      ctx, ModalRoute.withName(Navigator.defaultRouteName));
                },
                child: Text("Go home"),
              ),
            ),
          );
        });
}
