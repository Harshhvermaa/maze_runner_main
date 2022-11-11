import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maze_runner/screens/controller.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class Keyboard extends StatefulWidget {
  String nickname;
  Keyboard({super.key, required this.nickname});

  @override
  State<Keyboard> createState() => _KeyboardState();
}

class _KeyboardState extends State<Keyboard> {
  final TextEditingController _text = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    print(_text.text);
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    var size = MediaQuery.of(context).size;

    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    // List<String> = []

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 42, 42, 42),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.nickname),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 24),
              child: Container(
                height: 70,
                width: screenWidth,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      width: 2,
                      color: Colors.blue,
                    )),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Image(
                        image: AssetImage("assets/l.png"),
                        height: 30,
                        width: 30,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: TextField(
                          showCursor: _text.text.isEmpty ? true : false,
                          keyboardType: TextInputType.none,
                          maxLength: 6,
                          controller: _text,
                          cursorHeight: 40,
                          style: const TextStyle(
                              fontSize: 40, color: Colors.white),
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(top: 17),
                              border: InputBorder.none),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
                // height: 550,
                width: screenWidth,
                child: StaggeredGrid.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    // crossAxisSpacing: 5,
                    children: [
                      "0",
                      "1",
                      "2",
                      "3",
                      "4",
                      "5",
                      "6",
                      "7",
                      "8",
                      "9",
                      "10",
                      "11",
                    ]
                        .map(
                          (e) => GestureDetector(
                            onTap: () {
                              if (_text.text.length <= 5) {
                                print(_text.text.length);
                                FocusScopeNode currentFocus =
                                    FocusScope.of(context);
                                if (e != "9" && e != "10" && e != "11") {
                                  setState(() {
                                    _text.text = _text.text +
                                        (int.parse(e) + 1).toString();
                                    print("text is ${_text.text}");
                                  });
                                } else if (e == "10") {
                                  setState(() {
                                    _text.text = "${_text.text}0";
                                  });
                                }
                              }
                              if (e == "9") {
                                setState(() {
                                  _text.text = _text.text
                                      .substring(0, _text.text.length - 1);
                                });
                              } else if (e == "11") {
                                //main code to navigator to the controller
                                var ref = FirebaseDatabase.instance.ref();

                                ref.child(_text.text).once().then((value) {
                                  if (value.snapshot.exists) {
                                    print(value.snapshot);
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => MyController(
                                                gameID: _text.text,
                                                nickName: widget.nickname)));
                                  } else {
                                    Fluttertoast.showToast(msg: "invalid code");
                                  }
                                });

                                // ref.child(_text.text).onValue.listen(
                                //   (event) {
                                //     if (event.snapshot.exists) {
                                //       print(event.snapshot);
                                //       Navigator.of(context).push(
                                //           MaterialPageRoute(
                                //               builder: (context) =>
                                //                   MyController(_text.text)));
                                //     } else {
                                //       Fluttertoast.showToast(
                                //           msg: "invalid code");
                                //     }
                                //   },
                                // );
                              }
                            },
                            child: numberContainer(
                              int.parse(e),
                            ),
                          ),
                        )
                        .toList())),
          ],
        ),
      ),
    );
  }

  Widget numberContainer(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color.fromARGB(255, 31, 31, 31),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 4),
                color: Colors.blueAccent.withOpacity(0.5),
                blurRadius: 8.0,
              ),
            ]),
        child: Center(
          child: index < 9
              ? Text(
                  "${index + 1}".toString(),
                  style: const TextStyle(
                      // fontWeight: FontWeight.w600,
                      fontSize: 30,
                      color: Colors.white),
                )
              : index == 11
                  ? const Image(
                      image: AssetImage("assets/check.png"),
                      color: Colors.greenAccent,
                      height: 30,
                      width: 30,
                    )
                  : index == 10
                      ? Text(
                          "0".toString(),
                          style: const TextStyle(
                              // fontWeight: FontWeight.w600,
                              fontSize: 30,
                              color: Colors.white),
                        )
                      : const Image(
                          image: AssetImage("assets/close.png"),
                          color: Colors.redAccent,
                          height: 30,
                          width: 20,
                        ),
        ),
      ),
    );
  }
}
