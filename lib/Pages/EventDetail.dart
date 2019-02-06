import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../Components/Loading.dart';
import 'package:share/share.dart';

class EventDetailPage extends StatefulWidget {

  final String url;
  final String eventDate;

  EventDetailPage({
   this.url,this.eventDate
  });


  @override
  _EventDetailPageState createState(){
    return new _EventDetailPageState();
  }
}

class _EventDetailPageState extends State<EventDetailPage> {

  List dataList = [];
  List backupList;
  Loading _indication = new Loading();

  var httpClient = new HttpClient();

  String searchMessage = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    print(widget.url);
  }

  Future getData() async {

    String url = "https://www.adsproof.com/mobileapps/eventd.php?tag=${widget.url}";

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
          }else{
            searchMessage = "Invalid Content from The Source !!!";
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

  Future _shared(link)async{
    if(link != null)
      return share(link);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.eventDate.toUpperCase(),style: new TextStyle(fontSize: 15.0),),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(
                Icons.share,
                color: Colors.white,
              ),
              onPressed: () {
                _shared(widget.url);
              }),
        ],
      ),
      body: new Container(
        padding: const EdgeInsets.all(15.0),
        child: dataList.isNotEmpty ? new ListView(
          children: dataList.map((item){
            return
              new Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: new Text(item['desc'],style: new TextStyle(fontSize: 15.0),),
              );
          }).toList()
        ) : new Text(searchMessage,style: new TextStyle(color: Colors.red),),
      ),
    );
  }
}
