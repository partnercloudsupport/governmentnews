import 'package:flutter/material.dart';

class HeaderError extends StatelessWidget {
  final headerHeight;

  HeaderError({this.headerHeight});

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
      new Container(
        height: headerHeight,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new CircularProgressIndicator(),
            new Padding(
              padding: const EdgeInsets.all(10.0),
              child: new Text(
                'Please Check your Network ...',
                style: new TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      )
    ]);
  }
}
