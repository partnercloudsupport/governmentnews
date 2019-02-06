import 'package:flutter/material.dart';
import 'package:governmentnews/Components/navigate.dart';
import 'package:governmentnews/Components/newstitle.dart';
import 'package:governmentnews/Pages/Details.dart';


class MainHeader extends StatelessWidget {
  final data;
  final height;

  MainHeader({this.data, this.height});

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: (){
        new Navigate().onNavigate(
            new Details(
                image: data[0]['image'],
                title: data[0]['title'],
                putDate: data[0]['pubDate'],
                content: data[0]['content'],
                tag: data[0]['id'],
                height: this.height,
            ), context);
      },
      child: new Stack(fit: StackFit.expand, children: <Widget>[
        new Image.asset('assets/images/background.png'),
        new Hero(tag: this.data[0]['id'], child: new FadeInImage(
          placeholder: new AssetImage('assets/images/background.png'),
          image: new NetworkImage(this.data[0]['thumbnail']),
          fit: BoxFit.cover,
          height: this.height,
          ),
        ),
        const DecoratedBox(
          decoration:
          const BoxDecoration(color: const Color.fromRGBO(68, 68, 68, 0.6)),
        ),
        new Padding(
          padding: new EdgeInsets.only(top: height * 0.55, bottom: 10.0),
          child: new NewsTitle(
            title: this.data[0]['title'],
            putDate: this.data[0]['date'],
            height: this.height * 0.5,
          ),
        )
      ]),
    );
  }
}
