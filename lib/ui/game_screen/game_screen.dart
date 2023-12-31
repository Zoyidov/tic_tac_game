import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_game/ui/register_screen/register_screen.dart';

class GameScreen extends StatefulWidget {
  final String player1;
  final String player2;

  const GameScreen({Key? key, required this.player1, required this.player2})
      : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}


class _GameScreenState extends State<GameScreen> {
  AudioCache audioCache = AudioCache();

  late List<List<String>> _board;
  late String _currentPlayer;
  late String _winner;
  late bool _gameOver;
  int _step = 0;
  Set<int> clickedItems = {};

  @override
  void initState() {
    super.initState();
    _board = List.generate(3, (_) => List.generate(3, (_) => ""));
    _currentPlayer = 'X';
    _winner = "";
    _gameOver = false;
  }

  void resetGame() {
    setState(() {
      _board = List.generate(3, (_) => List.generate(3, (_) => ""));
      _currentPlayer = 'X';
      _winner = "";
      _gameOver = false;
      _step = 0;
      clickedItems = {};
    });
  }

  void makeMove(int row, int col) {
    if (_board[row][col] != '' || _gameOver) {
      return;
    }
    setState(() {
      _board[row][col] = _currentPlayer;
      if (_board[row][0] == _currentPlayer &&
          _board[row][1] == _currentPlayer &&
          _board[row][2] == _currentPlayer) {
        _winner = _currentPlayer;
        _gameOver = true;
      } else if (_board[0][col] == _currentPlayer &&
          _board[1][col] == _currentPlayer &&
          _board[2][col] == _currentPlayer) {
        _winner = _currentPlayer;
        _gameOver = true;
      } else if (_board[0][0] == _currentPlayer &&
          _board[1][1] == _currentPlayer &&
          _board[2][2] == _currentPlayer) {
        _winner = _currentPlayer;
        _gameOver = true;
      } else if (_board[0][2] == _currentPlayer &&
          _board[1][0] == _currentPlayer &&
          _board[2][0] == _currentPlayer) {
        _winner = _currentPlayer;
        _gameOver = true;
      }
      _currentPlayer = _currentPlayer == 'X' ? "O" : "X";
      if (!_board.any((row) => row.any((cell) => cell == ""))) {
        _gameOver = true;
        _winner = "It's a tie";
      }
      if (_winner != "") {
        AwesomeDialog(
            dismissOnTouchOutside: false,
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.rightSlide,
            btnOkText: "Play Again",
            title: _winner == "X"
                ? "${widget.player1} Win!"
                : _winner == "O"
                    ? "${widget.player2} Win!"
                    : "It is a tie!",
            btnOkOnPress: () {
              resetGame();
            }).show();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF323D5B),
      appBar: AppBar(
        title: const Text('Game Screen'),
        backgroundColor: const Color(0xFF323D5B),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                AwesomeDialog(
                    context: context,
                    dialogType: DialogType.question,
                    animType: AnimType.rightSlide,
                    btnOkText: "Change User's name!",
                    btnCancelText: "Restart the Game!",
                    btnOkColor: const Color(0xFF323D5B),
                    btnCancelColor: const Color(0xFF323D5B),
                    btnCancelOnPress: (){
                      resetGame();
                    },
                    btnOkOnPress: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()));
                    }).show();
              },
              icon: const Icon(
                Icons.settings,
                size: 30,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 70,
            ),
            SizedBox(
              height: 100,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Turn: ",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        _currentPlayer == "X"
                            ? "${widget.player1}($_currentPlayer)"
                            : "${widget.player2}($_currentPlayer)",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: _currentPlayer == "X"
                                ? const Color(0xFFE25041)
                                : const Color(0xFF1CBD9E)),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.all(5),
              child: GridView.builder(
                  itemCount: 9,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    int row = index ~/ 3;
                    int col = index % 3;
                    return GestureDetector(
                      onTap: () {
                        if (!clickedItems.contains(index)) {
                          clickedItems.add(index);
                          _step++;
                          AudioPlayer().play(UrlSource(_step % 2 == 0 ? "https://www.soundjay.com/buttons/button-3.mp3" : "https://www.soundjay.com/buttons/button-09a.mp3"));
                          makeMove(row, col);
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: const Color(0xFF0E1E3A),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            _board[row][col],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 100,
                                color: _board[row][col] == "X"
                                    ? const Color(0xFFE25041)
                                    : const Color(0xFF1CBD9E)),
                          ),
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
