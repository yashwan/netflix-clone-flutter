import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:netflix_clone/screen/splash.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black.withOpacity(0.7),
        child: SafeArea(
          child: Row(
            children: [
              Image.asset('assets/image/logo.png'),
              const SizedBox(
                width: 12.0,
              ),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _AppBarButton(
                      title: 'TV Show', onTap: () => print("TV Show")),
                  _AppBarButton(title: 'Movies', onTap: () => print("Movies")),
                  _AppBarButton(
                      title: 'Sign out',
                      onTap: () => _auth.signOut().whenComplete(() =>
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(builder: (context) {
                            return const SplashScreen();
                          }), (route) => false))),
                ],
              ))
            ],
          ),
        ));
  }
}

class _AppBarButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _AppBarButton({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w700),
      ),
    );
  }
}
