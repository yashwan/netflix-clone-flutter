import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:netflix_clone/screen/home_screen.dart';
import 'package:netflix_clone/screen/search_screen.dart';
import 'package:netflix_clone/screen/single_page_screen/single_page_screen.dart';

class WatchList extends StatefulWidget {
  WatchList({Key? key}) : super(key: key);

  @override
  State<WatchList> createState() => _WatchListState();
}

class _WatchListState extends State<WatchList> {
  String userId = '';
  String docId = '';
  List movies = [];
  bool loading = true;
  final _auth = FirebaseAuth.instance;
  Future userData() async {
    final FirebaseUser user = await _auth.currentUser();
    setState(() {
      userId = user.uid;
    });
  }

  Future moviesData() async {
    try {
      await Firestore()
          .collection('users')
          .document(userId)
          .collection('usersMovie')
          .getDocuments()
          .then((value) => value.documents.forEach((element) {
                movies.add(element.data);
              }))
          .then((value) {
        setState(() {
          loading=false;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    userData().whenComplete(() => moviesData());
    super.initState();
  }

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    List _page = [const HomeScreen(), SearchScreen(), WatchList()];
    return loading? Scaffold(
      body: SafeArea(
        child: Text('Loading...',style: TextStyle(
          fontSize: 40,
          color: Colors.white,
        ),)
      )
    ):SafeArea(
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
      body: CustomScrollView(
        slivers: [
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 180,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 2/ 3,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SinglePageScreen(id: movies[index]['id']))),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.network(
                          movies[index]['poster_path'] == null ||
                                  movies[index]['poster_path'] == ''
                              ? 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1024px-No_image_available.svg.png'
                              : (movies[index]['poster_path'][0] == '/'
                                  ? 'https://image.tmdb.org/t/p/original/${movies[index]['poster_path']}'
                                  : 'https://image.tmdb.org/t/p/original/${movies[index]['poster_path']}'),
                        )),
                  ),
                );
              },
              childCount: movies.length,
            ),
          ),
        ],
      ),
    ));
  
  }
}
