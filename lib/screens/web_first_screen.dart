import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dart:math';

import 'package:maze_runner/screens/maze_generator.dart';
import 'package:maze_runner/screens/two_player_maze.dart';

class WebFirstScreen extends StatefulWidget {
  const WebFirstScreen({super.key});

  @override
  State<WebFirstScreen> createState() => _WebFirstScreenState();
}

class _WebFirstScreenState extends State<WebFirstScreen> {
  late int id;
  var ref = FirebaseDatabase.instance.ref();
  int noOfPlayers = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (true) {
      id = 100000 + Random().nextInt(899999);
      ref.child(id.toString()).set({"a": "a"});
      ref.child(id.toString()).onValue.listen((event) {
        if (event.snapshot.exists) {
          int noOfNodes = event.snapshot.children.length;
          print("no of nodes inside web first page = $noOfNodes");
          if (noOfPlayers < noOfNodes) {
            if (noOfNodes == 2) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MazeGenerator(id.toString())));
            } else if (noOfNodes == 3) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => TwoPlayerMaze()));
            }
            noOfPlayers++;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Maze runner",
          style: GoogleFonts.josefinSans(fontSize: 30),
        ),
        backgroundColor: Colors.black,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 72, 80, 74),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 5,
                    ),
                    Image.asset(
                      "assets/l.png",
                      width: 20,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      id.toString(),
                      style: GoogleFonts.josefinSans(fontSize: 30),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: Container(
              color: Colors.blue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/maze.jpg", height: 400),
                  const SizedBox(
                    height: 100,
                  ),
                  Text(
                    "Phone + Screen = Console",
                    style: GoogleFonts.josefinSans(
                        color: Colors.white,
                        fontSize: 27,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: const Color.fromARGB(255, 49, 48, 48),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Connect your phone as a gamepads",
                    style: GoogleFonts.quicksand(
                        fontSize: 35,
                        color: Colors.white,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Open ",
                        style: GoogleFonts.josefinSans(
                            fontSize: 25, color: Colors.white),
                      ),
                      Text(
                        " mazerunner.com",
                        style: GoogleFonts.josefinSans(
                            fontSize: 25,
                            color: const Color.fromARGB(255, 0, 255, 34)),
                      ),
                      Text(
                        " in your phone",
                        style: GoogleFonts.josefinSans(
                            fontSize: 25, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "and ",
                        style: GoogleFonts.josefinSans(
                            fontSize: 25, color: Colors.white),
                      ),
                      Text(
                        "enter the code",
                        style: GoogleFonts.josefinSans(
                            fontSize: 25,
                            color: const Color.fromARGB(255, 81, 255, 0)),
                      ),
                      Text(
                        " below",
                        style: GoogleFonts.josefinSans(
                            fontSize: 25, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 72, 80, 74),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            "assets/l.png",
                            width: 20,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            id.toString(),
                            style: GoogleFonts.josefinSans(
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Image.asset(
                    "assets/phone-in-hand.png",
                    height: 300,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
