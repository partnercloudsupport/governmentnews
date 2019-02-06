import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:governmentnews/Components/navigate.dart';
import 'package:governmentnews/Pages/Details.dart';

class NewsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
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
            return NewsCard(
              title: document['title'],
              image: document['image'],
              content: document['content'],
              putDate: document['date'],
              link: document['link'],
              thumbnail: document['thumbnail'],
              tag: document['id'],
            );
          }).toList(),
        );
      },
    );
  }
}

class NewsCard extends StatelessWidget {

  final putDate;
  final image;
  final title;
  final content;
  final link;
  final thumbnail;
  final tag;

  NewsCard({
    this.title,
    this.content,
    this.image,
    this.putDate,
    this.thumbnail,
    this.link,
    this.tag
  });


  onNavigate(context){
    new Navigate().onNavigate(
        new Details(
          image: this.image == null ? this.thumbnail : this.image,
          title: this.title,
          putDate: this.putDate,
          content: this.content,
          tag: this.tag,
          link: this.link,
        ), context);
  }

  @override
  Widget build(BuildContext context) {

    var width =  MediaQuery.of(context).size.width;

    return new Container(
      height: 130.0,
      margin: const EdgeInsets.only(left: 5.0,top: 10.0,right: 5.0),
      child: new Stack(
        children: <Widget>[
          new Container(
            width: width,
            height: 130.0,
            child: new Container(
              margin: const EdgeInsets.only(top: 7.0, bottom: 7.0),
              child: new Card(
                elevation: 4.0,
                child: new InkWell(
                  onTap: (){
                    onNavigate(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Expanded(child: Container()),
                      Container(
                        width: width * 0.5,
                        child: new Padding(
                          padding: const EdgeInsets.only(bottom: 8.0,top: 8.0),
                          child: new Column(
                            children: <Widget>[
                              new Expanded(child: new Center(
                                child: new Padding(
                                    padding: const EdgeInsets.only(left: 5.0,right: 5.0),
                                    child: Text(this.title.toString().toUpperCase(),overflow: TextOverflow.ellipsis,maxLines: 3,),
                                  ),
                                ),
                              ),
                              new Center(
                                child: new Padding(
                                  padding: const EdgeInsets.only(left: 5.0,right: 50.0),
                                  child: new Text(this.putDate,textAlign: TextAlign.left,style: TextStyle(color: Colors.grey[600]),)
                                ),
                              ),

                            ],
                          ),
                        )
                      )
                    ],
                  ),
                ),
              ),
            )
          ),
         Container(
           alignment: Alignment.centerLeft,
           width: width * 0.4,
           child: Card(
               elevation: 4.0,
               child: new InkWell(
                 onTap: (){
                   onNavigate(context);
                 },
                 child: new Hero(
                   tag: this.tag,
                   child: new FadeInImage(
                       fit: BoxFit.cover,
                       width: width * 0.4,
                       placeholder: new AssetImage("assets/images/loading.png"),
                       image: new NetworkImage(this.thumbnail)
                   ),
                 ),
               )
           ),
         ),
        ],
      ),
    );
  }
}
