import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:lottie/lottie.dart';

import "package:memory_tagz/models/LoginPage.dart";
import 'package:memory_tagz/Dashboard.dart';
import 'package:memory_tagz/quiz_button/screens/welcome/welcome_screen.dart';
import 'package:neon/neon.dart';

import './DiscoveryPage.dart';
import './SelectBondedDevicePage.dart';
import 'components/Notify_button.dart';
import 'services/CheckConnection.dart';

class MainPage extends StatefulWidget {
  BluetoothConnection? connection;
  BluetoothDevice? selectedDevice;
  @override
  _MainPage createState() => new _MainPage(connection: this.connection);
}

class _MainPage extends State<MainPage> {
  final BluetoothConnection? connection;
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  _MainPage({required this.connection});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: NotifyButton(),
      drawer: GetDrawer(),
      appBar: AppBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(14))),
          title: widget.connection != null
              ? Text('Your Memory Tags')
              : Text('Welcome'),
          backgroundColor: Color.fromARGB(137, 37, 37, 37)),
      backgroundColor: Color.fromARGB(255, 228, 206, 185),
      body: (widget.connection != null)
          ? widget.connection!.isConnected
              ? Dashboard(connection: widget.connection!)
              : Container(
                  child: const Align(
                  alignment: Alignment.bottomRight,
                  child: NotifyButton(),
                ))
          : Container(
              alignment: Alignment.center,
              child: Column(
                //  mainAxisAlignment: MainAxisAlignment.center,
                //  crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    width: 300,
                    height: 300,
                    child: Lottie.asset('assets/memory2.json',
                        width: 300, height: 300, fit: BoxFit.fitWidth),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      alignment: Alignment.center,
                      width: 300,
                      height: 100,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (_bluetoothState.isEnabled == false) {
                              await FlutterBluetoothSerial.instance
                                  .requestEnable();
                            } 
                            widget.selectedDevice =
                                await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return DiscoveryPage();
                                },
                              ),
                            );
                          },
                          style: ButtonStyle(
                            alignment: Alignment.center,
                            //minimumSize: MaterialStateProperty.all(const Size(300, 390)),
                            // maximumSize: MaterialStateProperty.all(const Size(464, 336)),

                            fixedSize:
                                MaterialStateProperty.all(const Size(200, 60)),

                            backgroundColor: MaterialStateProperty.all(
                                Colors.amber.shade700),
                          ),
                          child: Neon(
                            text: 'Pair',
                            color: Colors.red,
                            fontSize: 30,
                            font: NeonFont.Beon,
                            glowing: false,
                            flickeringText: false,
                            //flickeringLetters: [0,1],
                          ))),
                  SizedBox(
                    height: 19,
                  ),
                  Container(
                      alignment: Alignment.center,
                      width: 300,
                      height: 100,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (_bluetoothState.isEnabled == false) {
                              await FlutterBluetoothSerial.instance
                                  .requestEnable();
                            }
                            widget.selectedDevice =
                                await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return SelectBondedDevicePage(
                                      checkAvailability: false);
                                },
                              ),
                            );

                            if (widget.selectedDevice != null) {
                              print('Connect -> selected ' +
                                  widget.selectedDevice!.address);
                              widget.connection = await Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return CheckConnection(
                                    server: widget.selectedDevice!);
                              }));
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return Dashboard(
                                    connection: widget.connection!);
                              }));
                            }
                            // goToDashboard(context, widget.selectedDevice!);
                            else {
                              print('Connect -> no device selected');
                            }
                          },
                          style: ButtonStyle(
                            alignment: Alignment.center,
                            //minimumSize: MaterialStateProperty.all(const Size(300, 390)),
                            // maximumSize: MaterialStateProperty.all(const Size(464, 336)),

                            fixedSize:
                                MaterialStateProperty.all(const Size(200, 60)),

                            backgroundColor: MaterialStateProperty.all(
                                Colors.amber.shade700),
                          ),
                          child: Neon(
                            text: 'Connect',
                            color: Colors.red,
                            fontSize: 30,
                            font: NeonFont.Beon,
                            glowing: false,
                            flickeringText: false,
                            //flickeringLetters: [0,1],
                          ))),
                ],
              ),
            ),
    );
  }
}

class GetDrawer extends StatefulWidget {
  BluetoothDevice? selectedDevice;
  BluetoothConnection? connection;

  @override
  _GetDrawer createState() => new _GetDrawer();
}

class _GetDrawer extends State<GetDrawer> {
  String _address = "...";
  String _name = "...";
  BluetoothConnection? connection;
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  Timer? _discoverableTimeoutTimer;
  int _discoverableTimeoutSecondsLeft = 0;

  //BackgroundCollectingTask? _collectingTask;

  bool _autoAcceptPairingRequests = false;

  @override
  void initState() {
    super.initState();

    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    Future.doWhile(() async {
      // Wait if adapter not enabled
      if ((await FlutterBluetoothSerial.instance.isEnabled) ?? false) {
        return false;
      }
      await Future.delayed(Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      // Update the address field
      FlutterBluetoothSerial.instance.address.then((address) {
        setState(() {
          _address = address!;
        });
      });
    });

    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() {
        _name = name!;
      });
    });

    // Listen for futher state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;

        // Discoverable mode is disabled when Bluetooth gets disabled
        _discoverableTimeoutTimer = null;
        _discoverableTimeoutSecondsLeft = 0;
      });
    });
  }

  // @override
  // void dispose() {
  //   FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
  //   // _collectingTask?.dispose();
  //   _discoverableTimeoutTimer?.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
            color: Color.fromARGB(31, 245, 212, 24),
            child: ListView(children: <Widget>[
              Divider(),
              ListTile(title: const Text('Memory Panel')),
              ListTile(
                  title: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.black38),
                      child: const Text('Login/SignUp'),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return LoginPage();
                            },
                          ),
                        );
                      })),
              Divider(),
              SwitchListTile(
                activeColor: Colors.black38,
                title: const Text('Enable Bluetooth'),
                value: _bluetoothState.isEnabled,
                onChanged: (bool value) {
                  // Do the request and update with the true value then
                  future() async {
                    // async lambda seems to not working
                    if (value)
                      await FlutterBluetoothSerial.instance.requestEnable();
                    else
                      await FlutterBluetoothSerial.instance.requestDisable();
                  }

                  future().then((_) {
                    setState(() {
                      value = _bluetoothState.isEnabled;
                    });
                  });
                },
              ),
              ListTile(
                title: const Text('Bluetooth status'),
                subtitle: Text(_bluetoothState.toString()),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.black38),
                  child: const Text('Settings'),
                  onPressed: () {
                    FlutterBluetoothSerial.instance.openSettings();
                  },
                ),
              ),
              ListTile(
                title: const Text('Local adapter address'),
                subtitle: Text(_address),
              ),
              ListTile(
                title: const Text('Local adapter name'),
                subtitle: Text(_name),
                onLongPress: null,
              ),
              Divider(),
              ListTile(title: const Text('Devices discovery and connection')),
              ListTile(
                title: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.black38),
                    child: const Text('Explore nearby devices'),
                    onPressed: () async {
                      if (_bluetoothState.isEnabled == false) {
                        await FlutterBluetoothSerial.instance.requestEnable();
                      }
                      widget.selectedDevice = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return DiscoveryPage();
                          },
                        ),
                      );

                      if (widget.selectedDevice != null) {
                        print('Discovery -> selected ' +
                            widget.selectedDevice!.address);
                      } else {
                        print('Discovery -> no device selected');
                      }
                    }),
              ),
              ListTile(
                title: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.black38),
                    child: const Text('Connect to Memory Book'),
                    onPressed: () async {
                      if (_bluetoothState.isEnabled == false) {
                        await FlutterBluetoothSerial.instance.requestEnable();
                      }
                      widget.selectedDevice = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return SelectBondedDevicePage(
                                checkAvailability: false);
                          },
                        ),
                      );

                      if (widget.selectedDevice != null) {
                        print('Connect -> selected ' +
                            widget.selectedDevice!.address);
                        connection = await Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return CheckConnection(
                              server: widget.selectedDevice!);
                        }));
                        gotoDashboard(context, widget.connection!);
                      }
                      // goToDashboard(context, widget.selectedDevice!);
                      else {
                        print('Connect -> no device selected');
                      }
                    }),
              ),
              Divider(),
              ListTile(
                  title: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.black38),
                      child: const Text('Play a Quiz'),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return WelcomeScreen();
                            },
                          ),
                        );
                      }))
            ])));
  }

  void gotoDashboard(BuildContext context, BluetoothConnection connection) {
    if (connection.isConnected) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return Dashboard(connection: connection);
      }));
    }
  }

  // void goToDashboard(BuildContext context, BluetoothDevice server) {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (context) {
  //         return Dashboard(server: server);
  //       },
  //     ),
  //   );
  // }
}
