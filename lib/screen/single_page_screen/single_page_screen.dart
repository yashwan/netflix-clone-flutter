import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:netflix_clone/screen/Cast/cast.dart';
import 'package:netflix_clone/screen/home_screen.dart';
import 'package:netflix_clone/screen/search_screen.dart';
import 'package:netflix_clone/screen/single_page_screen/single_page_screen_component.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:netflix_clone/screen/watchlist.dart';

class SinglePageScreen extends StatefulWidget {
  final int id;

  const SinglePageScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<SinglePageScreen> createState() => _SinglePageScreenState();
}

class _SinglePageScreenState extends State<SinglePageScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<String> tabs = <String>['Recommendations', 'Cast'];
    List _page = [const HomeScreen(), SearchScreen(), WatchList()];
    return DefaultTabController(
      length: tabs.length, // This is the number of tabs.
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: Colors.transparent,
          ),
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
                  icon: Icon(Icons.account_box),
                  label: 'Account',
                ),
              ]),
          body: SafeArea(
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                // These are the slivers that show up in the "outer" scroll view.
                return <Widget>[
                  SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                    sliver: SliverAppBar(
                      collapsedHeight: 500.0,
                      expandedHeight: 500.0,
                      backgroundColor: Colors.black,
                      forceElevated: innerBoxIsScrolled,
                      automaticallyImplyLeading: false,
                      flexibleSpace: SinglePageScreenComponent(id: widget.id),
                    ),
                  ),
                  SliverPersistentHeader(
                    delegate: _SliverAppBarDelegate(
                      TabBar(
                        indicatorColor: Colors.red,
                        tabs: tabs
                            .map((String name) => Tab(
                                  child: Text(
                                    '$name',
                                    style: const TextStyle(
                                        fontSize: 17, color: Colors.white),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    pinned: true,
                  ),
                ];
              },
              body: TabBarView(
                children: [
                  MovieRecommendations(
                      url:
                          'https://api.themoviedb.org/3/movie/${widget.id.toString()}/recommendations?api_key=360a9b5e0dea438bac3f653b0e73af47&language=en-US&page=1'),
                  MovieCredits(
                      url:
                          'https://api.themoviedb.org/3/movie/${widget.id.toString()}/credits?api_key=360a9b5e0dea438bac3f653b0e73af47&language=en-US&page=1')
                ],
                // These are the contents of the tab views, below the tabs.
              ),
            ),
          )),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Colors.black,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class MovieRecommendations extends StatefulWidget {
  final url;

  const MovieRecommendations({Key? key, required this.url}) : super(key: key);

  @override
  State<MovieRecommendations> createState() => _MovieRecommendationsState();
}

class _MovieRecommendationsState extends State<MovieRecommendations> {
  List loadedPhotos = [];
  bool noData = false;
  Future<void> _fetchData() async {
    try {
      final response = await http.get(Uri.parse(widget.url));
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> data = map['results'] ?? [];
      if (!mounted) {
        return;
      }
      setState(() {
        loadedPhotos = data;
      });
    } catch (e) {
      noData = true;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    
    return noData?Text(
        'no Data 404',
        style: TextStyle(color: Colors.white),
      ):GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 180,
            childAspectRatio: 2 / 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemCount: loadedPhotos.length,
        itemBuilder: (context, index) {
          return Container(
            child: GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SinglePageScreen(id: loadedPhotos[index]['id']))),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Image.network(
                    (loadedPhotos[index]['poster_path'] == null ||
                            loadedPhotos[index]['poster_path'] == ''
                        ? 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1024px-No_image_available.svg.png'
                        : 'https://image.tmdb.org/t/p/original${loadedPhotos[index]['poster_path']}'),
                  )),
            ),
          );
        });
  }
}

class MovieCredits extends StatefulWidget {
  final url;

  const MovieCredits({Key? key, required this.url}) : super(key: key);

  @override
  State<MovieCredits> createState() => _MovieCreditsState();
}

class _MovieCreditsState extends State<MovieCredits> {
  List loadedPhotos = [];
  bool noData = false;
  Future<void> _fetchData() async {
    try {
      final response = await http.get(Uri.parse(widget.url));
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> data = map['cast'] ?? [];
      if (!mounted) {
        return;
      }
      setState(() {
        loadedPhotos = data;
      });
    } catch (e) {
      noData = true;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    if (noData) {
      return Text(
        'no Data 404',
        style: TextStyle(color: Colors.white),
      );
    }
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 180,
            childAspectRatio: 2 / 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemCount: loadedPhotos.length >= 12 ? 12 : loadedPhotos.length,
        itemBuilder: (context, index) {
          return Container(
            child: GestureDetector(
              onTap: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => cast(
                            id: loadedPhotos[index]["id"],
                            name: loadedPhotos[index]['name'])))
              },
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Stack(
                    children: [
                      Image.network(
                        (loadedPhotos[index]['profile_path'] == null ||
                                loadedPhotos[index]['profile_path'] == ''
                            ? 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1024px-No_image_available.svg.png'
                            : 'https://image.tmdb.org/t/p/original${loadedPhotos[index]['profile_path']}'),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                '${loadedPhotos[index]['name']}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white70),
                              ))
                        ],
                      )
                    ],
                  )),
            ),
          );
        });
  }
}


// CustomScrollView(
    //   scrollDirection: Axis.vertical,
    //   shrinkWrap: true,
    //   slivers: [
    //     SliverGrid(
    //         delegate: SliverChildBuilderDelegate((context, index) {
    //           return 
    //         ;
    //         }),
    //         gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
    //             maxCrossAxisExtent: 200.0,
    //             mainAxisSpacing: 10.0,
    //             crossAxisSpacing: 10.0,
    //             childAspectRatio: 4.0))
    //   ],
    // );