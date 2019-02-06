import 'package:flutter/material.dart';
import 'package:governmentnews/Components/navigate.dart';
import 'package:governmentnews/Pages/CateView.dart';

class CategoryList extends StatelessWidget {
  final List cateList;

  CategoryList(this.cateList);

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Container(
        height: 100.0,
        margin: EdgeInsets.all(5.0),
        child: new ListView(
            scrollDirection: Axis.horizontal,
            children: cateList.skip(1).map((item){
              return new Container(
                width: 89.0,
                margin: EdgeInsets.only(left: 5.0,top: 5.0,bottom: 5.0),
                child: new Material(
                    elevation: 5.0,
                    color: Colors.grey[800],
                    textStyle: new TextStyle(color: Colors.white),
                    borderRadius: new BorderRadius.all(new Radius.circular(100.0)),
                    type: MaterialType.card,
                    child: new InkWell(
                        onTap: (){
                          new Navigate().onNavigate(new CateViewPage(
                            id: item['id'],
                            name: item['name'],
                          ), context);
                        },
                        splashColor: Colors.blue,
                        highlightColor: Colors.blue,
                        child: new Padding(
                          padding: EdgeInsets.all(item['name'] == "Accommodation" ? 13.0  : item['name'] == "Entertainment" ? 15.0 : 5.0),
                          child: new Center(
                            child: Text(item['name'],maxLines: 4,textAlign: TextAlign.center,style: TextStyle(fontSize: 13.0),),
                          ),
                        )
                    )
                ),
              );
            }).toList()
        ),
      ),
    );
  }
}