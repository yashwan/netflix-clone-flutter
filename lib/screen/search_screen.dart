import 'dart:async';
import 'dart:ffi';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:netflix_clone/screen/single_page_screen/single_page_screen.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List movies = [];
  String input = '';
  static const spinkit = SpinKitRotatingCircle(
    color: Colors.white,
    size: 50.0,
  );
  var loading = true;
  var noData = false;
  Future searchResponse() async {
    try {
      if (input == "") {
      } else {
        var response = await Dio().get(
            "http://api.themoviedb.org/3/search/movie?api_key=360a9b5e0dea438bac3f653b0e73af47&language=en-US&page=1&include_adult=false&query=$input");
        var data = response.data;
        loading = true;
        return data['results'];
      }
    } catch (e) {
      setState(() {
         noData = true;
      });
     
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchResponse();
  }

  @override
  Widget build(BuildContext context) {
   
    return SafeArea(
        child: Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Color.fromARGB(255, 60, 60, 60),
            pinned: true,
            expandedHeight: 60,
            collapsedHeight: 60,
            flexibleSpace: Container(
                margin: EdgeInsets.fromLTRB(50, 5, 0, 0),
                child: Column(children: [
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        input = value;
                        try {
                          searchResponse().then((va) => {
                                if (va == null)
                                  {}
                                else
                                  {
                                    if (mounted)
                                      {
                                        setState(() {
                                          movies = va;
                                          loading = true;
                                        })
                                      }
                                  }
                              });
                        } catch (e) {}
                      });
                    },
                    cursorColor: Colors.red,
                    style: const TextStyle(fontSize: 20, color: Colors.white38),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter Movie',
                      fillColor: Color.fromARGB(255, 60, 60, 60),
                      filled: true,
                    ),
                  ),
                ])),
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
                                      id: movies[index]['id']))),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Image.network(
                                movies[index]['poster_path'] == null
                                    ? 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1024px-No_image_available.svg.png'
                                    : (movies[index]['poster_path'][0] == '/'
                                        ? 'https://image.tmdb.org/t/p/original${movies[index]['poster_path']}'
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
