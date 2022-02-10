// @dart=2.9
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:traffic_fines/Screens/issue_infrindgement.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:traffic_fines/controllers/user_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
//------------------------------------------------------------------
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_better_camera/camera.dart';

import 'camera_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

var imageFilePath;
List<CameraDescription> cameras = [];
var _image;
class _HomeScreenState extends State<HomeScreen> {
  Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();
  bool hidePassword = true;
  final picker = ImagePicker();
  var firstCamera;
  String profileImg = "";
  String name = "";
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  bool displayImageOptions = false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
    getImage();
    /*Timer(
        const Duration(seconds: 5),
            () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => Splash())));*/
  }

  Future fetchCamera() async{
    cameras = await availableCameras();
    setState(() {
      firstCamera = cameras[1];
    });
  }

  Future initializeCamera()async{
    await fetchCamera();
    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  Future openGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        UserController().uploadProfileImage(pickedFile.path).then((value){
          saveImage(value);
        });
      } else {
        print('No image selected.');
      }
    });
  }

  saveImage(image) async{
    final prefs = await sharedPrefs;
    prefs.setString("profileImage", image);
  }

  getImage() async{
    final prefs = await sharedPrefs;
    setState(() {
      if(prefs.getString("profileImage") != null) {
        //profileImg = prefs.getString("profileImage")!;
        name = prefs.getString("name");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Image.asset('assets/Union_Home.png',
                  height: MediaQuery.of(context).size.height * 0.435,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: (){},
                            icon: const Icon(Icons.menu),
                            color: Colors.white,
                          ),
                          IconButton(
                            onPressed: (){},
                            icon: const Icon(Icons.notifications_rounded),
                            color: Colors.white,
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height / 80),
                        child: _image != null ?
                        Center(
                          child: GestureDetector(
                            onTap: (){
                              setState(() {
                                displayImageOptions = !displayImageOptions;
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: FileImage(_image)),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            MediaQuery.of(context).size.height * 0.1))),
                                height: MediaQuery.of(context).size.height / 6,
                                width: MediaQuery.of(context).size.width / 3,
                                margin: EdgeInsets.only(
                                    right: MediaQuery.of(context).size.width / 32)),
                          )
                        ) :
                        Center(
                          child: profileImg == "" ?
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                displayImageOptions = !displayImageOptions;
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    image: const DecorationImage(
                                        fit: BoxFit.fill,
                                        image: AssetImage("assets/issue_inf.png")),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            MediaQuery.of(context).size.height * 0.1))),
                                height: MediaQuery.of(context).size.height / 6,
                                width: MediaQuery.of(context).size.width / 3,
                                margin: EdgeInsets.only(
                                    right: MediaQuery.of(context).size.width / 32)),
                          ) :
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                displayImageOptions = !displayImageOptions;
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            MediaQuery.of(context).size.height * 0.1))),
                                height: MediaQuery.of(context).size.height / 6,
                                width: MediaQuery.of(context).size.width / 3,
                                margin: EdgeInsets.only(
                                    right: MediaQuery.of(context).size.width / 32),
                              child: CachedNetworkImage(
                                imageUrl: profileImg,
                                progressIndicatorBuilder: (context, url, downloadProgress) =>
                                    CircularProgressIndicator(value: downloadProgress.progress),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                      ),
                      !displayImageOptions ? Container() : Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.15,
                              right: MediaQuery.of(context).size.width * 0.015,),
                              child: GestureDetector(
                                onTap: () async{
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) =>
                                          CameraWidget())).then((value){
                                    setState(() {
                                      if(imageFilePath != "" || imageFilePath != null){
                                        //_image = imageFilePath;
                                        _image = File(imageFilePath);
                                        UserController().uploadProfileImage(imageFilePath).then((value){
                                          saveImage(value);
                                        });
                                        imageFilePath = "";
                                      }
                                    });
                                    //print(xml.parse(img));
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.01),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: const Center(
                                    child: Text("Take Photo",
                                      style: TextStyle(
                                          color: Color.fromRGBO(88, 192, 228, 1),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.015,
                                  right: MediaQuery.of(context).size.width * 0.15),
                              child: GestureDetector(
                                onTap: () async{
                                  openGallery();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.01),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color:  Colors.white,
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: const Center(
                                    child: Text("Open Gallery",
                                      style: TextStyle(
                                          color: Color.fromRGBO(88, 192, 228, 1),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),),
                      Text(name,
                        style: TextStyle(
                            color: Colors.white,
                          fontSize: MediaQuery.of(context).size.height * 0.026
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),),
                      const Text("Officer",
                        style: TextStyle(
                            color: Colors.white
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GridView(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => IssueInfrindgementScreen()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Card(shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.white70, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height * 0.1,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                ),
                                child: Image.asset('assets/issue_inf.png',
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Column(mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
                                    child: const Center(
                                      child: Text("Issue Ingrindgement",
                                        style: TextStyle(
                                            color: Color.fromRGBO(88, 192, 228, 1)
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Center(
                              child: Container(
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromRGBO(88, 192, 228, 1)
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.015),
                                  child: Icon(Icons.sticky_note_2,
                                    color: Colors.white,
                                    size: MediaQuery.of(context).size.height * 0.045,
                                  ),
                                ),
                              )
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.white70, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.1,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                              ),
                              child: Image.asset('assets/reports.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                            Column(mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
                                  child: const Center(
                                    child: Text("Reports",
                                      style: TextStyle(
                                          color: Color.fromRGBO(88, 192, 228, 1)
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Center(
                            child: Container(
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromRGBO(88, 192, 228, 1)
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.015),
                                child: Icon(Icons.bar_chart,
                                  color: Colors.white,
                                  size: MediaQuery.of(context).size.height * 0.045,
                                ),
                              ),
                            )
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.white70, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.1,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                              ),
                              child: Image.asset('assets/imp_notice.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                            Column(mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
                                  child: const Center(
                                    child: Text("Important Notice",
                                      style: TextStyle(
                                          color: Color.fromRGBO(88, 192, 228, 1)
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Center(
                            child: Container(
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromRGBO(88, 192, 228, 1)
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.015),
                                child: Icon(Icons.announcement,
                                  color: Colors.white,
                                  size: MediaQuery.of(context).size.height * 0.045,
                                ),
                              ),
                            )
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.white70, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.1,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                              ),
                              child: Image.asset('assets/schedule.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                            Column(mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
                                  child: const Center(
                                    child: Text("Schedule",
                                      style: TextStyle(
                                          color: Color.fromRGBO(88, 192, 228, 1)
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Center(
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromRGBO(88, 192, 228, 1)
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.015),
                              child: Icon(Icons.date_range,
                                color: Colors.white,
                                size: MediaQuery.of(context).size.height * 0.045,
                              ),
                            ),
                          )
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//--------------------------------------------------Camera-------------------------------------------------
// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs
