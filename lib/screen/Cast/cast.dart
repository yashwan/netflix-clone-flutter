import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:netflix_clone/screen/home_screen.dart';
import 'package:netflix_clone/screen/search_screen.dart';
import 'dart:convert';

import 'package:netflix_clone/screen/single_page_screen/single_page_screen.dart';
import 'package:netflix_clone/screen/watchlist.dart';

class cast extends StatefulWidget {
  final id;
  final name;
  const cast({Key? key, required this.id, required this.name})
      : super(key: key);

  @override
  State<cast> createState() => _castState();
}

class _castState extends State<cast> {
  List _biography = [];
  List _relatedMovies = [];
  String img = '';
  String bio = '';
  bool loading1 = true;
  bool loading2 = true;
  bool noData1 = false;
  bool noData2 = false;
  Future<void> _fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          "https://api.themoviedb.org/3/person/${widget.id}/movie_credits?api_key=360a9b5e0dea438bac3f653b0e73af47"));
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> data = map['cast'] ?? [];
      if (!mounted) {
        return;
      }
      setState(() {
        _relatedMovies = data;
        loading1 = false;
      });
    } catch (e) {
      setState(() {
        noData1 = true;
      });
      
    }
  }

  Future<void> _fetchDataMovies() async {
    try {
      final response = await Dio().get(
          "https://api.themoviedb.org/3/person/${widget.id}?api_key=360a9b5e0dea438bac3f653b0e73af47");
      var data = response.data;

      if (!mounted) {
        return;
      }
      setState(() {
        _biography.add(data);
        bio = data["biography"];
        img = data['profile_path'];
        loading2 = false;
      });
    } catch (e) {
      setState(() {
        noData2 = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchData();
    _fetchDataMovies();
  }

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    List _page = [const HomeScreen(), SearchScreen(), WatchList()];

    return (loading1 && loading2)? (
      Scaffold(
      body: SafeArea(
        child: Text('Loading...',style: TextStyle(
          fontSize: 40,
          color: Colors.white,
        ),)
      )
    )
    ):Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => setState(() {
                currentIndex = index;
                if (index == 0) {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    }
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
          ]),
      body: SafeArea(
          child: CustomScrollView(
        slivers: [
          noData1?  Scaffold(
      body: SafeArea(
        child: Text('Loading...',style: TextStyle(
          fontSize: 40,
          color: Colors.white,
        ),)
      )
    ): SliverAppBar(
              expandedHeight: 350,
              collapsedHeight: 350,
              backgroundColor: Colors.black,
              flexibleSpace: Stack(children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      colors: [Colors.black, Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                    image: DecorationImage(
                      image: NetworkImage(img == ''
                          ? 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1024px-No_image_available.svg.png'
                          : 'https://image.tmdb.org/t/p/original/$img'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black, Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                Container(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                      Text(
                        widget.name,
                        style: const TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                      )
                    ]))
              ])),
          
              noData1?  Scaffold(
      body: SafeArea(
        child: Text('Loading...',style: TextStyle(
          fontSize: 40,
          color: Colors.white,
        ),)
      )
    ):SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  child: Text(
                    bio,
                    style: const TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 147, 138, 138),
                        fontWeight: FontWeight.w700),
                  ),
                );
              },
              childCount: 1,
            ),
          ),
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 180,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 2 / 3,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SinglePageScreen(
                                id: _relatedMovies[index]['id']))),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.network(
                          _relatedMovies[index]['poster_path'] == ""|| _relatedMovies[index]['poster_path'] == null
                              ? 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1024px-No_image_available.svg.png'
                              : 'https://image.tmdb.org/t/p/original/${_relatedMovies[index]['poster_path']}',
                        )),
                  ),
                );
              },
              childCount: _relatedMovies.length,
            ),
          ),
        ],
      )),
    );
  
  }
}

 