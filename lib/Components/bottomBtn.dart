import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {

  final Function onPress;
  final int index;

  BottomNavBar({
    this.onPress,
    this.index
  });

  @override
  Widget build(BuildContext context) {
    return new Theme(
      data: Theme.of(context).copyWith(
        // sets the background color of the `BottomNavigationBar`
          canvasColor: Colors.blue,
          // sets the active color of the `BottomNavigationBar` if `Brightness` is light
          primaryColor: Colors.white,
          textTheme: Theme
              .of(context)
              .textTheme
              .copyWith(caption: new TextStyle(color: Colors.white70))
      ), // sets the inactive color of the `BottomNavigationBar`
      child: new BottomNavigationBar(
        onTap: onPress,
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        items: [
          new BottomNavigationBarItem(
            icon: new Icon(Icons.rss_feed),
            title: new Text("Lastest News"),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.favorite),
            title: new Text("Favourite"),
          )
        ],
      ),
    );
  }
}
