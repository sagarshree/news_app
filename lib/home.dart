import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'news_page.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

final userRef = Firestore.instance.collection('anonymousUsers');
final newsRef = Firestore.instance.collection('news');

final FirebaseAuth _auth = FirebaseAuth.instance;
DateTime timeStamp = DateTime.now();

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _success;
  String _userID;

  @override
  void initState() {
    super.initState();
    _signInAnonymously();
  }

  _signInAnonymously() async {
    final FirebaseUser user = (await _auth.signInAnonymously()).user;

    final FirebaseUser currentUser = await _auth.currentUser();

    if (user != null) {
      await updateUser();
      _success = true;
    } else {
      _success = false;
    }

    print('user is ${currentUser.uid}');
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NewsPage(
        func: _signOut,
      );
    }));
  }

  _signOut() async {
    await _auth.signOut();
    print('signed out');

    // return NewsPage();
  }

  updateUser() async {
    final FirebaseUser currentUser = await _auth.currentUser();
    DocumentSnapshot doc = await userRef.document(currentUser.uid).get();

    if (!doc.exists) {
      userRef
          .document(currentUser.uid)
          .setData({'id': currentUser.uid, 'timeStamp': timeStamp});
      doc = await userRef.document(currentUser.uid).get();
    }
    userRef.document(currentUser.uid).updateData({
      'timeStamp': timeStamp,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xffa549eb),
          Colors.blue,
        ],
      )),
      child: SpinKitFadingCircle(
        color: Colors.white,
      ),
    ));
  }
}
