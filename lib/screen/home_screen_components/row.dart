// import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:ffi';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:netflix_clone/screen/single_page_screen/single_page_screen.dart';

class RowComp extends StatefulWidget {
  const RowComp({Key? key}) : super(key: key);

  @override
  State<RowComp> createState() => _RowCompState();
}

class _RowCompState extends State<RowComp> {
  bool loading = true;
  
  
 

  List data = [
    {'name': '', 'url': ''},
    {
      'name': "Trending",
      'url':
          "https://api.themoviedb.org/3/trending/all/day?api_key=360a9b5e0dea438bac3f653b0e73af47&language=en-US",
    },
    {
      'name': "Netflix Originals",
      'url':
          "https://api.themoviedb.org/3/discover/tv?api_key=360a9b5e0dea438bac3f653b0e73af47&with_networks=213",
    },
    {
      'name': "Toprated",
      'url':
          "https://api.themoviedb.org/3/movie/top_rated?api_key=360a9b5e0dea438bac3f653b0e73af47&language=en-US",
    },
    {
      'name': "Action",
      'url':
          "https://api.themoviedb.org/3/discover/movie?api_key=360a9b5e0dea438bac3f653b0e73af47&with_genres=28",
    },
    {
      'name': "Binge-Worthy",
      'url':
          "https://api.themoviedb.org/3/discover/tv?api_key=360a9b5e0dea438bac3f653b0e73af47&with_genre=11",
    },
    {
      'name': "Horror",
      'url':
          "https://api.themoviedb.org/3/discover/movie?api_key=360a9b5e0dea438bac3f653b0e73af47&with_genres=27",
    },
    {
      'name': "Romance",
      'url':
          "https://api.themoviedb.org/3/discover/movie?api_key=360a9b5e0dea438bac3f653b0e73af47&with_genres=10749",
    },
    {
      'name': "Documentaries",
      'url':
          "https://api.themoviedb.org/3/discover/movie?api_key=360a9b5e0dea438bac3f653b0e73af47&with_genres=99",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
            padding: const EdgeInsets.only(top: 0),
            itemCount: data.length,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              if (index == 0) {
                return const getBackgroundImage();
              }
              return SizedBox(
                height: 270,
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        data[index]["name"],
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500),
                      ),
                      tileColor: Colors.black,
                    ),
                    ImagePack(url: data[index]['url'])
                  ],
                ),
              );
            });
  }
}

class ImagePack extends StatefulWidget {
  final url;

  const ImagePack({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  State<ImagePack> createState() => _ImagePackState();
}

class _ImagePackState extends State<ImagePack> {
  static const spinkit = SpinKitRotatingCircle(
    color: Colors.white,
    size: 50.0,
  );
  List _loadedPhotos = [];
  var loading = true;

  // The function that fetches data from the API
  Future<void> _fetchData() async {
    try {
      final response = await http.get(Uri.parse(widget.url));
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> data = map['results'];
      if (!mounted) {
        return;
      }
      setState(() {
        _loadedPhotos = data.toList();
        loading = false;
      });
    } catch (e) {}
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    // TODO: implement
    super.dispose();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    // print(_loadedPhotos);

    return loading
        ? spinkit
        : Expanded(
            child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SinglePageScreen(
                                  id: _loadedPhotos[index]['id']))),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            _loadedPhotos[index]['poster_path'] == null ||
                                    _loadedPhotos[index]['poster_path'] == ''
                                ? 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1024px-No_image_available.svg.png'
                                : 'https://image.tmdb.org/t/p/original${_loadedPhotos[index]['poster_path']}',
                            errorBuilder: (context, error, stackTrace) {
                              return Text('Your error widget...');
                            },
                          )),
                    ),
                    margin: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                    padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                  );
                }));
  }
}

class getBackgroundImage extends StatefulWidget {
  const getBackgroundImage({Key? key}) : super(key: key);

  @override
  State<getBackgroundImage> createState() => _getBackgroundImageState();
}

class _getBackgroundImageState extends State<getBackgroundImage> {
  List _loadedPhotos = [];
  int randomNumber = -1;
  bool loading = true;
  static const spinkit = SpinKitRotatingCircle(
    color: Colors.white,
    size: 50.0,
  );
  // The function that fetches data from the API
  Future<void> _fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          "https://api.themoviedb.org/3/discover/movie?api_key=360a9b5e0dea438bac3f653b0e73af47&with_genres=27"));
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> data = map['results'];
      setState(() {
        _loadedPhotos = data.toList();
        Random random = Random();
        randomNumber = random.nextInt(data.length);
        loading = false;
      });
    } catch (e) {}
  }

  @override
  void initState() {
    // TODO: implement initState
    _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ?  spinkit
        : Stack(
            children: [
              Container(
                height: 550.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.black, Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  image: DecorationImage(
                    image: NetworkImage(
                      randomNumber == -1
                          ? 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1024px-No_image_available.svg.png'
                          : 'https://image.tmdb.org/t/p/original${_loadedPhotos[randomNumber]['poster_path']}',
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Container(
                height: 550.0,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black, Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Icon(
                          Icons.add,
                          color: Colors.grey,
                          size: 35.0,
                        ),
                        GestureDetector(
                          onTap: () => print('Play'),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.play_arrow,
                                    size: 45.0,
                                  ),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                      child: Text("Play",
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.bold)))
                                ],
                              )),
                        ),
                        const Icon(
                          Icons.info_outline,
                          color: Colors.grey,
                          size: 35.0,
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          );
  }
}
