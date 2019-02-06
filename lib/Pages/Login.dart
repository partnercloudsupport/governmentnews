import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:validator/validator.dart';

// new
final FirebaseAuth _auth = FirebaseAuth.instance;
//final GoogleSignIn _googleSignIn = new GoogleSignIn();

GoogleSignIn _googleSignIn = new GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class LoginPage extends StatefulWidget {
  _MyLoginPageState createState() => new _MyLoginPageState();
}

class _MyLoginPageState extends State<LoginPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  PageController _pageController;
  ScrollController _scrollController;
  UserUpdateInfo userUpdateInfo = new UserUpdateInfo();

  TextEditingController _loginEmail = new TextEditingController();
  TextEditingController _loginPassword = new TextEditingController();

  TextEditingController _signupName = new TextEditingController();
  TextEditingController _signupEmail = new TextEditingController();
  TextEditingController _signupPassword = new TextEditingController();
  TextEditingController _signupConfirmPassword = new TextEditingController();

  int _page = 0;
  String emailError;
  String nameError;
  String passwordError;
  String cpassword;
  String loginemailError;
  String loginPasswordError;

  bool isSecured = true;

  @override
  void initState() {
    super.initState();
    _pageController = new PageController();
    _scrollController = new ScrollController();
    _googleSignIn.signOut().then((user){
      _auth.signOut();
      print('logout');
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _scrollController.dispose();
  }

  void _onAuth() async {
    await _signInWithGoogle();
  }

  //Snackbar indicator
  void showInSnackBar(String value,color) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        duration: new Duration(milliseconds: 4500),
        backgroundColor: color,
        content: new Text(value)
    ));
  }

  //Dialog Loading indicator

  _onIndicate()async{
    showDialog(
      barrierDismissible: false,
        context: context,
        child: new AlertDialog(
            content: new Row(
              children: <Widget>[
                const Padding(padding: const EdgeInsets.only(left: 10.0,right: 20.0),
                  child: const CircularProgressIndicator(),
                ),
                const Text("Please Wait ..."),
              ],
            )
        )
    );
  }


  //Login With Email and Password
  _loginEmailPassword()async{
      _onIndicate();
      await _loginvalidateAll();
      await _auth.signInWithEmailAndPassword(email: _loginEmail.text, password: _loginPassword.text)
        .then((FirebaseUser user)async{

         Navigator.pop(context);
         showInSnackBar("Welcome To Government news ${user.displayName}", Colors.blue);
         _onClear();
        await new Future.delayed(new Duration(milliseconds: 1500));
          Navigator.pop(context);


      }).catchError((e){

        Navigator.pop(context);
        if(e.toString().contains("The password is invalid or the user does not have a password.")){
          showInSnackBar("The password is invalid or the user does not have a password.",Colors.red);
          setState((){ emailError = "email address is already in use";});
        }else{
          showInSnackBar(e.toString(),Colors.red);
          print(e);
        }

      });
  }



  //Login with Google
  Future<String> _signInWithGoogle() async {

    final GoogleSignInAccount googleUser = await _googleSignIn.signIn().catchError((onError){
      print(onError);
       showInSnackBar(onError.toString(), Colors.red);
    });
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    await _onIndicate();

    final FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

     Navigator.pop(context);
     showInSnackBar("Welcome To Government news ${currentUser.displayName}", Colors.blue);
    await new Future.delayed(new Duration(milliseconds: 1500));
      Navigator.pop(context);

    return user.uid;
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  void navigationTapped(int page) {
    // Animating to the page.
    // You can use whatever duration and curve you like
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 500), curve: Curves.linear);
  }

  void _onValueChnaged(value) {
    _scrollController.animateTo(
      MediaQuery.of(context).size.height * value,
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 1000),
    );
  }

  _emailValid(email){
    if(isEmail(email)){
      setState((){ emailError = null; });
    }else{
      setState((){ emailError = "Invalid email ..."; });
      print(email);
    }
  }

  _loginemailValid(email){
    if(isEmail(email)){
      setState((){ loginemailError = null; });
    }else{
      setState((){ loginemailError = "Invalid email ..."; });
      print(email);
    }
  }

  _validateName(String value) {
    final RegExp nameExp = new RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value)){
      setState((){ nameError = "Please enter only alphabetical characters."; });
    }else{
      setState((){ nameError = null; });
    }
  }

  _validatePassword(String value){
    if (value.length < 6){
      setState((){ passwordError = "No less than 6 characters."; });
    }else{
      setState((){ passwordError = null; });
    }
  }

  _loginValidatePassword(String value){
    if (value.length < 6){
      setState((){ loginPasswordError = "No less than 6 characters."; });
    }else{
      setState((){ loginPasswordError = null; });
    }
  }

  _validateConfirmPassword(String value){
    if (value.length < 6){
      setState((){ cpassword = "No less than 6 characters."; });
    }else{
      setState((){ cpassword = null; });
    }
  }

  _validateAll(){
    if(_signupName.text.isEmpty){
      setState((){ nameError = "Name is required "; });
      return;
    }
    if(_signupEmail.text.isEmpty){
      setState((){ emailError = "E-mail is required "; });
      return;
    }
    if(_signupPassword.text.isEmpty){
      setState((){ passwordError = "Password is required "; });
      return;
    }
    if(_signupConfirmPassword.text.isEmpty){
      setState((){ cpassword = "Confirm your Password"; });
      return;
    }

    if(_signupConfirmPassword.text != _signupPassword.text){
      setState((){ cpassword = "Password do not match !!!"; });
      return;
    }
  }

  _loginvalidateAll(){
    if(_loginEmail.text.isEmpty){
      setState((){ loginemailError = "E-mail is required "; });
      return;
    }
    if(_loginPassword.text.isEmpty){
      setState((){ loginPasswordError = "Password is required "; });
      return;
    }
  }

  // SIGN UP //
  // ======= //

  _onRegister()async{
    _onIndicate();
    await _validateAll();
    await _auth.createUserWithEmailAndPassword(email: _signupEmail.text, password: _signupPassword.text)
         .then((FirebaseUser user)async{
          userUpdateInfo.photoUrl = "http://www.kickoff.com/chops/images/resized/large/no-image-found.jpg";
          userUpdateInfo.displayName = _signupName.text;
    await _auth.updateProfile(userUpdateInfo)
           .then((onValue)async{
             Navigator.pop(context);
             showInSnackBar("Welcome To Government news ${_signupName.text}", Colors.blue);
             _onClear();
            await new Future.delayed(new Duration(milliseconds: 1500));
              Navigator.pop(context);
        });
    }).catchError((e){
      Navigator.pop(context);
      if(e.toString().contains("The email address is already in use by another account.")){
        showInSnackBar("The email address is already in use by another account.",Colors.red);
        setState((){ emailError = "email address is already in use";});
      }else{
        showInSnackBar(e.toString(),Colors.red);
      }
    });
  }

  //clearForm
  _onClear(){

    _loginEmail.clear();
    _loginPassword.clear();
    _signupName.clear();
    _signupEmail.clear();
    _signupPassword.clear();
    _signupConfirmPassword.clear();

  }




  @override
  Widget build(BuildContext context) {
    var widgetWidth = MediaQuery.of(context).size;

    return new Scaffold(
        key: _scaffoldKey,
        body: new PageView(
      controller: _pageController,
      onPageChanged: onPageChanged,
      children: <Widget>[
        new Container(
            width: widgetWidth.width * 0.5,
            color: Colors.white,
            child: _loginScreen(context, widgetWidth)),
        new Container(
            color: Colors.white, child: _signUpScreen(context, widgetWidth))
      ],
    ));
  }

  //welcome Screen

  Widget _loginScreen(context, widgetWidth) {
    return new SingleChildScrollView(
        controller: _scrollController,
        child: new Container(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                  height: widgetWidth.height * 0.28,
                  width: widgetWidth.width,
                  child: new Stack(
                    children: <Widget>[
                      new Image.asset(
                        "assets/images/drawer.png",
                        fit: BoxFit.cover,
                        width: widgetWidth.width,
                      ),
                      new BackdropFilter(
                        filter: new ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                        child: new Container(
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                      new Center(
                          child: new Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: new Image.asset(
                          "assets/images/gn.png",
                          fit: BoxFit.cover,
                          width: widgetWidth.width * 0.6,
                        ),
                      )),
                      new Container(
                        padding: const EdgeInsets.only(top: 20.0),
                        alignment: Alignment.topLeft,
                        child: new IconButton(
                            icon: new Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      ),
                    ],
                  )),
              new Container(
                width: widgetWidth.width * 0.85,
                padding: const EdgeInsets.only(top: 20.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new TextField(
                      controller: _loginEmail,
                      onChanged: (value){
                        _loginemailValid(value);
                        _onValueChnaged(0.08);
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: new InputDecoration(
                          hintText: "Enter Your email Address",
                          labelText: 'E-mail',
                          errorText: loginemailError,
                          prefixIcon: const Padding(
                            padding: const EdgeInsets.only(
                              right: 10.0,
                            ),
                            child: const Icon(Icons.email),
                          )),
                      autofocus: false,
                    ),
                    new TextField(
                      obscureText: isSecured,
                      controller: _loginPassword,
                      onChanged: (value){
                        _loginValidatePassword(value);
                        _onValueChnaged(0.22);
                      },
                      decoration: new InputDecoration(
                          hintText: "Enter Your Password",
                          labelText: 'Password',
                          errorText: loginPasswordError,
                          prefixIcon: const Padding(
                            padding: const EdgeInsets.only(
                              right: 10.0,
                            ),
                            child: const Icon(Icons.lock),
                          ),
                          suffixIcon: new IconButton(
                              padding: const EdgeInsets.only(top: 10.0),
                              icon: new Icon( isSecured ? Icons.visibility_off : Icons.visibility),
                                  onPressed: (){
                                    setState((){
                                      isSecured =! isSecured;
                                    });
                              }
                          )
                      ),
                      autofocus: false,
                    ),
                    new Divider(height: 50.0,color: Colors.transparent,)
                  ],
                ),
              ),
              new RaisedButton(
                onPressed: () {
                  _loginEmailPassword();
                },
                color: Colors.black87,
                child: new Container(
                  width: widgetWidth.width * 0.78,
                  height: 50.0,
                  child: new Center(
                    child: new Text(
                      "SIGN IN",
                      style: new TextStyle(
                        fontSize: 16.0,
                        color: Colors.white
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              new Divider(
                height: 25.0,
                color: Colors.transparent,
              ),
//              new RaisedButton(
//                onPressed: () {
//                  _onAuth();
//                },
//                color: Colors.black87,
//                child: new Container(
//                    width: widgetWidth.width * 0.78,
//                    height: 50.0,
//                    child: new Row(
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      children: <Widget>[
//                        new Container(
//                          width: widgetWidth.width * 0.18,
//                          padding: const EdgeInsets.all(10.0),
//                          height: 50.0,
//                          child: new Image.asset(
//                            "assets/images/search.png",
//                            fit: BoxFit.contain,
//                            height: 40.0,
//                          ),
//                        ),
//                        new Container(
//                          padding: const EdgeInsets.only(left: 10.0),
//                          width: widgetWidth.width * 0.60,
//                          child: new Text(
//                            "SIGN IN WITH GOOGLE",
//                            style: new TextStyle(
//                              fontSize: 16.0,
//                              color: Colors.white
//                            ),
//                            textAlign: TextAlign.start,
//                          ),
//                        )
//                      ],
//                    )),
//              ),
              new InkWell(
                onTap: () {
                  navigationTapped(1);
                },
                child: new Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: new RichText(
                      text: new TextSpan(
                        style: new TextStyle(color: Colors.black87),
                        text: "Don't have an Account ?",
                        children: <TextSpan>[
                          new TextSpan(
                              text: '  SIGN UP !',
                              style:
                                  new TextStyle(fontWeight: FontWeight.bold,color: Colors.black87)),
                        ],
                      ),
                    )),
              )
            ],
          ),
        ));
  }

  //Register
  Widget _signUpScreen(context, widgetWidth) {
    return new SingleChildScrollView(
        controller: _scrollController,
        child: new Container(
          child: new Column(
            children: <Widget>[
              new Container(
                height: widgetWidth.height * 0.28,
                child: new Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    new Image.asset(
                      "assets/images/drawer.png",
                      fit: BoxFit.cover,
                    ),
                    new BackdropFilter(
                      filter: new ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: new Container(
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: new Center(
                        child: new Text(
                          "REGISTER HERE",
                          style: new TextStyle(
                              letterSpacing: 7.0,
                              color: Colors.white,
                              fontSize: 18.0),
                        ),
                      ),
                    ),
                    new Container(
                        alignment: Alignment.topLeft,
                        child: new Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: new IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                navigationTapped(0);
                              }),
                        ))
                  ],
                ),
              ),
              new Container(
                  padding: const EdgeInsets.only(
                      top: 20.0, left: 10.0, right: 10.0, bottom: 10.0),
                  child: new Column(
                    children: <Widget>[
                      new TextField(
                        controller:_signupName,
                        onChanged: (name){
                          _validateName(name);
                        },
                        decoration: new InputDecoration(
                            hintText: "Name and Surname",
                            labelText: 'Name',
                            errorText: nameError,
                            prefixIcon: const Padding(
                              padding: const EdgeInsets.only(
                                right: 10.0,
                              ),
                              child: const Icon(Icons.person),
                            )),
                        autofocus: false,
                      ),
                      new TextField(
                        controller: _signupEmail,
                        onChanged: (value){
                          _emailValid(value);
                          _onValueChnaged(0.08);
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: new InputDecoration(
                            hintText: "Enter Your email Address",
                            labelText: 'E-mail',
                            errorText: emailError,
                            prefixIcon: const Padding(
                              padding: const EdgeInsets.only(
                                right: 10.0,
                              ),
                              child: const Icon(Icons.email),
                            )),
                        autofocus: false,
                      ),
                      new TextField(
                        obscureText: true,
                        controller: _signupPassword,
                        onChanged: (value){
                          _validatePassword(value);
                          _onValueChnaged(0.22);
                        },
                        decoration: new InputDecoration(
                            hintText: "Enter Your Password",
                            labelText: 'Password',
                            errorText: passwordError,
                            prefixIcon: const Padding(
                              padding: const EdgeInsets.only(
                                right: 10.0,
                              ),
                              child: const Icon(Icons.lock),
                            )),
                        autofocus: false,
                      ),
                      new TextField(
                        obscureText: true,
                        controller: _signupConfirmPassword,
                        onChanged: (value){
                          _validateConfirmPassword(value);
                          _onValueChnaged(0.35);
                        },
                        decoration: new InputDecoration(
                            hintText: "Type The same Password here",
                            labelText: 'Confirm Password',
                            errorText: cpassword,
                            prefixIcon: const Padding(
                              padding: const EdgeInsets.only(
                                right: 10.0,
                              ),
                              child: const Icon(Icons.lock_outline),
                            )),
                        autofocus: false,
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(
                          top: 30.0,
                        ),
                        child: new RaisedButton(
                          color: Colors.black87,
                          onPressed: () {
                            _onRegister();
                          },
                          child: new Container(
                            height: 45.0,
                            child: new Center(
                              child: new Text(
                                "SIGN UP",
                                style: new TextStyle(
                                    fontSize: 16.0,
                                    letterSpacing: 4.0,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      new Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: new Material(
                            color: Colors.white,
                            child: new InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: new Center(
                                child: new Text("EXIT"),
                              ),
                            ),
                          ))
                    ],
                  )),
            ],
          ),
        ));
  }
}
