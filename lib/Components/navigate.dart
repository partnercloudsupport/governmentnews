import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';

class Navigate {
  onNavigate(Widget className, context) {
    if (Platform.isAndroid) {
      Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return className;
        },
      ));
    } else {
      Navigator.of(context).push(new CupertinoPageRoute<Null>(
        builder: (BuildContext context) {
          return className;
        },
      ));
    }
  }
}
