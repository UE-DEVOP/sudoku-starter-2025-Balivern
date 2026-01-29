import 'package:flutter/material.dart';
import 'package:sudoku_api/sudoku_api.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class Game extends StatefulWidget {
  const Game({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  late PuzzleOptions puzzleOptions;
  late Puzzle puzzle;

  // Variables pour la sélection de case
  int? selectedBlockIndex; // Index du bloc 3x3 sélectionné
  int? selectedCellIndex; // Index de la cellule dans le bloc

  @override
  void initState() {
    super.initState();
    puzzleOptions = PuzzleOptions(patternName: "winter");
    puzzle = Puzzle(puzzleOptions);
    puzzle.generate();
    puzzle.solvedBoard();
  }

  // Méthode pour sélectionner une case
  void selectCell(int blockIndex, int cellIndex) {
    setState(() {
      // Si on clique sur la même case, on la désélectionne
      if (selectedBlockIndex == blockIndex && selectedCellIndex == cellIndex) {
        selectedBlockIndex = null;
        selectedCellIndex = null;
      } else {
        selectedBlockIndex = blockIndex;
        selectedCellIndex = cellIndex;
      }
    });
  }

  // Vérifie si une case est sélectionnée
  bool isCellSelected(int blockIndex, int cellIndex) {
    return selectedBlockIndex == blockIndex && selectedCellIndex == cellIndex;
  }

  // Méthode pour insérer une valeur avec validation
  void insertValue(int value) {
    if (selectedBlockIndex == null || selectedCellIndex == null) return;

    var solutionValue = puzzle.solvedBoard()?.matrix()?[selectedBlockIndex!][selectedCellIndex!].getValue();

    if (solutionValue != null && value == solutionValue) {
      // Valeur correcte : on l'insère
      setState(() {
        puzzle.board()?.matrix()?[selectedBlockIndex!][selectedCellIndex!].setValue(value);
        selectedBlockIndex = null;
        selectedCellIndex = null;
      });

      // Vérifier si le jeu est terminé
      if (isGameComplete()) {
        gameEnd();
      }
    } else {
      // Valeur incorrecte : afficher le SnackBar et ne pas insérer
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        duration: const Duration(seconds: 3),
        content: AwesomeSnackbarContent(
          title: 'Raté!',
          message: 'La valeur $value ne correspond pas à la solution attendue.',
          contentType: ContentType.warning,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  // Vérifie si le jeu est terminé
  bool isGameComplete() {
    var board = puzzle.board()?.matrix();
    if (board == null) return false;

    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        var value = board[i][j].getValue();
        if (value == null || value == 0) {
          return false;
        }
      }
    }
    return true;
  }

  void gameEnd() {
    // Naviguer vers l'écran de fin
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pushNamed(context, '/end');
    });
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
            // ----------------------- GRILLE DE SUDOKU -----------------------
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
                        var solutionValue =
                            puzzle.solvedBoard()?.matrix()?[x][y].getValue();
                        bool isSelected = isCellSelected(x, y);
                        bool hasValue = value != null && value != 0;

                        return InkWell(
                          onTap: hasValue
                              ? null
                              : () {
                                  selectCell(x, y);
                                },
                          child: Container(
                            width: boxSize / 3,
                            height: boxSize / 3,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 0.3, color: Colors.black),
                              color: isSelected
                                  ? Colors.blue.withValues(alpha: 0.3)
                                  : Colors.transparent,
                            ),
                            child: Center(
                              child: Text(
                                value != null && value != 0
                                    ? value.toString()
                                    : (solutionValue != null ? solutionValue.toString() : ''),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: value != null && value != 0
                                      ? Colors.black
                                      : Colors.black12,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                }),
              ),
            ),
            // ----------------------- GRILLE DE BOUTONS -----------------------
            const SizedBox(height: 20),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ElevatedButton(
                        onPressed: (selectedBlockIndex != null &&
                                selectedCellIndex != null)
                            ? () {
                                insertValue(index + 1);
                              }
                            : null,
                        style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                                const Color.fromARGB(255, 28, 84, 167))),
                        child: Text(
                          (index + 1).toString(),
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                        ),
                      ),
                    );
                  }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    int number = index + 6;
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ElevatedButton(
                        onPressed: (selectedBlockIndex != null &&
                                selectedCellIndex != null)
                            ? () {
                                insertValue(number);
                              }
                            : null,
                        style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                                const Color.fromARGB(255, 28, 84, 167))),
                        child: Text(
                          number.toString(),
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
            // ----------------------- BOUTON RESOLUTION DE GRILLE -----------------------
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                 gameEnd();
              },
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                      const Color.fromARGB(255, 201, 121, 17))),
              child: const Text(
                'Résoudre le Sudoku',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
