import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../Components/Loading.dart';
import '../Components/navigate.dart';
import '../Pages/EventDetail.dart';

class EventPage extends StatefulWidget{
  _EventPageState createState() => new _EventPageState();
}

class _EventPageState extends State<EventPage>{

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
  }

  Future getData() async {

    String url = "https://www.adsproof.com/mobileapps/events.php";

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
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Image.asset("assets/images/gn.png",height: 35.0,),
      ),
      body: new ListView(
        children: dataList.map((event){
          return new Card(
            child: new InkWell(
              onTap: (){
                new Navigate().onNavigate(
                    new EventDetailPage(url: event['link'],eventDate: event['date'],),context);
              },
              child: new Container(
                height: 100.0,
                child: new Row(
                  children: <Widget>[
                    new Container(
                      width:80.0,
                      margin: const EdgeInsets.only(right: 10.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: new BoxDecoration(
                        color: Colors.blue
                      ),
                      child: new Column(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Text(
                            event['date'].toString().substring(0,2),
                            style: new TextStyle(color: Colors.white,fontSize: 48.0,fontWeight: FontWeight.bold),
                          ),
                          new Expanded(
                              child:new Text(
                                event['date'].toString().substring(2,event['date'].toString().length),maxLines: 2,
                                style: new TextStyle(color: Colors.white,fontSize: 12.0),
                              ),
                          )
                        ],
                      )
                    ),
                    new Expanded(
                        child: new Text(
                          event['title'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )
                    )
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      )
    );
  }
}