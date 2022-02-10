// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:traffic_fines/Screens/qr_scanner.dart';
//import 'package:huawei_scan/HmsScanLibrary.dart';
import 'package:flutter_barcode_sdk/flutter_barcode_sdk.dart';
import 'camera_screen.dart';
import 'package:flutter_better_camera/camera.dart';
import 'package:flutter_barcode_sdk/dynamsoft_barcode.dart';

class IssueInfrindgementScreen extends StatefulWidget{
  const IssueInfrindgementScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return IssueInfrindgementScreenState();
  }
}

class IssueInfrindgementScreenState extends State<IssueInfrindgementScreen>{

  bool driverLicenceScanned = false;
  bool vehicleLicenseScanned = false;
  String province = "";
  String city = "";
  String surburb = "";
  String postalCode = "";
  //-------------------------------------------------------------
  List<CameraDescription> cameras = [];
  CameraController _controller;
  var firstCamera;
  var _barcodeReader;

  @override
  void initState() {
    super.initState();
    fetchCamera();
    _determinePosition().then((value){
      Position position = value;
      GetAddressFromLatLong(position);
      print(position == null ? 'Unknown' : position.latitude.toString() + ', ' + position.longitude.toString());
    });
  }

  Future fetchCamera() async{
    cameras = await availableCameras();
    setState(() {
      firstCamera = cameras[0];
    });
  }

  scan()async{
   /* DefaultViewRequest request = DefaultViewRequest(scanType: HmsScanTypes.AllScanType);
    ScanResponse response = await HmsScanUtils.startDefaultView(request);
    print("response>>>>>>>"+response.originalValue);*/
    _barcodeReader = FlutterBarcodeSdk();
    await _barcodeReader.init();
    _barcodeReader.setLicense('t0068NQAAAKown0KQlnBvbX8/1Miz9/Z8hLsBRdXdcmaatUg5uWfl8AQ/q3ej6WJzsgMFIAeGz99CDei2bw0OLj9CKR5MZXA=');
    await _barcodeReader.setBarcodeFormats(BarcodeFormat.ALL);
    CameraImage availableImage;
    int format = FlutterBarcodeSdk.IF_UNKNOWN;

    switch (availableImage.format.group) {
      case ImageFormatGroup.yuv420:
        format = FlutterBarcodeSdk.IF_YUV420;
        break;
      case ImageFormatGroup.bgra8888:
        format = FlutterBarcodeSdk.IF_BRGA8888;
        break;
      default:
        format = FlutterBarcodeSdk.IF_UNKNOWN;
    }

    List results = _barcodeReader.decodeImageBuffer(
        availableImage.planes[0].bytes,
        availableImage.width,
        availableImage.height,
        availableImage.planes[0].bytesPerRow,
        format);
  }

  Future<void> scanBarcodeNormal(int num) async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      //print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    print("<<"+barcodeScanRes+">>");
    setState(() {
      if(barcodeScanRes.toString() != '-1'){
        if(num == 0) {
          driverLicenceScanned = true;
        }else{
          vehicleLicenseScanned = true;
        }
      }
    });
  }


  // ignore: non_constant_identifier_names
  Future<void> GetAddressFromLatLong(Position position)async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    province = place.street;
    city = place.subAdministrativeArea;
    surburb = place.administrativeArea;
    postalCode = place.postalCode;
    print('${place.street}, ${place.subAdministrativeArea}, ${place.locality}, ${place.postalCode}, ${place.country}');

  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () { Navigator.pop(context); },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.message_outlined,
              color: Colors.black,
            ),
            onPressed: () { //Navigator.pop(context);
            },
          ),
        ],
        title: const Text("Issue Infrindgement",
          style: TextStyle(
              color: Colors.black
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            driverLicenceScanned ?
            Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
                  child: Text("Infrindger Particulars",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.height * 0.026
                    ),),
                ),
                ListView(
                  shrinkWrap: true,
                  controller: ScrollController(),
                  children: [
                    ListTile(
                      leading: Text("Surname"),
                      trailing: Text("--",
                        style: TextStyle(
                            color: Color.fromRGBO(88, 192, 228, 1),
                        ),),
                    ),
                    ListTile(
                      leading: Text("Name"),
                      trailing: Text("--",
                        style: TextStyle(
                          color: Color.fromRGBO(88, 192, 228, 1),
                        ),),
                    ),
                    ListTile(
                      leading: Text("ID Type"),
                      trailing: Text("--",
                        style: TextStyle(
                          color: Color.fromRGBO(88, 192, 228, 1),
                        ),),
                    ),
                    ListTile(
                      leading: Text("ID Number"),
                      trailing: Text("--",
                        style: TextStyle(
                          color: Color.fromRGBO(88, 192, 228, 1),
                        ),),
                    ),
                    ListTile(
                      leading: Text("Country of issue"),
                      trailing: Text("--",
                        style: TextStyle(
                          color: Color.fromRGBO(88, 192, 228, 1),
                        ),),
                    ),
                    ListTile(
                      leading: Text("License Code"),
                      trailing: Text("--",
                        style: TextStyle(
                          color: Color.fromRGBO(88, 192, 228, 1),
                        ),),
                    ),
                    ListTile(
                      leading: Text("Cell Number"),
                      trailing: Text("--",
                        style: TextStyle(
                          color: Color.fromRGBO(88, 192, 228, 1),
                        ),),
                    ),
                  ],
                ),
              ],
            ) :
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
              child: GestureDetector(
                onTap: (){
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => Mobile(camera: firstCamera,)));
                  //scanBarcodeNormal(0);
                  //scan();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.height * 0.05,
                  vertical: MediaQuery.of(context).size.height * 0.01),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.02),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(88, 192, 228, 1),
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: const Center(
                      child: Text("Scan Driver's License",
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            vehicleLicenseScanned ?
            Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(thickness: 1,),
                Padding(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
                  child: Text("Motor Vehicle Particulars",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.height * 0.026
                    ),),
                ),
                ListView(
                  shrinkWrap: true,
                  controller: ScrollController(),
                  children: [
                    ListTile(
                      leading: Text("Vehicle license number"),
                      trailing: Text("--",
                        style: TextStyle(
                          color: Color.fromRGBO(88, 192, 228, 1),
                        ),),
                    ),
                    ListTile(
                      leading: Text("License disk number"),
                      trailing: Text("--",
                        style: TextStyle(
                          color: Color.fromRGBO(88, 192, 228, 1),
                        ),),
                    ),
                    ListTile(
                      leading: Text("Vehicle GVM"),
                      trailing: Text("--",
                        style: TextStyle(
                          color: Color.fromRGBO(88, 192, 228, 1),
                        ),),
                    ),
                    ListTile(
                      leading: Text("Make"),
                      trailing: Text("--",
                        style: TextStyle(
                          color: Color.fromRGBO(88, 192, 228, 1),
                        ),),
                    ),
                    ListTile(
                      leading: Text("Model"),
                      trailing: Text("--",
                        style: TextStyle(
                          color: Color.fromRGBO(88, 192, 228, 1),
                        ),),
                    ),
                    ListTile(
                      leading: Text("Colour"),
                      trailing: Text("--",
                        style: TextStyle(
                          color: Color.fromRGBO(88, 192, 228, 1),
                        ),),
                    ),
                  ],
                ),
              ],
            ) : driverLicenceScanned ?
            GestureDetector(
              onTap: (){
                scanBarcodeNormal(1);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.height * 0.05,
                    vertical: MediaQuery.of(context).size.height * 0.01),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.02),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(88, 192, 228, 1),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: const Center(
                    child: Text("Scan Vehicle License",
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
            ) : Container(),
            SizedBox(height: 20,),
            Text(driverScanResult),
            SizedBox(height: 20,),
            Text(vehicleScanResult),
            SizedBox(height: 20,),
            (driverLicenceScanned || vehicleLicenseScanned) ?
            Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(thickness: 1,),
                Padding(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
                  child: Text("Location Date and Time of Infrindgement",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.height * 0.022
                    ),),
                ),
                ListView(
                  shrinkWrap: true,
                  controller: ScrollController(),
                  children: [
                    ListTile(
                      leading: Text("Provinse"),
                      trailing: Text(province??"",
                        style: TextStyle(
                          color: Color.fromRGBO(88, 192, 228, 1),
                        ),),
                    ),
                    ListTile(
                      leading: Text("City/Town"),
                      trailing: Text(city??"",
                        style: TextStyle(
                          color: Color.fromRGBO(88, 192, 228, 1),
                        ),),
                    ),
                    ListTile(
                      leading: Text("Surburb"),
                      trailing: Text(surburb??"",
                        style: TextStyle(
                          color: Color.fromRGBO(88, 192, 228, 1),
                        ),),
                    ),
                    ListTile(
                      leading: Text("Postal Code"),
                      trailing: Text(postalCode??"",
                        style: TextStyle(
                          color: Color.fromRGBO(88, 192, 228, 1),
                        ),),
                    ),
                  ],
                ),
              ],
            ) :
                Container(),
            (driverLicenceScanned && vehicleLicenseScanned) ?
            GestureDetector(
              onTap: (){
                //scanBarcodeNormal(1);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.height * 0.01,
                    vertical: MediaQuery.of(context).size.height * 0.01),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.02),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(88, 192, 228, 1),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: const Center(
                    child: Text("Submit",
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
            ) : Container()
          ],
        ),
      ),
    );
  }
}