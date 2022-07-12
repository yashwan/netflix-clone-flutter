// import 'dart:html';

// import 'package:axios/axios.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:netflix_clone/screen/home_screen_components/CustomAppBar.dart';

// import 'package:dio/dio.dart';
import 'package:netflix_clone/screen/home_screen_components/row.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:netflix_clone/screen/search_screen.dart';
import 'package:netflix_clone/screen/watchlist.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List data=[];
  // Future getHttp() async {
  //   try {
  //     var response = await Dio().get("https://api.themoviedb.org/3/discover/tv?api_key=360a9b5e0dea438bac3f653b0e73af47&with_genre=11");
  //     setState(() {
  //       data.add(response.redirects);
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }
  int currentIndex = 0;
  List _loadedPhotos = [];
  int randomNumber = 0;

  // The function that fetches data from the API
  Future<void> _fetchData() async {
    const url =
        'https://api.themoviedb.org/3/discover/tv?api_key=360a9b5e0dea438bac3f653b0e73af47&with_genre=11';

    final response = await http.get(Uri.parse(url));
    Map<String, dynamic> map = json.decode(response.body);
    List<dynamic> data = map['results'];

    setState(() {
      _loadedPhotos = data;
      Random random = Random();
      randomNumber = random.nextInt(data.length);
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List _page = [const HomeScreen(), SearchScreen(), WatchList()];
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[850],
        child: const Icon(Icons.cast),
        onPressed: () => print("pr"),
      ),
      extendBodyBehindAppBar: true,
      appBar: const PreferredSize(
        preferredSize: Size(0.0, 60.0),
        child: CustomAppBar(),
      ),
      body: const RowComp(),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => setState(() {
                currentIndex = index;
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => _page[index]));
              }),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.black,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.watch_later),
              label: 'Watchlist',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.account_box),
            //   label: 'Account',
            // ),
          ]),
    );
  }
}
