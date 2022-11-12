import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:maze_runner/firebase_options.dart';
import 'package:maze_runner/screens/frontScreen.dart';
import 'package:maze_runner/screens/join.dart';
import 'package:maze_runner/screens/keyboard.dart';
import 'package:maze_runner/screens/maze_generator.dart';
import 'package:maze_runner/screens/two_player_contoller.dart';
import 'package:maze_runner/screens/two_player_maze.dart';
import 'package:maze_runner/screens/web_first_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var screenHeight = MediaQuery.of(context).size.height;
    // var screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      title: 'Maze Generator',
      debugShowCheckedModeBanner: false,
      home: kIsWeb ? WebFirstScreen() : FrontScreen(),
    );
  }
}
