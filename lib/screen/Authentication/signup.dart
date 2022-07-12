import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:netflix_clone/screen/Authentication/login.dart';

class SignUp extends StatefulWidget {
  SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  String error = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Color.fromARGB(255, 0, 0, 0),
            body: SingleChildScrollView(
              padding: EdgeInsets.only(top: 50),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sign up',
                      style: TextStyle(
                        color: Color.fromARGB(255, 243, 225, 224),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                     Text(
                      '$error',
                      style: TextStyle(
                        color: Color.fromARGB(255, 238, 120, 120),
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      onChanged: (value) {
                        email = value;
                      },
                      cursorColor: Colors.white,
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                      decoration: InputDecoration(
                          fillColor: Color.fromARGB(255, 60, 60, 60),
                          filled: true,
                          border: OutlineInputBorder(),
                          hintText: 'Please Enter Email',
                          labelText: "Email"),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      onChanged: (value) {
                        password = value;
                      },
                      cursorColor: Colors.white,
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                      obscureText: true,
                      decoration: InputDecoration(
                          fillColor: Color.fromARGB(255, 60, 60, 60),
                          filled: true,
                          border: OutlineInputBorder(),
                          hintText: 'Please Enter Password',
                          labelText: "Password"),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        try {
                          await _auth
                              .createUserWithEmailAndPassword(
                                  email: email, password: password)
                              .then((FirebaseUser user) => print(user))
                              .then((value) => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login())));
                        } on PlatformException catch (e) {
                          setState(() {
                            error = e.message!;
                          });
                        } on Exception catch (e) {
                          print(e);
                        }
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Text("Sign up",
                                      style: TextStyle(
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold)))
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            )));
  }
}
