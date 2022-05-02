import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:memory_tagz/Dashboard.dart';

class CheckConnection extends StatefulWidget {
  final BluetoothDevice server;
  const CheckConnection({required this.server});

  @override
  _CheckConnection createState() => new _CheckConnection();
}

class _CheckConnection extends State<CheckConnection> {
  BluetoothConnection? conn;
  bool isConnecting = true;
  bool isDisconnecting = true;
  bool get isConnected => ((conn?.isConnected) ?? false);
  bool isReceiving = false;

  void initState() {
    super.initState();
    // tz.initializeTimeZones();

    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      print(_connection.isConnected);
      print(widget.server.isConnected);
      setState(() {
        conn = _connection;
        isConnecting = false;
        isDisconnecting = false;
        isReceiving = true;
      });
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return Dashboard(connection: conn!);
      }));
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  // @override
  // Widget? build(BuildContext context) {
  // final serverName = widget.server.name ?? "Unknown";
  // return Scaffold(
  //     appBar: AppBar(
  //         title:
  //             (conn!.isConnected ? Text('Your Memory Tags') : Text('Error'))),
  //     // key: _drawerKey,
  //     drawer: GetDrawer(),
  //     backgroundColor: Color.fromARGB(255, 228, 206, 185),
  //      return
  //         goToDashboard(context, conn!);

  // }

  // void goToDashboard(BuildContext context, BluetoothConnection conn) {
  //   Navigator.of(context).push(MaterialPageRoute(builder: (context) {
  //     return Dashboard(connection: conn);
  //   }));
  // }

  // void popConnection(BuildContext context) async {
  //   Navigator.of(context).pop(conn!);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: LoadingAnimationWidget.twistingDots(
            leftDotColor: Color.fromARGB(255, 83, 83, 104),
            rightDotColor: Color.fromARGB(255, 216, 84, 157),
            size: 200,
          ),
        ),
        Center(
            child: Text('Connecting to Memory Book',
                style: TextStyle(color: Colors.black54, fontSize: 20)))
      ],
    )));
  }
}
