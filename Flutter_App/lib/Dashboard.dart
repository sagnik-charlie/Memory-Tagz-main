import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memory_tagz/services/CheckConnection.dart';
import 'package:memory_tagz/services/storageService.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:memory_tagz/MainPage.dart';
import 'package:memory_tagz/models/MemoryTag.dart';
import 'package:memory_tagz/components/DashboardScreen.dart';
import 'package:memory_tagz/services/notificationservice.dart';
import 'package:tflite/tflite.dart';

import 'components/Notify_button.dart';

class Dashboard extends StatefulWidget {
  final BluetoothConnection connection;
  //final BluetoothDevice server;
  const Dashboard({required this.connection});

  @override
  _Dashboard createState() => new _Dashboard();
}


class _Dashboard extends State<Dashboard> {
  
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

 
  final ScrollController listScrollController = new ScrollController();

  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // bool isConnecting = true;
  // bool isReceiving = false;

  // bool get isConnected => ((connection?.isConnected) ?? false);
  // bool isDisconnecting = false;
  //late File _image;
  //BluetoothConnection? connection;
  List? _results;
  bool imageSelect = false;
  List<MemoryTag> memory_tags = List<MemoryTag>.empty(growable: true);
  bool tagStored = false;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();

    // ignore: close_sinks

    // connection =
    //     await Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
    //   return CheckConnection(server: widget.server);
    // })));
    // BluetoothConnection.toAddress(widget.server.address).then((_connection) {
    //   print('Connected to the device');
    //   print(_connection.isConnected);
    //   print(widget.server.isConnected);
    //   setState(() {
    //     connection = _connection;
    //     isConnecting = false;
    //     isDisconnecting = false;
    //     isReceiving = true;
    //   });

    widget.connection.input?.listen((Uint8List data) async {
      String? rec = ascii.decode(data).toString();
      if (widget.connection.isConnected && rec != null) {
        await NotificationService()
            .showNotification(1, "Memory App", "You removed a Tag!", 5);
        openpop(rec);
      }
    }).onDone(() {
      if (widget.connection.isConnected) {
        print('Disconnecting locally!');
      } else {
        print('Disconnected remotely!');
      }
      if (this.mounted) {
        setState(() {});
      }
    });
    // }).catchError((error) {
    //   print('Cannot connect, exception occured');
    //   print(error);
    // });
  }

  // @override
  // void dispose() {
  //   // Avoid memory leak (`setState` after dispose) and disconnect
  //   if (isConnected) {
  //     isDisconnecting = true;
  //     connection?.dispose();
  //     connection = null;
  //   }
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // final serverName = widget.server.name ?? "Unknown";
    return Scaffold(
        appBar: AppBar(
            title: (widget.connection.isConnected
                ? Text('Your Memory Tags')
                : Text('Connecting... ')),
            backgroundColor: Color.fromARGB(137, 37, 37, 37)),
        key: _drawerKey,
        drawer: GetDrawer(),
        backgroundColor: Color.fromARGB(255, 228, 206, 185),
        body: (memory_tags.length != 0)
            ? DashboardScreen(key: _drawerKey, lst: memory_tags)
            : Container(
                child: const Align(
                alignment: Alignment.bottomRight,
                child: NotifyButton(),
              )));
  }

  void openpop(String str) async {
    showDialog(
        context: context,
        barrierColor: Colors.black45,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: new Text("You are on Track"),
            content: new Text("You removed memory tag " + str),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                  child: new Text("Take a Snap"),
                  onPressed: () async {
                    try {
                      await pickedImage(str);
                    } catch (e) {
                      print(e);
                    }
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  Future loadModel() async {
    String res;
    res = (await Tflite.loadModel(
        model: "assets/final_model_converted.tflite",
        labels: "assets/labelmap.txt"))!;
    print("Models loading status: $res");
  }

  Future pickedImage(String id) async {
    //  performAccept();
    final ImagePicker _picker = ImagePicker();
    XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    File image = File(photo!.path);
    String name = photo.name;
    await imageClassification(image, id, name);
  }

  Future imageClassification(File image, String id, String name) async {
    await loadModel();
    final List? recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _results = recognitions!;
      //_results.map((recog) {});
      //_image = image;
      imageSelect = true;
    });
    Tflite.close();
    //storeTag(_results, _image);
    //Navigator.of(context).pop(label);
    await storeTag(_results!, image, id, name);
  }

  String? getDesc(String name) {
    if (name == "Calculator") {
      return "is on study table";
    } else if (name == "Wrist Watch") {
      return "is beside your wallet";
    } else if (name == "Umbrella") {
      return "is under your dining table";
    } else if (name == "Scissors") {
      return "is in drawer of cabinet";
    } else if (name == "Tomato") {
      return "is inside your fridge";
    } else if (name == "Coffee Cup") {
      return "is inside a yellow shelf";
    } else {
      return null;
    }
  }

  Future storeTag(List results, File _image, String id, String name) async {
    final storageService storage = new storageService();
    String title = "";
    String imageUrl;
    results.forEach((element) {
      if (element['confidence'].toDouble() > 0.7) {
        setState(() {
          title = element['label'].toString();
        });
      }
    });
    var _getDesc = getDesc(title);
    String desc = _getDesc.toString();
    _auth.signInAnonymously();
    if (title != "") {
      storage.uploadFile(_image, name).then((value) async => {
            imageUrl = await storage.getUrl(name),
            print(imageUrl),
            _fireStore.collection('MemoryCards').add({
              'id': id,
              'title': title,
              'description': desc,
              'image': imageUrl,
            }),
          });

      try {
        MemoryTag mem = MemoryTag(
            id: id,
            title: title,
            description: title + " " + desc,
            image: _image);
        memory_tags.add(mem);
        tagStored = true;
      } catch (e) {
        print(e);
      }
    }
  }
}
