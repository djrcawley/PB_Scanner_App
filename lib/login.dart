
// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'package:flutter/material.dart';

//for camera page
import 'package:camera/camera.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'screens.dart';



class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Column(
          //Center Verticall & Horizontally
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.only(top: 0),
                child: Container(
                    width: 200,
                    height: 150,
                    child: Image.asset('assets/images/pb-logo.png'))),
            Padding(
                padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      hintText: 'Enter email'),
                )),
            Padding(
                padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter password'),
                )),
            Padding(
                padding: EdgeInsets.only(top: 15),
                child: Container(
                  height: 50,
                  width: 200,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => FirstRoute()));
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}