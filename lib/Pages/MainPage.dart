
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:governmentnews/Components/BottomNav.dart';
import 'package:governmentnews/Components/Drawer.dart';
import 'package:governmentnews/Components/HeaderError.dart';
import 'package:governmentnews/Components/MainHeader.dart';
import 'package:governmentnews/Components/NewContent.dart';
import 'package:governmentnews/Components/navigate.dart';
import 'package:governmentnews/Pages/Search.dart';
import 'package:governmentnews/data/category.dart';


class MainPage extends StatefulWidget{
  _MyMainPageState createState() => new _MyMainPageState();
}

class _MyMainPageState extends State<MainPage>{

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List cateList = new CategoryData().choices;

  bool isLoaded = false;
  bool isloggedin = false;
  bool isAuthenticated = false;

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  void showInSnackBarError(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        backgroundColor: Colors.orangeAccent,
        duration: new Duration(seconds: 5),
        content: new Row(
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: new Icon(
                Icons.done,
                color: Colors.black87,
              ),
            ),
            new Text(
              value,
              style: new TextStyle(color: Colors.black87),
            )
          ],
        )));
  }

  /*  GOOGLE AND FIRE LOGIN FUNCTION */



  @override
  build(BuildContext context) {

    double headerHeight = MediaQuery.of(context).size.height * 0.45;
    double widgetWidth = MediaQuery.of(context).size.height;

    return new Scaffold(
      key: _scaffoldKey,
      drawer: new DrawerWidget(widgetWidth: widgetWidth),
      bottomNavigationBar: new BottomNav(cateList: this.cateList),
      body: new CustomScrollView(
        slivers: <Widget>[
          new SliverAppBar(
            expandedHeight: headerHeight,
            backgroundColor: const Color.fromRGBO(68, 68, 68, 0.6),
            actions: [
              new IconButton(
                  icon: new Icon(Icons.search),
                  onPressed: () {
                    new Navigate().onNavigate(new SearchPage(), context);
                  }),
            ],
            title: new Image.asset(
              'assets/images/gn.png',
              fit: BoxFit.cover,
              height: 37.0,
            ),
            centerTitle: true,
            pinned: true,
            flexibleSpace: new FlexibleSpaceBar(
              background:
                new StreamBuilder(
                  stream:  Firestore.instance.collection('/topnews').where('itemID', isEqualTo: 0).snapshots,
                  builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot ){
                    if(snapshot.hasError)
                      return new Text('Error: ${snapshot.error}');
                    if(!snapshot.hasData)
                      return new HeaderError(headerHeight: headerHeight);
                    if(snapshot.data.documents.isEmpty)
                      return new HeaderError(headerHeight: headerHeight,);
                    switch (snapshot.connectionState) {
                      case ConnectionState.none: return new Text('Loading User Info ...');
                      case ConnectionState.waiting: return new Text('Awaiting bids...');
                      case ConnectionState.active: return new MainHeader(data: snapshot.data.documents,height: headerHeight,);
                      case ConnectionState.done: return
                        new Text("Done Loadiing news");
                    //default: throw "Unknown: ${snapshot.connectionState}";
                  }
                }
              )


            ),
          ),
          new SliverList(
              delegate: new SliverChildListDelegate(<Widget>[
            new StreamBuilder(
              stream: Firestore.instance
                  .collection('/topnews')
                  .where('itemID', isGreaterThan: 1)
                  .orderBy("itemID").limit(9)
                  .snapshots,
              builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot ) {

                if (!snapshot.hasData)
                  return new Center(
                    child: new Text('Loading...'),
                  );
                return new Column(
                  children: snapshot.data.documents.map((document) {
                    return new NewContent(
                      tag: document['id'],
                      title: document['title'],
                      putDate: document['date'],
                      image: document['image'],
                      thumbnail: document['thumbnail'],
                      content: document['content'],
                      height: headerHeight,
                      link: document['link'],
                    );
                  }).toList(),
                );
              },
            ),
          ])),
        ],
      ),
    );
  }

}
