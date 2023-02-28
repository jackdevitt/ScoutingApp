// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scouting App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Scouting App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

// ignore: unused_element
Future<File> get _localFile async {
  final path = await _localPath;
  return File("$path/info.json");
}

Future<File> writeData(String data) async {
  final file = await _localFile;
  return file.writeAsString(data);
}

Future<String> readFile() async {
  try {
    final file = await _localFile;
    final contents = await file.readAsString();
    return contents;
  } catch (e) {
    return "an Error occured";
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int teleopTopScore = 0;
  int teleopMiddleScore = 0;
  int teleopBottomScore = 0;
  int autoTopScore = 0;
  int autoMiddleScore = 0;
  int autoBottomScore = 0;
  bool movedInAuto = false;
  bool dockedInAuto = false;
  bool dockedInEndgame = false;
  bool scoredBoth = false;
  String defensevalue = "1";
  String offensevalue = "1";
  String autoDockState = "neither";
  String endDockState = "neither";
  String teamNumber = "";
  String buttonMessage = "Submit";

  String autoMoveMessage = "Did not move in auto";
  String autoDockMessage = "Did not dock in auto";
  String endDockMessage = "Did not dock in endgame";
  String scoredMessage = "Did not score both Cone and Cube";
  final String autoMoveConfirm = "Moved in auto";
  final String autoMoveDeny = "Did not move in auto";
  final String scoredConfirm = "Scored both Cube and Cone";
  final String scoredDeny = "Did not score Cube and Cone";
  final TextEditingController nameC = TextEditingController();

  var items = [
    '1',
    '2',
    '3',
    '4',
    '5',
  ];
  var autoDockItems = [
    'neither',
    'on platform',
    'balance platform',
  ];
  var endDockItems = [
    'neither',
    'in community',
    'on platform',
    'balance platform',
  ];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          children: <Widget>[
            Padding(padding: EdgeInsets.all(25)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: <Widget>[
                    Text(
                      'Team number: ',
                    ),
                    SizedBox(
                      width: 300.0,
                      child: TextField(
                        onChanged: (text) {
                          teamNumber = text;
                        },
                        controller: nameC,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Example (1086)',
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text("Score Defense (1-5)"),
                    DropdownButton(
                        value: defensevalue,
                        items: items.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            defensevalue = newValue!;
                          });
                        }),
                  ],
                ),
                Column(
                  children: [
                    Text("Score Offense (1-5)"),
                    DropdownButton(
                        value: offensevalue,
                        items: items.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            offensevalue = newValue!;
                          });
                        }),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      width: 200.0,
                      height: 100.0,
                      child: TextButton(
                        onPressed: (() {
                          String data =
                              "      {'teamNumber': '$teamNumber','defenseScore': $defensevalue,'offenseScore': $offensevalue,'auto': {'autoMove': $movedInAuto,'autoBottomScore': $autoBottomScore,'autoMiddleScore': $autoMiddleScore,'autoTopScore': $autoTopScore,'autoDockedState': '$autoDockState'},'teleop': {'scoredBoth': $scoredBoth,'teleopBottomScore': $teleopBottomScore,'teleopMiddleScore': $teleopMiddleScore,'teleopTopScore': $teleopTopScore,'teleopDockState': '$endDockState'}, \n";
                          readFile().then((String content) {
                            if (content.contains("matches")) {
                              content =
                                  content.substring(0, content.length - 2);
                              writeData(content + data + "\n" + "}");
                            } else {
                              writeData("matches {" + "\n" + data + "}" + "\n");
                            }
                          });
                          setState(() {
                            teleopTopScore = 0;
                            teleopMiddleScore = 0;
                            teleopBottomScore = 0;
                            autoTopScore = 0;
                            autoMiddleScore = 0;
                            autoBottomScore = 0;
                            movedInAuto = false;
                            scoredBoth = false;
                            defensevalue = "1";
                            offensevalue = "1";
                            autoDockState = "neither";
                            endDockState = "neither";
                            teamNumber = "";
                            nameC.text = teamNumber;
                          });
                          setState(() {
                            buttonMessage = "Success";
                          });
                          Future.delayed(const Duration(seconds: 1), () {
                            setState(() {
                              buttonMessage = "Submit";
                            });
                          });
                        }),
                        child: Text(
                          buttonMessage,
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.all(25)),
                    Text(
                      'Did the robot move in Auto',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      autoMoveMessage,
                    ),
                    Switch(
                      value: movedInAuto,
                      onChanged: (bool value) {
                        setState(() => movedInAuto = value);
                        if (movedInAuto) {
                          autoMoveMessage = autoMoveConfirm;
                        } else {
                          autoMoveMessage = autoMoveDeny;
                        }
                      },
                    ),
                    Padding(padding: EdgeInsets.all(25)),
                    Text(
                      'Did the robot dock in Auto',
                      style: TextStyle(fontSize: 20),
                    ),
                    DropdownButton(
                        value: autoDockState,
                        items: autoDockItems.map((String autoDockItems) {
                          return DropdownMenuItem(
                            value: autoDockItems,
                            child: Text(autoDockItems),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            autoDockState = newValue!;
                          });
                        }),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.all(25)),
                    Text(
                      'Pieces scored in Bottom in Auto',
                    ),
                    Text(
                      '$autoBottomScore',
                      style: TextStyle(fontSize: 30),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton(
                          onPressed: () {
                            if (autoBottomScore > 0) {
                              setState(() {
                                autoBottomScore--;
                              });
                            }
                          },
                          child: Text("Decrease Score"),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              autoBottomScore++;
                            });
                          },
                          child: Text("Increase Score"),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.all(25)),
                    Text(
                      'Pieces scored in Middle in Auto',
                    ),
                    Text(
                      '$autoMiddleScore',
                      style: TextStyle(fontSize: 30),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton(
                          onPressed: () {
                            if (autoMiddleScore > 0) {
                              setState(() {
                                autoMiddleScore--;
                              });
                            }
                          },
                          child: Text("Decrease Score"),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              autoMiddleScore++;
                            });
                          },
                          child: Text("Increase Score"),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.all(25)),
                    Text(
                      'Pieces scored in Top in Auto',
                    ),
                    Text(
                      '$autoTopScore',
                      style: TextStyle(fontSize: 30),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton(
                          onPressed: () {
                            if (autoTopScore > 0) {
                              setState(() {
                                autoTopScore--;
                              });
                            }
                          },
                          child: Text("Decrease Score"),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              autoTopScore++;
                            });
                          },
                          child: Text("Increase Score"),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.all(25)),
                    Text(
                      'Pieces scored in Bottom in Teleop',
                    ),
                    Text(
                      '$teleopBottomScore',
                      style: TextStyle(fontSize: 30),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton(
                          onPressed: () {
                            if (teleopBottomScore > 0) {
                              setState(() {
                                teleopBottomScore--;
                              });
                            }
                          },
                          child: Text("Decrease Score"),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              teleopBottomScore++;
                            });
                          },
                          child: Text("Increase Score"),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.all(25)),
                    Text(
                      'Pieces scored in Middle in Teleop',
                    ),
                    Text(
                      '$teleopMiddleScore',
                      style: TextStyle(fontSize: 30),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton(
                          onPressed: () {
                            if (teleopMiddleScore > 0) {
                              setState(() {
                                teleopMiddleScore--;
                              });
                            }
                          },
                          child: Text("Decrease Score"),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              teleopMiddleScore++;
                            });
                          },
                          child: Text("Increase Score"),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.all(25)),
                    Text(
                      'Pieces scored in Top in Teleop',
                    ),
                    Text(
                      '$teleopTopScore',
                      style: TextStyle(fontSize: 30),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton(
                          onPressed: () {
                            if (teleopTopScore > 0) {
                              setState(() {
                                teleopTopScore--;
                              });
                            }
                          },
                          child: Text("Decrease Score"),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              teleopTopScore++;
                            });
                          },
                          child: Text("Increase Score"),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(padding: EdgeInsets.all(25)),
                    Text(
                      'Did the robot score both Cube and Cone',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      scoredMessage,
                    ),
                    Switch(
                      value: scoredBoth,
                      onChanged: (bool value) {
                        setState(() => scoredBoth = value);
                        if (scoredBoth) {
                          scoredMessage = scoredConfirm;
                        } else {
                          scoredMessage = scoredDeny;
                        }
                      },
                    ),
                    Padding(padding: EdgeInsets.all(25)),
                    Text("Did the robot dock in endgame"),
                    DropdownButton(
                        value: endDockState,
                        items: endDockItems.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            endDockState = newValue!;
                          });
                        }),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
// This trailing comma makes auto-formatting nicer for build methods.
  }
}
//nice
