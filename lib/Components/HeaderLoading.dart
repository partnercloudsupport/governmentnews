import 'package:flutter/material.dart';

class HeaderLoading extends StatelessWidget {
  final headerHeight;

  HeaderLoading({this.headerHeight});

  @override
  Widget build(BuildContext context) {
    return new Stack(fit: StackFit.expand, children: <Widget>[
      new Image.asset(
        'assets/images/background.png',
        fit: BoxFit.cover,
        height: headerHeight,
      ),
      const DecoratedBox(
        decoration:
            const BoxDecoration(color: const Color.fromRGBO(68, 68, 68, 0.6)),
      ),
      new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new CircularProgressIndicator(),
            new Text('Loading ...',style: new TextStyle(color: Colors.white),)
          ],
        ),
      )
    ]);
  }
}
