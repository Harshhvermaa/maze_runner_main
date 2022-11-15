import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MyController extends StatefulWidget {
  final String gameID;
  final String nickName;
  const MyController({required this.gameID, required this.nickName});

  @override
  State<MyController> createState() => _MyControllerState();
}
// test commit

class _MyControllerState extends State<MyController> {
  var ref = FirebaseDatabase.instance.ref();
  late BannerAd _bannerAd;
  bool _isAdLoaded = false;
  late String player = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initBanner();
    ref.child(widget.gameID).once().then((value) {
      if (value.snapshot.exists) {
        if (value.snapshot.value == "") {
          player = "P1";
          setDefaultValuesOfPlayer();
        } else if (value.snapshot.child("P1").exists &&
            value.snapshot.child("P2").exists &&
            value.snapshot.child("P3").exists &&
            value.snapshot.child("P4").exists &&
            value.snapshot.child("P5").exists) {
          player = "P6";
          setDefaultValuesOfPlayer();
        } else if (value.snapshot.child("P1").exists &&
            value.snapshot.child("P2").exists &&
            value.snapshot.child("P3").exists &&
            value.snapshot.child("P4").exists) {
          player = "P5";
          setDefaultValuesOfPlayer();
        } else if (value.snapshot.child("P1").exists &&
            value.snapshot.child("P2").exists &&
            value.snapshot.child("P3").exists) {
          player = "P4";
          setDefaultValuesOfPlayer();
        } else if (value.snapshot.child("P1").exists &&
            value.snapshot.child("P2").exists) {
          player = "P3";
          setDefaultValuesOfPlayer();
        } else if (value.snapshot.child("P1").exists) {
          player = "P2";
          setDefaultValuesOfPlayer();
        }
      }
    });
    // setDefaultValuesOfPlayer();
    // Fluttertoast.showToast(msg: "Player $player");
  }

  @override
  Widget build(BuildContext context) {
    Timer? timer2;
    JoystickMode joystickMode = JoystickMode.horizontalAndVertical;
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          bool res = await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Confirm"),
                  content: const Text("Would you like to to go back"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text("No")),
                    TextButton(
                        onPressed: () async {
                          // await ref.child("${widget.gameID}/$player").remove();
                          Navigator.of(context).pop(true);
                        },
                        child: const Text("Yes")),
                  ],
                );
              });
          return Future.value(res);
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: SizedBox(
                height: 250.h,
                width: 250.w,
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
                      timer2 = Timer.periodic(const Duration(milliseconds: 30),
                          (timer) {
                        //code to run on every 5 seconds
                        // _onScreenKeyEvent('left');
                        //set x node  -> -1
                        setValueXOfPlayer(details.x);
                        print("move left");
                        timer2?.cancel();
                      });
                    } else if (details.x > 0) {
                      timer2 = Timer.periodic(const Duration(milliseconds: 30),
                          (timer) {
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
                      timer2 = Timer.periodic(const Duration(milliseconds: 30),
                          (timer) {
                        //code to run on every 5 seconds
                        // _onScreenKeyEvent('up');
                        print("move up");
                        setValueYOfPlayer(details.y);
                        timer2?.cancel();
                      });
                      print("object moves up");
                      print("${details.y}" "a");
                    } else if (details.y > 0) {
                      timer2 = Timer.periodic(const Duration(milliseconds: 30),
                          (timer) {
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
            Positioned(
                bottom: 0,
                child: (_isAdLoaded)
                    ? SizedBox(
                        width: _bannerAd.size.width.toDouble(),
                        height: _bannerAd.size.height.toDouble(),
                        // width: _bannerAd.size.width.toDouble(),
                        // height: _bannerAd.size.height.toDouble(),
                        child: AdWidget(ad: _bannerAd),
                      )
                    : const SizedBox())
          ],
        ),
      ),
    );
  }

  void setValueXOfPlayer(double x1) async {
    await ref.child("${widget.gameID}/$player").update({"x": x1.toString()});
  }

  void setValueYOfPlayer(double y1) async {
    await ref.child("${widget.gameID}/$player").update({"y": y1.toString()});
  }

  void setDefaultValuesOfPlayer() async {
    await ref
        .child("${widget.gameID}/$player")
        .set({"name": widget.nickName, "x": "0", "y": "0"});
    // await ref.child("${widget.gameID}/a").remove();
  }

  void initBanner() {
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: "ca-app-pub-3940256099942544/6300978111",
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            setState(() {
              _isAdLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            Fluttertoast.showToast(msg: "Fail to load");
          },
        ),
        request: const AdRequest());
    _bannerAd.load();
  }
}
