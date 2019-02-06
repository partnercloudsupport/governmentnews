import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:governmentnews/Components/FavouriteList.dart';
import 'package:governmentnews/Components/navigate.dart';
import 'package:governmentnews/Pages/Login.dart';
import 'package:governmentnews/Pages/Search.dart';
import '../Components/CategoryList.dart';
import '../Components/Drawer.dart';
import '../Components/NewsList.dart';
import '../Components/TopNews.dart';
import '../Components/bottomBtn.dart';
import '../data/category.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => new _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin{

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageController pageController;

  AnimationController _slideAnimation;

  List cateList = new CategoryData().choices;

  int _page = 0;

  double transWidth = 1000.0;
  Animation<double> slide1animation;
  Animation<double> slide2animation;


  @override
  void initState() {
    super.initState();
    pageController = new PageController();

    _slideAnimation = new AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this
    );

    final Animation curve =
    new CurvedAnimation(parent: _slideAnimation, curve: Curves.fastOutSlowIn);

    slide1animation = new Tween(begin: 0.0, end: -1.0).animate(curve)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });
    slide2animation = new Tween(begin: -2.0, end: 0.0).animate(curve)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });

  }

  void onChangePage(e) {
    setState(() {
      _page = e;
    });
    e == 1 ? _slideAnimation.forward() : _slideAnimation.reverse();
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });

  }

  @override
  Widget build(BuildContext context) {

    double widgetWidth = MediaQuery.of(context).size.width;
    double widgetHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerWidget(widgetWidth: widgetHeight),
      appBar: new AppBar(
        elevation: 0.0,
        title: new Image.asset(
          'assets/images/gn.png',
          fit: BoxFit.cover,
          height: 37.0,
        ),
      ),
      body: new Container(
        child: Stack(
          children: <Widget>[
            Container(
              color: new Color.fromRGBO(68, 68, 68, 1.0),
              height: widgetHeight * 0.15,
            ),
            new Transform(
              transform: new Matrix4.translationValues(slide1animation.value * widgetWidth, 0.0, 0.0),
              child: new Container(
                  child: new ListView(
                    children: <Widget>[
                      new TopNews(),
                      //Categories List
                      new CategoryList(cateList),

                      new NewsList()
                    ],
                  )
              ),
            ),
            new Transform(
                transform: new Matrix4.translationValues(slide2animation.value * widgetWidth, 0.0, 0.0),
              child: new Container(
                child: new ListView(
                  children: <Widget>[
                    new Container(
                      child: new Material(
                          elevation: 5.0,
                          color: Colors.blue,
                          child: Center(
                            child: new Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: Text('FAVOURITE NEWS',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 25.0,
                                    color: Colors.white,
                                    letterSpacing: 5.0
                                ),
                              ),
                            ),
                          )
                      ),
                      margin: const EdgeInsets.only(top: 30.0, left: 10.0,right: 10.0),
                      height: 130.0,
                    ),
                    new Container(
                      margin: const EdgeInsets.only(top: 10.0),
                      child: new StreamBuilder(
                          stream:  _auth.onAuthStateChanged,
                          builder: (BuildContext context,AsyncSnapshot<FirebaseUser> snapshot ){
                            if(snapshot.hasError)
                              return new Center(child: new Text('Error: ${snapshot.error}'),);
                            if(!snapshot.hasData)
                              return new Container(
                                  margin: new EdgeInsets.only(top: widgetHeight * 0.2 ),
                                  child: Center(
                                    child: new InkWell(
                                        onTap: (){
                                          new Navigate().onNavigate(new LoginPage(), context);
                                        },
                                        child: Text("... PLEASE LOGIN TO CONTINUE ...")
                                    ),
                                  )
                              );
                            if(snapshot.hasData){
                              return new FavouriteList(snapshot.data.uid);
                            }
                          }
                      ),
                    )
                  ],
                )
              ),
            )
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
          //backgroundColor: new Color.fromRGBO(68, 68, 68, 1.0),
          notchMargin: 6.0,
          onPressed: () {
            new Navigate().onNavigate(new SearchPage(),context);
            },
          child: new Icon(Icons.search)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: new BottomAppBar(
        hasNotch: true,
        child: new BottomNavBar(
          onPress: onChangePage,
          index: _page,
        ),
      ),
    );
  }

  // DISPOSE

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _slideAnimation.dispose();
  }

}




