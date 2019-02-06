import 'package:flutter/material.dart';

class NewsTitle extends StatelessWidget{
  final title;
  final height;
  final putDate;

  NewsTitle({ this.height , this.putDate ,this.title });

  @override
  build(BuildContext context){
    return new Container(
      decoration: const BoxDecoration(
          color: const Color.fromRGBO(68, 68, 68, 0.6)
      ),
      padding: new EdgeInsets.only(left: 20.0,right: 10.0,top: 10.0),
      height: this.height,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(this.title,style: new TextStyle(color: Colors.white, fontSize: 19.0),),
          new Row(
            children: <Widget>[
              new Padding(padding: const EdgeInsets.only(top: 10.0,right: 10.0,bottom: 10.0),
                child: new Icon(Icons.timer,color: Colors.white,),
              ),
              new Text(this.putDate,style: new TextStyle(color: Colors.white))
            ],
          ),
        ],
      ),
    );
  }
}