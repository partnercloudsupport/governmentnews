import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../Components/Loading.dart';
import '../Components/NewContent.dart';

class RssPage extends StatefulWidget {

  final id;
  final name;

  RssPage({ this.id,this.name });

  @override
  _RssPageState createState() => new _RssPageState();

}

class _RssPageState extends State<RssPage> {

  List dataList;
  List backupList;
  Loading _indication = new Loading();

  var httpClient = new HttpClient();

  TextEditingController _search = new TextEditingController();

  String searchMessage = "";

  double opacityLevel = 0.0;

  bool isOpen = false;


  initState(){
    super.initState();
    getData(widget.id);
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

    String url = "https://www.adsproof.com/mobileapps/rss.php";


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
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Press Releases'.toUpperCase(),style: new TextStyle(fontSize: 15.0),),
        elevation: 0.0,
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.search), onPressed: (){
            _changeOpacity();
          })
        ],
      ),
      body: new Column(
        children: <Widget>[
          isOpen != false ? new Container(
            child: new AnimatedOpacity(
              opacity: opacityLevel,
              curve: Curves.fastOutSlowIn,
              duration: new Duration(milliseconds: 300),
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
          ):new Text(''),
          new Expanded(
              child: new Container(
                child: dataList != null ? new ListView(
                    children: dataList.map((item){
                      return new NewContent(
                        thumbnail: item['image'],
                        title: item['title'],
                        putDate: item['pubDate'],
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
      ),
    );
  }
}
