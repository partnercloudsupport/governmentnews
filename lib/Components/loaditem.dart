import 'package:flutter/material.dart';

class LoadItem extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return new Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const CircularProgressIndicator(),
          const Padding(padding: const EdgeInsets.all(10.0),
            child: const Text("Loading ...."),
          )
        ],
      )
    );
  }
}