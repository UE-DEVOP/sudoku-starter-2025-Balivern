import 'package:flutter/material.dart';
import 'package:sudoku_api/sudoku_api.dart';

class Game extends StatefulWidget {
  const Game({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  int _counter = 0;
  late PuzzleOptions puzzleOptions;
  late Puzzle puzzle;

  @override
  void initState() {
    super.initState();
    puzzleOptions = PuzzleOptions(patternName: "winter");
    puzzle = Puzzle(puzzleOptions);
    puzzle.generate();
    puzzle.solvedBoard();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height / 2;
    var width = MediaQuery.of(context).size.width;
    var maxSize = height > width ? width : height;
    var boxSize = (maxSize / 3).ceil().toDouble();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: boxSize * 3,
              height: boxSize * 3,
              child: GridView.count(
                crossAxisCount: 3,
                children: List.generate(9, (x) {
                  return Container(
                    width: boxSize,
                    height: boxSize,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent),
                    ),
                    child: GridView.count(
                      crossAxisCount: 3,
                      children: List.generate(9, (y) {
                        var value = puzzle.board()?.matrix()?[x][y].getValue();
                        var solutionValue = puzzle.solvedBoard()?.matrix()?[x][y].getValue();
                        return value != 0 ? Container(
                          width: boxSize / 3,
                          height: boxSize / 3,
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.3, color: Colors.black),
                          ),
                          child: Center(
                            child: Text(
                              value.toString(),
                              style: const TextStyle(fontSize: 20, color: Colors.black),
                            ),
                          ),
                        ) : InkWell(
                          onTap: () {
                            setState(() {
                              puzzle.board()?.matrix()?[x][y].setValue(1);
                            });
                          },
                          child: Container(
                            width: boxSize / 3,
                            height: boxSize / 3,
                            decoration: BoxDecoration(
                              border: Border.all(width: 0.3, color: Colors.black),
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                }),
              ),
      )],
        ),
      ),
    );
  }
}
