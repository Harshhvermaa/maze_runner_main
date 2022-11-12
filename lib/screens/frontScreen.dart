import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maze_runner/screens/keyboard.dart';

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
                    // maxLength: 6,
                    controller: _nickname,
                    cursorHeight: 40,
                    style: TextStyle(fontSize: 40, color: Colors.white),
                    decoration: InputDecoration(
                        hintText: "Nickname",
                        hintStyle: GoogleFonts.roboto(
                            color: Colors.white.withOpacity(0.2),
                            fontSize: 40,
                            fontWeight: FontWeight.w600),
                        contentPadding: EdgeInsets.only(),
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
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    _nickname.text.length > 3
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Keyboard(
                                      nickname: _nickname.text,
                                    )))
                        : Fluttertoast.showToast(msg: "Please write your name");
                  },
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
