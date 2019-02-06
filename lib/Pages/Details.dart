import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Components/Loading.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share/share.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;

class Details extends StatefulWidget{

  final title;
  final putDate;
  final content;
  final image;
  final height;
  final link;
  final tag;

  Details(
      {this.image,
        this.putDate,
        this.title,
        this.content,
        this.height,
        this.tag,
        this.link});

  _DetailState createState() => new _DetailState();

}

class _DetailState extends State<Details>{

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Loading _indicate = new Loading();


  String newImage;
  bool isAdded = false;
  String uid;

  initState(){
    super.initState();

  }

  addFavourite()async{


    _auth.currentUser().then((FirebaseUser user){

      uid = user.uid;

        setState((){
          isAdded =! isAdded;
        });

        _indicate.onIndicate(context);
        var data = {
          'userID': uid,
          'title': widget.title,
          'content' : widget.content,
          'pubDate' : widget.putDate,
          'link' : widget.link,
          'image' : widget.image,
        };
        Firestore.instance.collection("favourite").document().setData(data).then((res){
          Navigator.pop(context);
          _indicate.showInSnackBar("News Added !!!", Colors.blue, _scaffoldKey);
        }).catchError((e){
          Navigator.pop(context);
          _indicate.showInSnackBar(e.toString(), Colors.red, _scaffoldKey);
        });

    }).catchError((e){
      _indicate.showInSnackBar("Error has occured : Please Make sure you are Logged In !!!", Colors.red, _scaffoldKey);
    });


  }


  Future<Null> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future _shared(link)async{
    if(link != null)
      return share(link);
  }


  @override
  Widget build(BuildContext context) {


    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Image.asset(
          'assets/images/gn.png',
          fit: BoxFit.cover,
        ),
        actions: <Widget>[
      widget.tag.toString().length <= 7 ?  new IconButton(
              icon: new Icon(
                Icons.favorite,
                color: isAdded ? Colors.red : Colors.white,
              ),
              onPressed: () {
                  addFavourite();
              }) : new Text(''),
         new IconButton(icon: new Icon(Icons.share), onPressed: (){ _shared(widget.link); }),
         new IconButton(
              icon: new Icon(
                Icons.open_in_browser,
                color: Colors.white,
              ),
              onPressed: () {
                _launchInBrowser(widget.link);
              }),
        ],
      ),
      body: new SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              new Container(
                child: new Hero(
                    tag: widget.tag,
                    child: new FadeInImage(
                        placeholder: const AssetImage("assets/images/bannerloading.png"),
                        image: new NetworkImage(widget.image),
                      fit: BoxFit.fitWidth,
                    )
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(15.0),
                child: new Text(widget.content,style: new TextStyle(fontSize: 15.0),),
              ),
            ],
          ),
        )
    );
  }
}
