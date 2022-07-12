import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:netflix_clone/screen/Authentication/login.dart';
import 'package:netflix_clone/screen/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _auth = FirebaseAuth.instance;
  String userId = '';
  Future<void> userData() async {
    try {
      final FirebaseUser user = await _auth.currentUser();
      if (user.uid != null) {
        setState(() {
          userId = user.uid;
        });
      } else {
        userId = '';
      }
    } catch (e) {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    userData().whenComplete(() async {
      await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  userId == '' ? Login() : const HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
