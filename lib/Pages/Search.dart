import 'package:flutter/material.dart';
import '../Components/Loading.dart';
import '../Components/NewContent.dart';
import '../data/category.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

class SearchPage extends StatefulWidget {
  _SearchPageState createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {

  var httpClient = new HttpClient();

  List choices = new CategoryData().choices;

  String selectedChoice = "Categories";
  String selectedValue;

  Loading _indication = new Loading();

  TextEditingController _search = new TextEditingController();

  AnimationController animationController;
  Animation<double> animation;

  void initState(){
    super.initState();

    animationController =  new AnimationController(vsync: this,duration: new Duration(milliseconds: 1000));

    final CurvedAnimation curvedAnimation = CurvedAnimation(parent: animationController,curve: Curves.fastOutSlowIn);

    animation = new Tween(begin: 0.0,end: 100.0).animate(curvedAnimation)
      ..addListener((){
      setState(() {

      });
    });

  }


  List dataList;
  String searchMessage = "";
  String _isSelected;

  _onSearch(){
    print(_search.text);
    getSWData();
  }
  _onClear(){
    _search.clear();
    setState((){
      dataList = null;
    });
  }


  Future getSWData() async {

    setState((){ dataList = null; });

    String url;

    if(selectedValue == "1"){
       url = "https://www.adsproof.com/mobileapps/rest.php?category";
    }else if(selectedValue == null){
      url = "https://www.adsproof.com/mobileapps/rest.php?category";
    }else{
       url = "https://www.adsproof.com/mobileapps/rest.php?category=$selectedValue";
    }

    _indication.onIndicate(context);

    var items = [];
    var results = [];

    var result;

    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(UTF8.decoder).join();
        var data = JSON.decode(json);

          items = data;

          items.forEach((item){

            var searchTitle = item['title'].toString().toLowerCase().contains(_search.text.toLowerCase());
            var searchContent = item['content'].toString().toLowerCase().contains(_search.text.toLowerCase());

            if(searchTitle || searchContent){
              results.add(item);
            }

          });

        setState(() {
          if(results.isNotEmpty){
            dataList = results;
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

    var items = [];
    var results = [];

    var result;

    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(UTF8.decoder).join();
        var data = JSON.decode(json);

        items = data;

        items.forEach((item){

          var searchTitle = item['title'].toString().toLowerCase().contains(_search.text.toLowerCase());
          var searchContent = item['content'].toString().toLowerCase().contains(_search.text.toLowerCase());

          if(searchTitle || searchContent){
            results.add(item);
          }

        });

        setState(() {
          if(results.isNotEmpty){
            dataList = results;
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

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: new Image.asset("assets/images/gn.png",height: 35.0,),
      ),
      body: new Container(
              child: new Column(
                children: <Widget>[
                    new Material(
                      elevation: 5.0,
                      color: const Color.fromRGBO(68, 68, 68, 1.0),
                      child: new Container(
                        margin: const EdgeInsets.all(7.0),
                        child: new TextField(
                          controller: _search,
                          onSubmitted: (value){
                            print(value);
                            _onSearch();
                          },
                          decoration: new InputDecoration(
                              hintText: "Search",
                              prefixIcon: new IconButton(icon: new Icon(Icons.search), onPressed: (){ _onSearch(); }),
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
                  new Material(
                    color: const Color.fromRGBO(68, 68, 68, 1.0),
                    child: new Container(
                      height: 55.0,
                      child: new ListView(
                        // This next line does the trick.
                        scrollDirection: Axis.horizontal,
                        children: choices.map((document){
                          return new InkWell(
                            radius: 20.0,
                            onTap:(){
                              setState((){ _isSelected = document['name']; });
                              getData(document['id']);
                            },
                            child: new Container(
                              margin: const EdgeInsets.only(left:5.0,top: 10.0,bottom: 10.0),
                              decoration: new BoxDecoration(
                                borderRadius: new BorderRadius.all(new Radius.circular(35.0)),
                                border: new Border.all(color: _isSelected == document['name'] ? Colors.blue : Colors.white,width: 1.2)
                              ),
                              width: document['width'],
                              child: new Center(
                                child: new Text(document['name'],style:new TextStyle(color:Colors.white)),
                              )
                            ),
                          );
                        }).toList()
                      ),
                    )
                  ),
                  new Expanded(
                      child: new Container(
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
                      )
                  )
                ],
            )
        ),
    );
  }
}
