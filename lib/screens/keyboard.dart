import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:maze_runner/screens/controller.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class Keyboard extends StatefulWidget {
  const Keyboard({super.key});

  @override
  State<Keyboard> createState() => _KeyboardState();
}

class _KeyboardState extends State<Keyboard> {
  TextEditingController _text = TextEditingController();

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
      backgroundColor: Color.fromARGB(255, 42, 42, 42),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 24),
              child: Container(
                height: 70,
                width: screenWidth,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 0, 0, 0),
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
                      Image(
                        image: AssetImage("assets/l.png"),
                        height: 30,
                        width: 30,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: TextField(
                          showCursor: _text.text.length == 0 ? true : false,
                          keyboardType: TextInputType.none,
                          maxLength: 6,
                          controller: _text,
                          cursorHeight: 40,
                          style: TextStyle(fontSize: 40, color: Colors.white),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(top: 17),
                              border: InputBorder.none),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
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
                                    _text.text = _text.text + "0";
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
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        MyController(_text.text)));
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
            color: Color.fromARGB(255, 31, 31, 31),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 4),
                color: Colors.blueAccent.withOpacity(0.5),
                blurRadius: 8.0,
              ),
            ]),
        child: Center(
          child: index < 9
              ? Text(
                  "${index + 1}".toString(),
                  style: TextStyle(
                      // fontWeight: FontWeight.w600,
                      fontSize: 30,
                      color: Colors.white),
                )
              : index == 11
                  ? Image(
                      image: AssetImage("assets/check.png"),
                      color: Colors.greenAccent,
                      height: 30,
                      width: 30,
                    )
                  : index == 10
                      ? Text(
                          "0".toString(),
                          style: TextStyle(
                              // fontWeight: FontWeight.w600,
                              fontSize: 30,
                              color: Colors.white),
                        )
                      : Image(
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