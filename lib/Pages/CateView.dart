import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:governmentnews/Components/Loading.dart';
import 'package:governmentnews/Components/NewContent.dart';


class CateViewPage extends StatefulWidget {

  final id;
  final name;

  CateViewPage({ this.id,this.name });

  @override
  _CateViewPageState createState() => new _CateViewPageState();

}

class _CateViewPageState extends State<CateViewPage> with TickerProviderStateMixin {

  Animation<double> animation;
  AnimationController controller;

  List dataList;
  List backupList;
  Loading _indication = new Loading();

  var httpClient = new HttpClient();

  TextEditingController _search = new TextEditingController();

  String searchMessage = "";

  double opacityLevel = 0.0;

  bool isOpen = false;


  void initState(){
    super.initState();
    getData(widget.id);

    controller = new AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    final Animation curve =
    new CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    animation = new Tween(begin: 1.0, end: 0.0).animate(curve)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });

  }

  void dispose(){
    super.dispose();
    controller.dispose();
  }

  onSearchAnimation(){
    controller.forward();
  }


  _changeOpacity() async{
    setState((){
      isOpen =! isOpen;
    });
    await new Future.delayed(new Duration(milliseconds: 200));
      setState((){opacityLevel = opacityLevel == 0 ? 1.0 : 0.0;});
  }

  Future getData(value) async {

    setState((){ dataList = null; });

    String url;

    if(value == 1){
      url = "https://www.adsproof.com/mobileapps/rest.php?category";
    }else if(value == null){
      url = "https://www.adsproof.com/mobileapps/rest.php?category";
    }else{
      url = "https://www.adsproof.com/mobileapps/rest.php?category=$value";
    }

    _indication.onIndicate(context);

    var results = [];

    var result;

    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(UTF8.decoder).join();
        var data = JSON.decode(json);
        results = data;

        setState(() {
          if(data.isNotEmpty){
            dataList = results;
            backupList = results;
          }
          if(results.isEmpty){
            searchMessage = "No News Found !!!";
          }
        });

        Navigator.pop(context);

      } else {
        result = 'Network Error : ${response.statusCode}';
        setState((){ searchMessage = result; });
        Navigator.pop(context);
      }
    } catch (exception) {
      result = 'There is no network make sure you are connected !!!';
      setState((){ searchMessage = result; });
      Navigator.pop(context);
    }

  }

  _onClear(){
    _search.clear();
    setState((){
      dataList = backupList;
    });

  }

  _onSearch(value){

    if(value.length == 1){
      setState((){
        dataList = backupList;
      });
    }

    var items = [];
    var results = [];
    items = dataList;

    if(value.length >= 5){
      items.forEach((item){
        var searchTitle = item['title'].toString().toLowerCase().contains(_search.text.toLowerCase());
        var searchContent = item['content'].toString().toLowerCase().contains(_search.text.toLowerCase());

        if(searchTitle || searchContent){
          results.add(item);
        }
      });

      if(results.isNotEmpty){
        setState((){
          dataList = results;
        });
      }

    }

  }

  @override
  Widget build(BuildContext context) {

    var fullwidth = MediaQuery.of(context).size.width;

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.name.toString().toUpperCase(),style: new TextStyle(fontSize: 15.0),),
        elevation: 0.0,
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.search), onPressed: (){
            controller.isCompleted ? controller.reset() : controller.forward();
          })
        ],
      ),
      body: new Column(
        children: <Widget>[
          new Transform(
            transform: new Matrix4.translationValues(animation.value * fullwidth, 0.0, 0.0),
            child: new Material(
              elevation: 5.0,
              color: const Color.fromRGBO(68, 68, 68, 1.0),
              child: new Container(
                margin: const EdgeInsets.all(7.0),
                child: new TextField(
                  controller: _search,
                  onChanged: (value){
                    _onSearch(value);
                    print(value);
                  },
                  decoration: new InputDecoration(
                      hintText: "Search",
                      prefixIcon: new IconButton(icon: new Icon(Icons.search), onPressed: (){ }),
                      suffixIcon: new IconButton(icon: new Icon(Icons.clear), onPressed: (){
                        _onClear();
                      }),
                      border: InputBorder.none),
                ),
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.all(new Radius.circular(35.0)),
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          new Expanded(
              child: new Container(
                child: new Transform(
                  transform: new Matrix4.translationValues(0.0, animation.value * -50.0, 0.0),
                  child: dataList != null ? new ListView(
                      children: dataList.map((item){
                        return new NewContent(
                          thumbnail: item['thumbnail'],
                          title: item['title'],
                          putDate: item['date'],
                          image: item['image'],
                          content: item['content'],
                          link: item['link'],
                          tag: item['id'],
                          height: 200.0,
                        );
                      }).toList()
                  ): new Center(
                    child: new Text(searchMessage),
                  ),
                ),
              )
          )
        ],
      ),
    );
  }
}
