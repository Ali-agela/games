import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movies/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 3,), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeScreen() ));
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Scaffold(
      body: Center(child: Image.asset(
        "assets/gamefy_icon.png",
        width: size.width*0.66
      ),
    ));
  }
}