// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:netflix_clone/screen/Authentication/signup.dart';
import 'package:netflix_clone/screen/home_screen.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = '';
  String password = "";
  String Error = '';
  String userId = '';
  final _auth = FirebaseAuth.instance;
  

 

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
                      'NETFLIX',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$Error',
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
                      onChanged: (value) => email = value,
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
                      onChanged: (value) => password = value,
                      cursorColor: Colors.white,
                      style: const TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(95, 254, 250, 250)),
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
                              .signInWithEmailAndPassword(
                                  email: email, password: password)
                              .then((value) {
                            if (value.uid.isNotEmpty) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const HomeScreen()));
                            } else {
                              return;
                            }
                          });
                        } on PlatformException catch (e) {
                          setState(() {
                            Error = e.message!;
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
                                  child: Text("Login",
                                      style: TextStyle(
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold)))
                            ],
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SignUp())),
                      child: Container(
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 71, 68, 68),
                              border: Border.all(
                                  color: Color.fromARGB(255, 71, 68, 68)),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Text("Signup",
                                      style: TextStyle(
                                          color: Colors.white,
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
