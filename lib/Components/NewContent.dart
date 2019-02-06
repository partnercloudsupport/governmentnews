import 'package:flutter/material.dart';
import 'package:governmentnews/Components/navigate.dart';
import 'package:governmentnews/Pages/Details.dart';



class NewContent extends StatelessWidget{

  final putDate;
  final image;
  final title;
  final content;
  final height;
  final link;
  final thumbnail;
  final tag;

  NewContent({
    this.title,
    this.content,
    this.image,
    this.putDate,
    this.height,
    this.thumbnail,
    this.link,
    this.tag
  });

  @override
  build(BuildContext context){

    return new Padding(padding: const EdgeInsets.only(top: 2.0, left: 5.0, right: 2.0),
      child: new Card(
        child: new InkWell(
            onTap: (){
              new Navigate().onNavigate(
                  new Details(
                    image: this.image == null ? this.thumbnail : this.image,
                    title: this.title,
                    putDate: this.putDate,
                    content: this.content,
                    height: this.height,
                    tag: this.tag,
                    link: this.link,
                  ), context);
            },
          child: new Row(
            children: <Widget>[
              new Container(
                width:95.0,
                height: 95.0,
                child: new Hero(
                    tag: this.tag,
                    child: new FadeInImage(
                        fit: BoxFit.cover,
                        placeholder: new AssetImage("assets/images/loading.png"),
                        image: new NetworkImage(this.thumbnail)
                    )
                ),
              ),
              new Flexible(
                  fit: FlexFit.loose,
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        padding: const EdgeInsets.only(bottom: 5.0,left: 8.0),
                        child: new Text(this.title,style: new TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.w300, fontSize: 16.0)),
                      ),
                      new Container(
                        padding: const EdgeInsets.only(top: 5.0,left: 8.0),
                        child: new Text(
                          this.putDate,
                          style: new TextStyle(color: Colors.grey[500], fontFamily: "Roboto"),
                        ),
                      ),
                    ],
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}