import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

class MyController extends StatefulWidget {
  final String gameID;
  const MyController(this.gameID);

  @override
  State<MyController> createState() => _MyControllerState();
}

class _MyControllerState extends State<MyController> {
  var ref = FirebaseDatabase.instance.ref();
  late String player = "P1";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref.child(widget.gameID).onValue.listen((event) {
      if (event.snapshot.exists) {
        int noOfNode = event.snapshot.children.length;
        if (noOfNode == 0) {
          player = "P1";
        } else if (noOfNode == 1) {
          player = "P2";
        }
      }
    });
    setDefaultValuesOfPlayer();
  }

  @override
  Widget build(BuildContext context) {
    Timer? timer2;
    JoystickMode joystickMode = JoystickMode.horizontalAndVertical;

    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 250,
          width: 250,
          child: JoystickArea(
            // onStickDragStart: (){
            //
            // },
            onStickDragEnd: () {
              setValueXOfPlayer(0);
              setValueYOfPlayer(0);
              print("__________________________run");
              timer2?.cancel();
            },
            mode: joystickMode,
            // initialJoystickAlignment: const Alignment(0, 0.8),
            listener: (details) {
              if (details.x < 0) {
                print("object moves left");
                print("${details.x}" "c");
                timer2 =
                    Timer.periodic(const Duration(milliseconds: 30), (timer) {
                  //code to run on every 5 seconds
                  // _onScreenKeyEvent('left');
                  //set x node  -> -1
                  setValueXOfPlayer(details.x);
                  print("move left");
                  timer2?.cancel();
                });
              } else if (details.x > 0) {
                timer2 =
                    Timer.periodic(const Duration(milliseconds: 30), (timer) {
                  //code to run on every 5 seconds
                  // _onScreenKeyEvent('right');
                  print("move right");
                  setValueXOfPlayer(details.x);
                  timer2?.cancel();
                });
                print("object moves right");
                print("right ${details.x}");
                print(details.x.runtimeType);
              } else if (details.y < 0) {
                timer2 =
                    Timer.periodic(const Duration(milliseconds: 30), (timer) {
                  //code to run on every 5 seconds
                  // _onScreenKeyEvent('up');
                  print("move up");
                  setValueYOfPlayer(details.y);
                  timer2?.cancel();
                });
                print("object moves up");
                print("${details.y}" "a");
              } else if (details.y > 0) {
                timer2 =
                    Timer.periodic(const Duration(milliseconds: 30), (timer) {
                  //code to run on every 5 seconds
                  // _onScreenKeyEvent('down');
                  print("move down");
                  setValueYOfPlayer(details.y);
                  timer2?.cancel();
                });
                print("object moves down");
                print("${details.y}" "b");
              } else if (details.x == 0.0 && details.y == 0.0) {
                setValueXOfPlayer(0);
                setValueYOfPlayer(0);
                // _timer2?.cancel();
                print("time closed !!!!!!!!!!!!!!!!!!!!!!");
                print(details.x);
                print(details.y);
              }
              // print(details.x);
              // print(details.y);
            },
          ),
        ),
      ),
    );
  }

  void setValueXOfPlayer(double x1) async {
    await ref.child("${widget.gameID}/${player}").update({"x": x1.toString()});
  }

  void setValueYOfPlayer(double y1) async {
    await ref.child("${widget.gameID}/${player}").update({"y": y1.toString()});
  }

  void setDefaultValuesOfPlayer() async {
    await ref.child("${widget.gameID}/${player}").set({"x": "0", "y": "0"});
    await ref.child("${widget.gameID}/a").remove();
  }
}
