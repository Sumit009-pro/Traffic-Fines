// @dart=2.9
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traffic_fines/Screens/login_screen.dart';

import 'home_screen.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key key}) : super(key: key);

  @override
  OnboardingState createState() => OnboardingState();
}

class OnboardingState extends State<Onboarding> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //bool _seen = (prefs.getBool('seen') ?? false);
    String status = prefs.getString("loginStatus");

    if (status == "loggedIn") {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else {
      //prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 200), () {
      checkFirstSeen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}