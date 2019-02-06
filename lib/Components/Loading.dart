import 'package:flutter/material.dart';

class Loading{

  onIndicate(context)async{
    showDialog(
        barrierDismissible: false,
        context: context,
        child: new AlertDialog(
            content: new Row(
              children: <Widget>[
                const Padding(padding: const EdgeInsets.only(left: 10.0,right: 20.0),
                  child: const CircularProgressIndicator(),
                ),
                const Text("Please Wait ..."),
              ],
            )
        )
    );
  }
  //Snackbar indicator
  void showInSnackBar(String value,color,_scaffoldKey) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        duration: new Duration(milliseconds: 4500),
        backgroundColor: color,
        content: new Text(value)
    ));
  }

}