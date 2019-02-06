import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:governmentnews/Components/Loading.dart';
import 'package:governmentnews/Components/loaditem.dart';
import 'package:governmentnews/Components/navigate.dart';
import 'package:governmentnews/Pages/CateView.dart';
import 'package:governmentnews/Pages/Event.dart';
import 'package:governmentnews/Pages/Login.dart';
import 'package:governmentnews/Pages/Profile.dart';
import 'package:governmentnews/Pages/rss.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();


class DrawerWidget extends StatelessWidget{

  final widgetWidth;

  DrawerWidget({ this.widgetWidth });

  @override
  Widget build(BuildContext context){
    return new StreamBuilder(
        stream:  _auth.onAuthStateChanged,
        builder: (BuildContext context,AsyncSnapshot<FirebaseUser> snapshot ){
            if(snapshot.hasError)
              return new Center(child: new Text('Error: ${snapshot.error}'),);
            if(!snapshot.hasData)
              return _notLoggedin(context);
            switch (snapshot.connectionState) {
              case ConnectionState.none: return new LoadItem();
              case ConnectionState.waiting: return new LoadItem();
              case ConnectionState.active: return loginDrawer(context,snapshot.data);
              case ConnectionState.done: return
                new Hero(
                  tag: "profilePic",
                  child: new Image.network(
                    snapshot.data.photoUrl,
                    fit: BoxFit.cover,
                  ),
                );
            //default: throw "Unknown: ${snapshot.connectionState}";
            }
        }
    );
  }

  Widget loginDrawer(context,firebaseUser){
    return new Drawer(
        child: new Container(
          color: Colors.grey[800],
          child: new Column(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountEmail: new Text(firebaseUser.email),
                accountName: new Text(firebaseUser.displayName),
                onDetailsPressed: () {
                  Navigator.pop(context);
                  new Navigate().onNavigate(
                      new Profile(
                        id: firebaseUser.uid,
                        email: firebaseUser.email,
                        name: firebaseUser.displayName,
                        profilePic: firebaseUser.photoUrl,
                        height: widgetWidth,
                      ), context);
                },
                currentAccountPicture: new CircleAvatar(
                    backgroundColor: Colors.white,
                    child: new Hero(
                      tag: "profilePic",
                      child: new Container(
                        decoration: new BoxDecoration(
                            image: new DecorationImage(
                                image: new NetworkImage(firebaseUser.photoUrl),
                                fit: BoxFit.cover),
                            shape: BoxShape.circle,
                            color: Colors.white),
                      ),
                    )),
                decoration: const BoxDecoration(
                    image: const DecorationImage(
                        image: const AssetImage("assets/images/drawer.png"),
                        fit: BoxFit.cover,
                        colorFilter: const ColorFilter.mode(
                            const Color.fromRGBO(68, 68, 68, 0.7),
                            BlendMode.darken))),
              ),
              new ListTile(
                title: const Text("What's new",
                    style: const TextStyle(color: Colors.white)),
                leading: const Icon(
                  Icons.new_releases,
                  color: Colors.white,
                ),
                onTap: (){
                  new Navigate().onNavigate(new CateViewPage(
                    id: 41,
                    name: 'Top Stories',
                  ), context);
                },
              ),
              new ListTile(
                title: new Text("Press Releases",
                    style: new TextStyle(color: Colors.white)),
                leading: new Icon(Icons.rss_feed, color: Colors.white),
                onTap: (){
                  new Navigate().onNavigate(new RssPage(), context);
                },
              ),
              new ListTile(
                title: new Text("Events",
                    style: new TextStyle(color: Colors.white)),
                leading: new Icon(Icons.comment, color: Colors.white),
                onTap: (){
                  new Navigate().onNavigate(new EventPage(), context);
                },
              ),
              new Divider(
                color: Colors.grey[600],
              ),
              new Container(
                padding: new EdgeInsets.only(
                  top: widgetWidth * 0.08,
                ),
                alignment: Alignment.bottomCenter,
                child: new ListTile(
                  onTap: () {
                    new Navigate().onNavigate(
                        new Profile(
                          id: firebaseUser.uid,
                          email: firebaseUser.email,
                          name: firebaseUser.displayName,
                          profilePic: firebaseUser.photoUrl,
                          height: widgetWidth,
                        ), context);
                  },
                  title: new Text("Favourite",
                      style: new TextStyle(color: Colors.white)),
                  leading: new Icon(Icons.favorite, color: Colors.white),
                ),
              ),
              new ListTile(
                onTap: ()async{
                  new Loading().onIndicate(context);
                  await _googleSignIn.signOut().then((googleAccount){
                     _auth.signOut().then((user)async{
                       await new Future.delayed(new Duration(milliseconds: 2000));
                        Navigator.pop(context);
                     }).catchError((e){
                       Navigator.pop(context);
                     });
                  }).catchError((e){
                    Navigator.pop(context);
                  });


                },
                title: new Text("Log out",
                    style: new TextStyle(color: Colors.white)),
                leading: new Icon(Icons.lock, color: Colors.white),
              ),
            ]
          ),
        )
    );
  }



  Widget _notLoggedin(context){
    return new Drawer(
        child: new Container(
          color: Colors.grey[800],
          child: new Column(
              children: <Widget>[
                new DrawerHeader(
                    decoration: new BoxDecoration(
                        image: new DecorationImage(
                            image: new AssetImage("assets/images/drawer.png"),
                            fit: BoxFit.cover,
                            colorFilter: new ColorFilter.mode(
                                new Color.fromRGBO(68, 68, 68, 0.7),
                                BlendMode.darken)
                        )
                    ),
                    child: new Image.asset("assets/images/gn.png",fit: BoxFit.fitWidth),
                ),
                new ListTile(
                  title: const Text("What's new",
                      style: const TextStyle(color: Colors.white)),
                  leading: const Icon(
                    Icons.new_releases,
                    color: Colors.white,
                  ),
                  onTap: (){
                    new Navigate().onNavigate(new CateViewPage(
                      id: 41,
                      name: 'Top Stories',
                    ), context);
                  },
                ),
                new ListTile(
                  title: new Text("Press Releases",
                      style: new TextStyle(color: Colors.white)),
                  leading: new Icon(Icons.rss_feed, color: Colors.white),
                  onTap: (){
                    new Navigate().onNavigate(new RssPage(), context);
                  },
                ),
                new ListTile(
                  title: new Text("Events",
                      style: new TextStyle(color: Colors.white)),
                  leading: new Icon(Icons.comment, color: Colors.white),
                  onTap: (){
                    new Navigate().onNavigate(new EventPage(), context);
                  },
                ),
                new Divider(
                  color: Colors.grey[600],
                ),
                new Container(
                  padding: new EdgeInsets.only(
                    top: widgetWidth * 0.08,
                  ),
                  alignment: Alignment.bottomCenter,
                  child: new ListTile(
                    enabled: true,
                    onTap: () {
//                      new Navigate().onNavigate(
//                          new Profile(),
//                          context);
                    },
                    title: new Text("Profile",
                        style: new TextStyle(color: Colors.white)),
                    leading: new Icon(Icons.person_pin, color: Colors.white),
                  ),
                ),
                new ListTile(
                  onTap: (){
                    Navigator.pop(context);
                    new Navigate().onNavigate(new LoginPage(), context);
                  },
                  title: new Text("Login",
                      style: new TextStyle(color: Colors.white)),
                  leading: new Icon(Icons.lock, color: Colors.white),
                ),
              ]
          ),
        )
    );
  }
}