// @dart=2.9
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:traffic_fines/controllers/user_controller.dart';
import './onboarding.dart';
import 'home_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();
  bool flag = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool hidePassword = true;
  @override
  void initState() {
    super.initState();
    /*Timer(
        const Duration(seconds: 5),
            () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => Splash())));*/
  }

  Future<bool> _validate() async {
    return _formKey.currentState.validate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Stack(fit: StackFit.expand,
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Image.asset('assets/splash_img2.png',
              height: MediaQuery.of(context).size.height * 0.435,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset('assets/Union.png',
              height: MediaQuery.of(context).size.height * 0.75,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset('assets/TRAFFIC INFRINDGEMENT WHITE.png',
                      //height: MediaQuery.of(context).size.height * 0.75,
                      width: double.infinity,
                      //fit: BoxFit.fill,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),),
                  Text("Welcome Officer",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: MediaQuery.of(context).size.height * 0.026
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),),
                  TextFormField(
                    controller: emailController,
                    validator: (value){
                      if(value.isEmpty){
                        return "Please enter username!";
                      }
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: const TextStyle(
                        color: Colors.white
                    ),
                    decoration: const InputDecoration(
                        labelText: "Enter Username",
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)
                        )
                    ),
                  ),
                  TextFormField(
                    controller: passwordController,
                    validator: (value){
                      if(value.isEmpty){
                        return "Please enter password!";
                      }
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: const TextStyle(
                      color: Colors.white
                    ),
                    obscureText: hidePassword,
                    decoration: InputDecoration(
                      labelText: "Enter Password",
                      labelStyle: const TextStyle(color: Colors.white),
                      suffixIcon: IconButton(
                        onPressed: (){
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                        icon: Icon(
                            hidePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility,
                            color: Colors.white
                        ),
                      ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)
                    )
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),),
                  GestureDetector(
                    onTap: (){
                      FocusScope.of(context).requestFocus(FocusNode());
                      _validate().then((value) async{
                        if(value){
                          setState(() {
                            flag = false;
                          });
                          final prefs = await sharedPrefs;
                          final body = {
                            "email": emailController.text,
                            "password": passwordController.text,
                            "device_token": "1234",
                            "device_type": "ANDROID"
                          };
                          print(prefs.get("_id"));
                          await UserController().login(body).then((value){
                            setState(() {
                              flag = true;
                            });
                            if(value){
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) => const HomeScreen()));
                            }else{
                              Fluttertoast.showToast(msg: "Incorrect Username/Password!");
                            }
                          });
                        }
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.02),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: const Center(
                        child: Text("Login",
                          style: TextStyle(
                            color: Color.fromRGBO(88, 192, 228, 1)
                          ),
                        )
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          flag ? Container() : Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white38,
            child: Center(
              child: CircularProgressIndicator(

              ),
            ),
          )
        ],
      ),
    );
  }

  void login() async {

  }
}