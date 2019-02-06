import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:governmentnews/Components/navigate.dart';
import 'package:governmentnews/Pages/Details.dart';

class TopNews extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    
    return new StreamBuilder(
        stream:  Firestore.instance.collection('/topnews').where('itemID', isEqualTo: 0).snapshots,
        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot ){
          if(snapshot.hasError)
            return new ContIndicator("Error: ${snapshot.error}");
          if(!snapshot.hasData)
            return new ContIndicator("There is not Data ...");
          if(snapshot.data.documents.isEmpty)
            return  new ContIndicator("There is not any news .....");
          if(snapshot.hasData){
            return new Container(
              height: 180.0,
              margin: const EdgeInsets.only(left: 10.0,right: 10.0,top: 10.0),
              child: new Card(
                  elevation: 3.0,
                  child: new Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      new Hero(
                        tag: snapshot.data.documents[0]['id'],
                        child: new FadeInImage(
                          placeholder: new AssetImage('assets/images/background.png'),
                          image: new NetworkImage(snapshot.data.documents[0]['thumbnail']),
                          fit: BoxFit.cover,
                        ),
                      ),
                      new Material(
                        color: Colors.transparent,
                        child: new InkWell(
                          onTap: (){
                            new Navigate().onNavigate(
                                new Details(
                                  tag: snapshot.data.documents[0]['id'],
                                  title: snapshot.data.documents[0]['title'],
                                  putDate: snapshot.data.documents[0]['date'],
                                  content: snapshot.data.documents[0]['content'],
                                  link: snapshot.data.documents[0]['link'],
                                  image: snapshot.data.documents[0]['image'],
                                ), context);
                          },
                          highlightColor: Colors.blue.withOpacity(0.5),
                          splashColor: Colors.blue.withOpacity(0.5),
                          child: new Container(
                            color: Colors.black.withOpacity(0.4),
                            child: new Column(
                              children: <Widget>[
                                new Expanded(child: Container()),
                                new Row(
                                  children: <Widget>[
                                    new Expanded(
                                      child: new Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: new Text(snapshot.data.documents[0]['title'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                    ),
                                    new Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: new OutlineButton(onPressed: (){
                                        new Navigate().onNavigate(
                                            new Details(
                                              tag: snapshot.data.documents[0]['id'],
                                              title: snapshot.data.documents[0]['title'],
                                              putDate: snapshot.data.documents[0]['date'],
                                              content: snapshot.data.documents[0]['content'],
                                              link: snapshot.data.documents[0]['link'],
                                              image: snapshot.data.documents[0]['image'],
                                            ), context);
                                      },
                                        color: Colors.blue,
                                        child: new Center(child: new Text("READ MORE ...",style: TextStyle(color: Colors.white),)
                                        ),
                                      ),
                                    )
                                  ],
                                )

                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )
              ),
            );
          }
        }
    );
  }
}

class ContIndicator extends StatelessWidget {

  final String message;

  ContIndicator(this.message);

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 180.0,
      margin: const EdgeInsets.only(left: 10.0,right: 10.0,top: 30.0),
      child: new Card(
        child: Center(
          child: Text(message),
        ),
      ),
    );
  }
}


