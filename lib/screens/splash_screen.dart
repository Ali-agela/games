import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:movies/controllers/dark_mode_controller.dart';
import 'package:movies/providers/dark_mode_provider.dart';
import 'package:movies/screens/home_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final DarkModeController darkModeController = Get.put(DarkModeController());

  @override
  void initState() {
    Timer(
        const Duration(
          seconds: 3,
        ), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetX<DarkModeController>(builder: (context) {
      return Scaffold(
          backgroundColor:
              darkModeController.isDark.value ? Colors.black : Colors.white,
          body: Center(
            child:
                Image.asset("assets/gamefy_icon.png", width: size.width * 0.66),
          ));
    });
  }
}
