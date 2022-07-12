// @dart=2.9

import 'package:flutter/material.dart';
import 'package:netflix_clone/screen/Authentication/login.dart';
import 'package:netflix_clone/screen/home_screen.dart';
import 'package:netflix_clone/screen/splash.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter netflix ',
     debugShowCheckedModeBanner: false,
     theme: ThemeData(
       scaffoldBackgroundColor: Colors.black
     ),
     home: const SplashScreen(),
    
    );
  }
}


