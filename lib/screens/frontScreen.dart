import 'package:flutter/material.dart';

class FrontScreen extends StatefulWidget {
  const FrontScreen({super.key});

  @override
  State<FrontScreen> createState() => _FrontScreenState();
}

class _FrontScreenState extends State<FrontScreen> {
  TextEditingController _nickname = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 42, 42, 42),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18),
            child: Container(
              height: 70,
              width: screenWidth,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 0, 0, 0),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  width: 2,
                  color: Colors.blue,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Center(
                  child: TextField(
                    maxLength: 6,
                    controller: _nickname,
                    cursorHeight: 40,
                    style: TextStyle(fontSize: 40, color: Colors.white),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 12),
                        border: InputBorder.none),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18),
            child: Container(
                height: 70,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 0, 0, 0),
                  // borderRadius: BorderRadius.circular(20),
                ),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "Submit",
                    style: TextStyle(fontSize: 25),
                  ),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    // side: BorderSide(color: Colors.red)
                  ))),
                )),
          ),
        ],
      ),
    );
  }
}
