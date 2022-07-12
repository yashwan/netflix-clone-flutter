import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:convert';

import 'package:netflix_clone/screen/VideoPlayer/video_player.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SinglePageScreenComponent extends StatefulWidget {
  final id;

  const SinglePageScreenComponent({Key? key, required this.id})
      : super(key: key);

  @override
  State<SinglePageScreenComponent> createState() =>
      _SinglePageScreenComponentState();
}

class _SinglePageScreenComponentState extends State<SinglePageScreenComponent> {
  String _loadedPhotosVideo = '';
  bool noData = false;
  Future fetchDataVideo() async {
    try {
      var response = await Dio().get(
          'https://api.themoviedb.org/3/movie/${widget.id}/videos?api_key=360a9b5e0dea438bac3f653b0e73af47&language=en-US');

      var data = response.data;
      if (mounted) {
        setState(() {
          _loadedPhotosVideo = data["results"][0]['key'];
        });
      }
    } catch (e) {
      noData = true;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchDataVideo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List? data = [
      {
        "urlData":
            'https://api.themoviedb.org/3/movie/${widget.id}?api_key=360a9b5e0dea438bac3f653b0e73af47&language=en-US',
      },
      {
        'urlData':
            'https://api.themoviedb.org/3/movie/${widget.id.toString()}/credits?api_key=360a9b5e0dea438bac3f653b0e73af47&language=en-US&page=1'
      },
    ];
    return MovieDetails(
        id: widget.id,
        url: data[0]['urlData'],
        vid: noData ? '' : _loadedPhotosVideo);
  }
}

class MovieDetails extends StatefulWidget {
  final id;
  final url;
  final vid;
//Go8nTmfrQd8
  const MovieDetails({Key? key, required this.id, required this.url, this.vid})
      : super(key: key);

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  List _loadedPhotos = [];
  String img = "";
  String movieTitle = '';
  String movieOverview = '';
  bool noData = false;
  bool Adder = false;
  String poster_path = '';
  List genre = [];
  // The function that fetches data from the API
  // Future<void> _fetchData() async {
  //   final response = await http.get(Uri.parse(widget.url));
  //   Map<String, dynamic> map = json.decode(response.body);
  //   List<dynamic> data = map['results'];
  //   if(!mounted){return;}
  //   setState(() {
  //     _loadedPhotos = data;
  //   });
  // }

  // @override
  // void initState() {
  //   // TODO: implement initState

  //   super.initState();
  //   _fetchData();
  // }
  Future fetchDataVideo() async {
    try {
      var response = await Dio().get(
          'https://api.themoviedb.org/3/movie/${widget.id}?api_key=360a9b5e0dea438bac3f653b0e73af47&language=en-US');

      var data = response.data;
      if (mounted) {
        setState(() {
          _loadedPhotos.add(data);
          img = _loadedPhotos[0]['backdrop_path'];
          movieTitle = _loadedPhotos[0]['original_title'];
          movieOverview = _loadedPhotos[0]["overview"];
          poster_path = _loadedPhotos[0]["poster_path"];
          genre = _loadedPhotos[0]["genres"];
        });
      }
    } catch (e) {
      setState(() {
        noData = true;
      });
    }
  }

  String userId = '';
  String docId = '';

  final _auth = FirebaseAuth.instance;
  Future userData() async {
    final FirebaseUser user = await _auth.currentUser();
    setState(() {
      userId = user.uid;
    });
  }

  Future getData() async {
    try {
      await Firestore()
          .collection('users')
          .document(userId)
          .collection('usersMovie')
          .where('id', isEqualTo: widget.id)
          .getDocuments()
          .then((value) {
        if (value.documents.isNotEmpty) {
          if (value.documents[0].documentID != '' ||
              value.documents[0].documentID != null) {
            setState(() {
              docId = value.documents[0].documentID;
              Adder = !Adder;
              print('success');
            });
          } else {
            print('failure');
          }
        }
        print(value.documents.length);
      });
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  Future addData() async {
    try {
      final docs = await Firestore()
          .collection('users')
          .document(userId)
          .collection('usersMovie')
          .add({'id': widget.id, 'poster_path': poster_path});
      setState(() {
        docId = docs.documentID;
      });
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  Future deleteData() async {
    try {
      await Firestore()
          .collection('users')
          .document(userId)
          .collection('usersMovie')
          .document(docId)
          .delete();
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchDataVideo();
    userData().whenComplete(() => getData());

    super.initState();
  }

  com(index) {
    if (index < genre.length-1) {
      return Text(
        genre[index]['name'] + ', ',
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
      );
    } else if(index==genre.length-1) {
      return Text(
        genre[index]['name'] ,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print(genre);
    return noData
        ? const Text(
            'no Data 404',
            style: TextStyle(color: Colors.white),
          )
        : Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    height: 250,
                    child: Container(
                      child: Stack(
                        children: [
                          Container(
                            height: 300.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.black, Colors.transparent],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                              image: DecorationImage(
                                // ignore: unnecessary_null_comparison
                                image: NetworkImage(img == null || img == ''
                                    ? 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1024px-No_image_available.svg.png'
                                    : 'https://image.tmdb.org/t/p/original/$img'),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Container(
                            height: 300.0,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.black, Colors.transparent],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => {
                              if (Adder == false)
                                {
                                  addData().then((value) {
                                    setState(() {
                                      Adder = !Adder;
                                    });
                                  })
                                }
                              else
                                {
                                  deleteData().then((value) => setState(() {
                                        Adder = !Adder;
                                      }))
                                }
                            },
                            child: Adder
                                ? Icon(
                                    Icons.check_circle,
                                    size: 50,
                                    color: Colors.white60,
                                  )
                                : Icon(
                                    Icons.add_circle,
                                    size: 50,
                                    color: Colors.white60,
                                  ),
                          ),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                    child: Text(
                                  '$movieTitle',
                                  style: const TextStyle(
                                      fontSize: 30,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ))
                              ])
                        ],
                      ),
                    )),
                Expanded(
                    child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              ...genre.map((e) {
                                return com(genre.indexOf(e));
                              }),
                            ]),
                            SizedBox(
                              height: 9.5,
                            ),
                            Container(
                              child: Container(
                                child: GestureDetector(
                                  onTap: () => widget.vid == ''
                                      ? null
                                      : Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => VideoPlayer(
                                                  vid: widget.vid))),
                                  child: Container(
                                      height: 65,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Color.fromARGB(
                                                  255, 26, 19, 19)),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.play_arrow,
                                            size: 40.0,
                                          ),
                                          Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 0, 10, 0),
                                              child: Text("Play",
                                                  style: TextStyle(
                                                      fontSize: 26.0,
                                                      fontWeight:
                                                          FontWeight.bold)))
                                        ],
                                      )),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                            Expanded(
                                flex: 1,
                                child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Text(
                                      movieOverview,
                                      maxLines: 7,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )))
                          ],
                        )))
              ],
            ),
          );
  }
}
