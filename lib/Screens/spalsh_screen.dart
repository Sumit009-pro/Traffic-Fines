// @dart=2.9
import 'dart:async';
import 'package:flutter/material.dart';
import './onboarding.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 5),
            () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => Onboarding())));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Stack(fit: StackFit.expand,
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Image.asset('assets/spalsh_image.png',
              height: MediaQuery.of(context).size.height * 0.705,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset('assets/Vector.png',
              height: MediaQuery.of(context).size.height * 0.53,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset('assets/Frame.png',
              height: MediaQuery.of(context).size.height * 0.92,
              width: double.infinity,
              //fit: BoxFit.fill,
            ),
          ),
          Column(mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset('assets/TRAFFIC INFRINDGEMENT.png',
                //height: MediaQuery.of(context).size.height * 0.6,
                width: double.infinity,
                //fit: BoxFit.fill,
              ),
              Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),),
              const CircularProgressIndicator(),
              Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),),
              const Text("POWERED BY", style: TextStyle(color: Color.fromRGBO(88, 192, 228, 1)),),
              Image.asset('assets/CALMAX.png',
                //height: MediaQuery.of(context).size.height * 0.6,
                width: double.infinity,
                //fit: BoxFit.fill,
              ),
            ],
          ),
        ],
      ),
    );
  }
}