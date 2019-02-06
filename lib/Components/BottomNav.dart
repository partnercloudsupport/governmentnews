import 'package:flutter/material.dart';
import 'package:governmentnews/Components/navigate.dart';
import 'package:governmentnews/Pages/CateView.dart';


class BottomNav extends StatelessWidget{

  final List cateList;

  BottomNav({
    this.cateList
  });

  @override
  build(BuildContext context){
    return new Container(
      height: 60.0,
      color: const Color.fromRGBO(68, 68, 68, 1.0),
      child: new ListView(
        // This next line does the trick.
          scrollDirection: Axis.horizontal,
          children: cateList.skip(1).map((document){
            return new Container(
                margin: const EdgeInsets.only(left:10.0,top: 7.0,bottom: 7.0),
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
                  //border: new Border.all(color: Colors.white,width: 1.2)
                ),
                width: document['width'],
                child: new Material(
                    elevation: 10.0,
                    color: const Color.fromRGBO(68, 68, 68, 1.0),
                    borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
                    child: new InkWell(
                      onTap: (){
                        new Navigate().onNavigate(new CateViewPage(
                          id: document['id'],
                          name: document['name'],
                        ), context);
                      },
                      child: new Container(
                        decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
                            border: new Border.all(color: Colors.white,width: 1.2)
                        ),
                        child: new Center(
                          child: new Text(document['name'],style:new TextStyle(color:Colors.white)),
                        ),
                      ),
                    )
                )
            );
          }).toList()
      ),
    );
  }
}