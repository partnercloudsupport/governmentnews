import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:governmentnews/Components/NewContent.dart';

class FavouriteList extends StatelessWidget {

  final uid;

  FavouriteList(this.uid);

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
        stream:  Firestore.instance.collection("favourite").where("userID",isEqualTo: this.uid).snapshots,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasError){
            return new Center(
              child: new Text("Error has occurred : ${snapshot.error}"),
            );
          }
          if(!snapshot.hasData){
            return new Center(
              child: new Text("You haven't added any news yet !!!"),
            );
          }
          if(snapshot.data.documents.isEmpty){
            return new Center(
              child: new Text("You haven't added any news yet !!!"),
            );
          }
          if(snapshot.hasData){
            return new Column(
              children: snapshot.data.documents.reversed.map((document) {
                return new Dismissible(
                  key: new Key(document.documentID),
                  onDismissed: (direction){
                    Firestore.instance.document("favourite/${document.documentID}").delete().then((v){ print("DELETE"); });
                  },
                  background: new Container(
                      color: Colors.red,
                      child: new Center(child: new Text("DELETE",style: new TextStyle(fontSize: 25.0,letterSpacing: 10.5),))
                  ),
                  child: new NewContent(
                    tag: document.documentID,
                    title: document['title'],
                    image: document['image'],
                    thumbnail: document['image'],
                    putDate: document['pubDate'],
                    content: document['content'],
                    link: document['link'],
                  ),
                );
              }).toList(),
            );
          }
        });
  }
}
