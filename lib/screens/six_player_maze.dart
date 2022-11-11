import 'dart:async';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';
import '../models/cell.dart';

class SixPlayerMaze extends StatefulWidget {
  final String gameID;
  const SixPlayerMaze(this.gameID);

  @override
  State<SixPlayerMaze> createState() => _SixPlayerMazeState();
}

class _SixPlayerMazeState extends State<SixPlayerMaze> {
  var ref = FirebaseDatabase.instance.ref();

  late List<Cell> cells;
  late final Timer _timer;
  late int _currentStepOfPlayer1;
  late int _currentStepOfPlayer2;
  late int _currentStepOfPlayer3;
  late int _currentStepOfPlayer4;
  late int _currentStepOfPlayer5;
  late int _currentStepOfPlayer6;
  final row = height ~/ spacing;
  final cols = width ~/ spacing;
  final List<Cell> stack = [];
  bool _isCompleted = false;
  bool _isWin = false;

  @override
  void initState() {
    super.initState();
    ref.child("${widget.gameID}/P1/x").onValue.listen((event) {
      if (event.snapshot.exists) {
        var value = event.snapshot.value.toString();

        // if joystick moves left
        if (double.parse(value) < 0) {
          _onScreenKeyEventOfPlayer1('left');
        }

        //if joystick moves right
        if (double.parse(value) > 0) {
          _onScreenKeyEventOfPlayer1('right');
        }
      }
    });
    ref.child("${widget.gameID}/P1/y").onValue.listen((event) {
      if (event.snapshot.exists) {
        var value = event.snapshot.value.toString();

        // if joystick moves up
        if (double.parse(value) < 0) {
          _onScreenKeyEventOfPlayer1('up');
        }

        // if joystick moves down
        if (double.parse(value) > 0) {
          _onScreenKeyEventOfPlayer1('down');
        }
      }
    });
    ref.child("${widget.gameID}/P2/x").onValue.listen((event) {
      if (event.snapshot.exists) {
        var value = event.snapshot.value.toString();

        // if joystick moves left
        if (double.parse(value) < 0) {
          _onScreenKeyEventOfPlayer2('left');
        }

        //if joystick moves right
        if (double.parse(value) > 0) {
          _onScreenKeyEventOfPlayer2('right');
        }
      }
    });
    ref.child("${widget.gameID}/P2/y").onValue.listen((event) {
      if (event.snapshot.exists) {
        var value = event.snapshot.value.toString();

        // if joystick moves up
        if (double.parse(value) < 0) {
          _onScreenKeyEventOfPlayer2('up');
        }

        // if joystick moves down
        if (double.parse(value) > 0) {
          _onScreenKeyEventOfPlayer2('down');
        }
      }
    });
    ref.child("${widget.gameID}/P3/x").onValue.listen((event) {
      if (event.snapshot.exists) {
        var value = event.snapshot.value.toString();

        // if joystick moves left
        if (double.parse(value) < 0) {
          _onScreenKeyEventOfPlayer3('left');
        }

        //if joystick moves right
        if (double.parse(value) > 0) {
          _onScreenKeyEventOfPlayer3('right');
        }
      }
    });
    ref.child("${widget.gameID}/P3/y").onValue.listen((event) {
      if (event.snapshot.exists) {
        var value = event.snapshot.value.toString();

        // if joystick moves up
        if (double.parse(value) < 0) {
          _onScreenKeyEventOfPlayer3('up');
        }

        // if joystick moves down
        if (double.parse(value) > 0) {
          _onScreenKeyEventOfPlayer3('down');
        }
      }
    });
    ref.child("${widget.gameID}/P4/x").onValue.listen((event) {
      if (event.snapshot.exists) {
        var value = event.snapshot.value.toString();

        // if joystick moves left
        if (double.parse(value) < 0) {
          _onScreenKeyEventOfPlayer4('left');
        }

        //if joystick moves right
        if (double.parse(value) > 0) {
          _onScreenKeyEventOfPlayer4('right');
        }
      }
    });
    ref.child("${widget.gameID}/P4/y").onValue.listen((event) {
      if (event.snapshot.exists) {
        var value = event.snapshot.value.toString();

        // if joystick moves up
        if (double.parse(value) < 0) {
          _onScreenKeyEventOfPlayer4('up');
        }

        // if joystick moves down
        if (double.parse(value) > 0) {
          _onScreenKeyEventOfPlayer4('down');
        }
      }
    });
    ref.child("${widget.gameID}/P5/x").onValue.listen((event) {
      if (event.snapshot.exists) {
        var value = event.snapshot.value.toString();

        // if joystick moves left
        if (double.parse(value) < 0) {
          _onScreenKeyEventOfPlayer5('left');
        }

        //if joystick moves right
        if (double.parse(value) > 0) {
          _onScreenKeyEventOfPlayer5('right');
        }
      }
    });
    ref.child("${widget.gameID}/P5/y").onValue.listen((event) {
      if (event.snapshot.exists) {
        var value = event.snapshot.value.toString();

        // if joystick moves up
        if (double.parse(value) < 0) {
          _onScreenKeyEventOfPlayer5('up');
        }

        // if joystick moves down
        if (double.parse(value) > 0) {
          _onScreenKeyEventOfPlayer5('down');
        }
      }
    });
    ref.child("${widget.gameID}/P6/x").onValue.listen((event) {
      if (event.snapshot.exists) {
        var value = event.snapshot.value.toString();

        // if joystick moves left
        if (double.parse(value) < 0) {
          _onScreenKeyEventOfPlayer6('left');
        }

        //if joystick moves right
        if (double.parse(value) > 0) {
          _onScreenKeyEventOfPlayer6('right');
        }
      }
    });
    ref.child("${widget.gameID}/P6/y").onValue.listen((event) {
      if (event.snapshot.exists) {
        var value = event.snapshot.value.toString();

        // if joystick moves up
        if (double.parse(value) < 0) {
          _onScreenKeyEventOfPlayer6('up');
        }

        // if joystick moves down
        if (double.parse(value) > 0) {
          _onScreenKeyEventOfPlayer6('down');
        }
      }
    });
    reset();
  }

  List<Cell> getCells() {
    List<Cell> cells = [];
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < cols; j++) {
        cells.add(Cell(j, i));
      }
    }
    return cells;
  }

  int? getIndex(int i, int j) {
    if (i < 0 || j < 0 || i > row - 1 || j > cols - 1) {
      return null;
    }
    return i + (j * (width ~/ spacing));
  }

  List<Cell> checkNeighbours(Cell cell) {
    List<Cell> neighbours = [];
    int? top = getIndex(cell.i, cell.j - 1);
    int? bottom = getIndex(cell.i, cell.j + 1);
    int? left = getIndex(cell.i - 1, cell.j);
    int? right = getIndex(cell.i + 1, cell.j);
    if (top != null && !cells[top].visited) {
      neighbours.add(cells[top]);
    }
    if (right != null && !cells[right].visited) {
      neighbours.add(cells[right]);
    }
    if (bottom != null && !cells[bottom].visited) {
      neighbours.add(cells[bottom]);
    } else if (left != null && !cells[left].visited) {
      neighbours.add(cells[left]);
    }
    return neighbours;
  }

  void reset() {
    stack.clear();
    _isCompleted = false;
    _isWin = false;
    cells = getCells();
    _currentStepOfPlayer1 = 0;
    _currentStepOfPlayer2 = 0;
    _currentStepOfPlayer3 = 0;
    _currentStepOfPlayer4 = 0;
    _currentStepOfPlayer5 = 0;
    _currentStepOfPlayer6 = 0;

    cells[_currentStepOfPlayer1].visited = true;
    cells[_currentStepOfPlayer2].visited = true;
    cells[_currentStepOfPlayer3].visited = true;
    cells[_currentStepOfPlayer4].visited = true;
    cells[_currentStepOfPlayer5].visited = true;
    cells[_currentStepOfPlayer6].visited = true;
    _timer = Timer.periodic(const Duration(milliseconds: 100), updateCell);
  }

  void updateCell(Timer timer) {
    for (int i = 0; i < 15; i++) {
      var neighbours = checkNeighbours(cells[_currentStepOfPlayer1]);
      if (neighbours.isEmpty) {
        if (stack.isNotEmpty) {
          var lastCell = stack.removeLast();
          // setState(() {
          _currentStepOfPlayer1 = getIndex(lastCell.i, lastCell.j)!;
          // });
        } else {
          _timer.cancel();
          // setState(() {
          _isCompleted = true;
          // });
        }
      } else {
        var random = Random().nextInt(neighbours.length);
        var next = neighbours[random];
        stack.add(cells[_currentStepOfPlayer1]);
        // setState(() {
        next.visited = true;
        removeWalls(cells[_currentStepOfPlayer1], next);
        // });
        _currentStepOfPlayer1 = getIndex(next.i, next.j)!;
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  removeWalls(Cell current, Cell next) {
    if (current.j - next.j == 1) {
      current.left = false;
      next.right = false;
    } else if (current.j - next.j == -1) {
      current.right = false;
      next.left = false;
    } else if (current.i - next.i == 1) {
      current.top = false;
      next.bottom = false;
    } else if (current.i - next.i == -1) {
      current.bottom = false;
      next.top = false;
    }
  }

  void _onScreenKeyEventOfPlayer1(String key) {
    if (!_isCompleted || _isWin) {
      return;
    }
    setState(() {
      if (key == 'up' && !cells[_currentStepOfPlayer1].top) {
        _currentStepOfPlayer1 = getIndex(cells[_currentStepOfPlayer1].i - 1,
            cells[_currentStepOfPlayer1].j)!;
      } else if (key == 'down' && !cells[_currentStepOfPlayer1].bottom) {
        _currentStepOfPlayer1 = getIndex(cells[_currentStepOfPlayer1].i + 1,
            cells[_currentStepOfPlayer1].j)!;
      } else if (key == 'left' && !cells[_currentStepOfPlayer1].left) {
        _currentStepOfPlayer1 = getIndex(cells[_currentStepOfPlayer1].i,
            cells[_currentStepOfPlayer1].j - 1)!;
      } else if (key == 'right' && !cells[_currentStepOfPlayer1].right) {
        _currentStepOfPlayer1 = getIndex(cells[_currentStepOfPlayer1].i,
            cells[_currentStepOfPlayer1].j + 1)!;
      }
    });
    if (_currentStepOfPlayer1 == getIndex(0, row - 1)) {
      setState(() {
        _isWin = true;
      });
    }
  }

  void _onScreenKeyEventOfPlayer2(String key) {
    if (!_isCompleted || _isWin) {
      return;
    }
    setState(() {
      if (key == 'up' && !cells[_currentStepOfPlayer2].top) {
        _currentStepOfPlayer2 = getIndex(cells[_currentStepOfPlayer2].i - 1,
            cells[_currentStepOfPlayer2].j)!;
      } else if (key == 'down' && !cells[_currentStepOfPlayer2].bottom) {
        _currentStepOfPlayer2 = getIndex(cells[_currentStepOfPlayer2].i + 1,
            cells[_currentStepOfPlayer2].j)!;
      } else if (key == 'left' && !cells[_currentStepOfPlayer2].left) {
        _currentStepOfPlayer2 = getIndex(cells[_currentStepOfPlayer2].i,
            cells[_currentStepOfPlayer2].j - 1)!;
      } else if (key == 'right' && !cells[_currentStepOfPlayer2].right) {
        _currentStepOfPlayer2 = getIndex(cells[_currentStepOfPlayer2].i,
            cells[_currentStepOfPlayer2].j + 1)!;
      }
    });
    if (_currentStepOfPlayer2 == getIndex(0, row - 1)) {
      setState(() {
        _isWin = true;
      });
    }
  }

  void _onScreenKeyEventOfPlayer3(String key) {
    if (!_isCompleted || _isWin) {
      return;
    }
    setState(() {
      if (key == 'up' && !cells[_currentStepOfPlayer3].top) {
        _currentStepOfPlayer3 = getIndex(cells[_currentStepOfPlayer3].i - 1,
            cells[_currentStepOfPlayer3].j)!;
      } else if (key == 'down' && !cells[_currentStepOfPlayer3].bottom) {
        _currentStepOfPlayer3 = getIndex(cells[_currentStepOfPlayer3].i + 1,
            cells[_currentStepOfPlayer3].j)!;
      } else if (key == 'left' && !cells[_currentStepOfPlayer3].left) {
        _currentStepOfPlayer3 = getIndex(cells[_currentStepOfPlayer3].i,
            cells[_currentStepOfPlayer3].j - 1)!;
      } else if (key == 'right' && !cells[_currentStepOfPlayer3].right) {
        _currentStepOfPlayer3 = getIndex(cells[_currentStepOfPlayer3].i,
            cells[_currentStepOfPlayer3].j + 1)!;
      }
    });
    if (_currentStepOfPlayer3 == getIndex(0, row - 1)) {
      setState(() {
        _isWin = true;
      });
    }
  }

  void _onScreenKeyEventOfPlayer4(String key) {
    if (!_isCompleted || _isWin) {
      return;
    }
    setState(() {
      if (key == 'up' && !cells[_currentStepOfPlayer4].top) {
        _currentStepOfPlayer4 = getIndex(cells[_currentStepOfPlayer4].i - 1,
            cells[_currentStepOfPlayer4].j)!;
      } else if (key == 'down' && !cells[_currentStepOfPlayer4].bottom) {
        _currentStepOfPlayer4 = getIndex(cells[_currentStepOfPlayer4].i + 1,
            cells[_currentStepOfPlayer4].j)!;
      } else if (key == 'left' && !cells[_currentStepOfPlayer4].left) {
        _currentStepOfPlayer4 = getIndex(cells[_currentStepOfPlayer4].i,
            cells[_currentStepOfPlayer4].j - 1)!;
      } else if (key == 'right' && !cells[_currentStepOfPlayer4].right) {
        _currentStepOfPlayer4 = getIndex(cells[_currentStepOfPlayer4].i,
            cells[_currentStepOfPlayer4].j + 1)!;
      }
    });
    if (_currentStepOfPlayer3 == getIndex(0, row - 1)) {
      setState(() {
        _isWin = true;
      });
    }
  }

  void _onScreenKeyEventOfPlayer5(String key) {
    if (!_isCompleted || _isWin) {
      return;
    }
    setState(() {
      if (key == 'up' && !cells[_currentStepOfPlayer5].top) {
        _currentStepOfPlayer5 = getIndex(cells[_currentStepOfPlayer5].i - 1,
            cells[_currentStepOfPlayer5].j)!;
      } else if (key == 'down' && !cells[_currentStepOfPlayer5].bottom) {
        _currentStepOfPlayer5 = getIndex(cells[_currentStepOfPlayer5].i + 1,
            cells[_currentStepOfPlayer5].j)!;
      } else if (key == 'left' && !cells[_currentStepOfPlayer5].left) {
        _currentStepOfPlayer5 = getIndex(cells[_currentStepOfPlayer5].i,
            cells[_currentStepOfPlayer5].j - 1)!;
      } else if (key == 'right' && !cells[_currentStepOfPlayer5].right) {
        _currentStepOfPlayer5 = getIndex(cells[_currentStepOfPlayer5].i,
            cells[_currentStepOfPlayer5].j + 1)!;
      }
    });
    if (_currentStepOfPlayer5 == getIndex(0, row - 1)) {
      setState(() {
        _isWin = true;
      });
    }
  }

  void _onScreenKeyEventOfPlayer6(String key) {
    if (!_isCompleted || _isWin) {
      return;
    }
    setState(() {
      if (key == 'up' && !cells[_currentStepOfPlayer6].top) {
        _currentStepOfPlayer6 = getIndex(cells[_currentStepOfPlayer6].i - 1,
            cells[_currentStepOfPlayer6].j)!;
      } else if (key == 'down' && !cells[_currentStepOfPlayer6].bottom) {
        _currentStepOfPlayer6 = getIndex(cells[_currentStepOfPlayer6].i + 1,
            cells[_currentStepOfPlayer6].j)!;
      } else if (key == 'left' && !cells[_currentStepOfPlayer6].left) {
        _currentStepOfPlayer6 = getIndex(cells[_currentStepOfPlayer6].i,
            cells[_currentStepOfPlayer6].j - 1)!;
      } else if (key == 'right' && !cells[_currentStepOfPlayer6].right) {
        _currentStepOfPlayer6 = getIndex(cells[_currentStepOfPlayer6].i,
            cells[_currentStepOfPlayer6].j + 1)!;
      }
    });
    if (_currentStepOfPlayer6 == getIndex(0, row - 1)) {
      setState(() {
        _isWin = true;
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
                        widget.gameID,
                        style: GoogleFonts.josefinSans(fontSize: 30),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
                child: FittedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Five player mode",
                    style: TextStyle(color: Colors.white),
                  ),
                  Container(
                    color: Colors.red,
                    height: height,
                    width: width,
                    child: Stack(
                      children: List.generate(
                        cells.length,
                        (index) => Positioned(
                          top: cells[index].x,
                          left: cells[index].y,
                          child: Container(
                              height: spacing,
                              width: spacing,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: cells[index].right
                                      ? const BorderSide(
                                          color: Colors.white, width: 1)
                                      : BorderSide.none,
                                  bottom: cells[index].bottom
                                      ? const BorderSide(
                                          color: Colors.white, width: 1)
                                      : BorderSide.none,
                                  left: cells[index].left
                                      ? const BorderSide(
                                          color: Colors.white, width: 1)
                                      : BorderSide.none,
                                  top: cells[index].top
                                      ? const BorderSide(
                                          color: Colors.white, width: 1)
                                      : BorderSide.none,
                                ),
                                // image: DecorationImage(image: AssetImage("assets/runner.png")),
                                color: (index == _currentStepOfPlayer1 &&
                                        _isCompleted)
                                    ? Colors.blue.withOpacity(0.7)
                                    : (index == _currentStepOfPlayer2 &&
                                            _isCompleted)
                                        ? Colors.orange
                                        : (index == _currentStepOfPlayer3 &&
                                                _isCompleted)
                                            ? Colors.green
                                            : (index == _currentStepOfPlayer4 &&
                                                    _isCompleted)
                                                ? Colors.pink
                                                : (index == _currentStepOfPlayer5 &&
                                                        _isCompleted)
                                                    ? Colors.brown
                                                    : (index == _currentStepOfPlayer6 &&
                                                            _isCompleted)
                                                        ? Colors.purple
                                                        : Colors.transparent,
                                // : cells[index].visited
                                //     ? Colors.purple.withOpacity(0.5)
                                // : Colors.transparent,
                              ),
                              padding: const EdgeInsets.all(2),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: index == 0
                                    ? const Text(
                                        'Start',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      )
                                    : index == getIndex(0, row - 1)
                                        ? const Text(
                                            'End',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          )
                                        : null,
                              )),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    _isWin
                        ? 'You Win !!'
                        : _isCompleted
                            ? 'Maze Generation Completed'
                            : 'Generating Maze...',
                    style: const TextStyle(color: Colors.white, fontSize: 22),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  _isWin
                      ? MaterialButton(
                          elevation: 0,
                          color: Colors.white,
                          onPressed: () {
                            setState(() {
                              reset();
                            });
                          },
                          child: const Text(
                            'Generate Another Maze',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        )
                      : _isCompleted
                          ? const Text(
                              'Press arrow keys to play.',
                              style: TextStyle(color: Colors.white),
                            )
                          : const SizedBox(),
                ],
              ),
            )),
          ),
        ));
  }
}
