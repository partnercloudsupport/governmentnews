

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../Components/Loading.dart';
import '../Components/NewContent.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math';
import 'dart:io';

final FirebaseAuth _auth = FirebaseAuth.instance;

class Profile extends StatefulWidget{
  final name;
  final email;
  final id;
  final profilePic;
  final height;

  Profile({this.name, this.email, this.id, this.profilePic, this.height});

  MyProfileState createState() => new MyProfileState();
}

class MyProfileState extends State<Profile> {

  Loading showIndicator = new Loading();

  final TextEditingController _name = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _telephone = new TextEditingController();

  String errorNumber;

  UserUpdateInfo userUpdate = new UserUpdateInfo();

  String imageurl = "";

  initState(){
    super.initState();

    setState((){
      imageurl = widget.profilePic;
    });

  }

  onUpdate() async{
    await showIndicator.onIndicate(context);
    File imageFile = await ImagePicker.pickImage();
    int random = new Random().nextInt(100000);
    StorageReference ref = FirebaseStorage.instance.ref().child("image_$random.jpg");
    StorageUploadTask uploadTask = ref.put(imageFile);
    Uri downloadUrl = (await uploadTask.future).downloadUrl;
    userUpdate.photoUrl =  downloadUrl.toString();
    await _auth.updateProfile(userUpdate).then((user)async{
          setState((){
            imageurl == downloadUrl.toString();
          });
        await new Future.delayed(new Duration(milliseconds: 1500));
          Navigator.pop(context);
    });

  }

  onNumberUpdate()async{
    if(_telephone.text.startsWith("0")){
      setState((){ errorNumber = "Your Phone number should not start with  a Zero"; });
      return;
    }else if(_telephone.text.length != 9){
      setState((){ errorNumber = "Phone number must contain 9 digits "; });
      return;
    }else{
      setState((){ errorNumber = null; });
    }
    await showIndicator.onIndicate(context);
    await Firestore.instance.collection('phone').document("${widget.id}").setData({"telephone":"${_telephone.text}","id":"${widget.id}"}).then((res)async{
          userUpdate.displayName =  _name.text.toUpperCase();
          await _auth.updateProfile(userUpdate).then((user)async{
          await new Future.delayed(new Duration(milliseconds: 1500));
            Navigator.pop(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    var totalHeight = widget.height;
    _name.text = widget.name.toString().toUpperCase();
    _email.text = widget.email.toString().toUpperCase();

    return new Scaffold(
      body: new CustomScrollView(
        slivers: [
          new SliverAppBar(
            expandedHeight: totalHeight * 0.4,
            backgroundColor: Colors.black87.withOpacity(0.5),
            title: new Image.asset(
              'assets/images/gn.png',
              fit: BoxFit.cover,
              height: 38.0,
            ),
            pinned: true,
            actions: <Widget>[
              new IconButton(
                  icon: new Icon(Icons.add_a_photo), onPressed: () {
                  onUpdate();
              }),
              new IconButton(icon: new Icon(Icons.save), onPressed: () {
                onNumberUpdate();
              })
            ],
            centerTitle: false,
            flexibleSpace: new FlexibleSpaceBar(
              background: new Stack(
                fit: StackFit.expand,
                children: <Widget>[

                  const DecoratedBox(
                    decoration: const BoxDecoration(
                      color: Colors.white
                    ),
                  ),

                new StreamBuilder(
                  stream: _auth.onAuthStateChanged, // a Stream<int> or null
                  builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
                    if (snapshot.hasError)
                      return new Text('Error: ${snapshot.error}');
                    switch (snapshot.connectionState) {
                      case ConnectionState.none: return new Text('Select lot');
                      case ConnectionState.waiting: return new Text('Awaiting bids...');
                      case ConnectionState.active: return
                        new Hero(
                          tag: "profilePic",
                          child: new Image.network(
                            snapshot.data.photoUrl,
                            fit: BoxFit.cover,
                          ),
                        );
                      case ConnectionState.done: return
                          new Hero(
                              tag: "profilePic",
                              child: new Image.network(
                                snapshot.data.photoUrl,
                                fit: BoxFit.cover,
                              ),
                          );
                      //default: throw "Unknown: ${snapshot.connectionState}";
                    }
                  },
                ),

                  const DecoratedBox(
                    decoration: const BoxDecoration(
                      gradient: const LinearGradient(
                        begin: const Alignment(0.0, -0.5),
                        end: const Alignment(0.0, -0.25),
                        colors: const <Color>[const Color.fromRGBO(68, 68, 68, 0.5), const Color.fromRGBO(68, 68, 68, 0.2)],
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
          new SliverList(
              delegate: new SliverChildListDelegate(<Widget>[
            //NAME
            new Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, right: 20.0, top: 10.0),
              child: new TextField(
                controller: _name,
                decoration: new InputDecoration(
                  icon: new Icon(Icons.person),
                  suffixIcon: new Icon(Icons.edit),
                ),
              ),
            ),
            //E-MAIL
            new Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, right: 20.0, top: 10.0),
              child: new TextField(
                controller: _email,
                decoration: new InputDecoration(
                  icon: new Icon(Icons.email),
                  suffixIcon: new Icon(Icons.edit),
                ),
              ),
            ),
          //Number
          new StreamBuilder(
              stream:  Firestore.instance.collection("phone").where("id",isEqualTo: widget.id).snapshots,
              builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot ){
                if(snapshot.hasError){
                  _telephone.clear();
                  return new Text('Error: ${snapshot.error}');
                }
                if(!snapshot.hasData) {
                  _telephone.clear();
                  return new Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 20.0, top: 10.0),
                    child: new TextField(
                      controller: _telephone,
                      keyboardType: TextInputType.number,
                      decoration: new InputDecoration(
                        icon: new Icon(Icons.phone_iphone),
                        suffixIcon: new Icon(Icons.edit),
                        prefixText: "+27",
                        errorText: errorNumber
                      ),
                    ),
                  );
                }
                if(snapshot.data.documents.isEmpty) {
                  _telephone.clear();
                  return new Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 20.0, top: 10.0),
                    child: new TextField(
                      controller: _telephone,
                      keyboardType: TextInputType.number,
                      decoration: new InputDecoration(
                        icon: new Icon(Icons.phone_iphone),
                        suffixIcon: new Icon(Icons.edit),
                        prefixText: "+27",
                        errorText: errorNumber
                      ),
                    ),
                  );
                }
                if(snapshot.hasData)
                  _telephone.text = snapshot.data.documents[0]["telephone"];
                
                  return new Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 10.0),
                      child: new TextField(
                        controller: _telephone,
                        keyboardType: TextInputType.number,
                        decoration: new InputDecoration(
                          icon: new Icon(Icons.phone_iphone),
                          suffixIcon: new Icon(Icons.edit),
                          prefixText: "+27",
                          errorText: errorNumber
                        ),
                      ),
                    );

              }
          ),


            //TELEPHONE
          ])),
        ],
      ),
    );
  }
}
