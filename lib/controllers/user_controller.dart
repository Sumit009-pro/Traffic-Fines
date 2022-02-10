import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:mvc_pattern/mvc_pattern.dart';
//import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends ControllerMVC {
  Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();

  List childrenList = [];
  List categoriesList = [];
  List subscriptionsTypeList = [];

  Future<bool> login(body) async {
    print(body);
    bool returnValue = false;
    try {
      final prefs = await sharedPrefs;
      String? apiToken = prefs.getString("authToken");
      //final body = {"_id": prefs.getString("userID")};
      final url = Uri.parse(
          "https://demos.mydevfactory.com/debarati/trafficfines/public/api/login");
      print(prefs.getString("apiToken"));
      final result = await post(url, body: body);
      print((result.body));
      //final value = CategoryBase.fromMap(json.decode(result.body));
      if(result.body != null){
        if (jsonDecode(result.body)["status code"] == 200) {
          returnValue = true;
          prefs.setString("access_token", jsonDecode(result.body)["access_token"]);
          prefs.setString("name", jsonDecode(result.body)["data"]["name"]);
          //jsonDecode(result.body)["response"]["data"];
        }
      }
    } catch (e) {
      return returnValue;

    }
    return returnValue;
  }

  Future<String> uploadProfileImage(String filePath) async {
    String avatar = "";
    final prefs = await sharedPrefs;
    final token = prefs.getString("access_token");
    //request.fields.addAll(body);
    var request = http.MultipartRequest('POST', Uri.parse('https://demos.mydevfactory.com/debarati/trafficfines/public/api/edit_profile_picture'));
    request.files.add(await http.MultipartFile.fromPath('avatar', filePath));
    request.headers.addAll({'Authorization':  'Bearer ' + token!});
    http.StreamedResponse response = await request.send();
    String? resp = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      //resp = await response.stream.bytesToString();
      print(resp);
      if(jsonDecode(resp)["status code"] == 200){
        avatar = jsonDecode(resp)["data"]['avatar'];
      }
    }
    else {
      print(response.reasonPhrase);
    }
    return avatar;
  }

  Future<List> getChildren(body) async {
    try {
      final prefs = await sharedPrefs;
      String? apiToken = prefs.getString("authToken");
      //final body = {"_id": prefs.getString("userID")};
      final url = Uri.parse(
          "https://nodeserver.mydevfactory.com:1971/api/getallchildren");
      print(prefs.getString("apiToken"));
      final result = await post(url, body: body, headers: {
        'authToken': apiToken!,
        //'Content-Type': 'Application/Json'
      });
      print(jsonDecode(result.body));
      //final value = CategoryBase.fromMap(json.decode(result.body));
      if (jsonDecode(result.body)["STATUSCODE"] == 200)
        childrenList = jsonDecode(result.body)["response"]["data"];
    } catch (e) {
      rethrow;
    }
    return childrenList;
  }

  Future<List> getSubscriptionType(body) async {
    try {
      final prefs = await sharedPrefs;
      String? apiToken = prefs.getString("authToken");
      //final body = {"_id": prefs.getString("userID")};
      final url = Uri.parse(
          "https://nodeserver.mydevfactory.com:1971/api/getallsubscriptiontypes");
      print(prefs.getString("apiToken"));
      final result = await post(url, body: body, headers: {
        'authToken': apiToken!,
        //'Content-Type': 'Application/Json'
      });
      print("getallsubscriptiontypes>>>"+jsonDecode(result.body).toString());
      //final value = CategoryBase.fromMap(json.decode(result.body));
      if (jsonDecode(result.body)["STATUSCODE"] == 200)
        subscriptionsTypeList = jsonDecode(result.body)["response"]["data"];
    } catch (e) {
      rethrow;
    }
    return subscriptionsTypeList;
  }
}

