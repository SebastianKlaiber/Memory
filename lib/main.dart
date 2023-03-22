import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Memory Game',
      home: MemoryGame(),
    );
  }
}

class MemoryGame extends StatefulWidget {
  const MemoryGame({super.key});

  @override
  State<MemoryGame> createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
  late List<bool> _selected;
  late List<int> _items;
  late int _previousIndex;
  bool _gameOver = false;

  @override
  void initState() {
    super.initState();
    _selected = List.generate(16, (_) => false);
    _items = _generateItems();
    _previousIndex = -1;
    _gameOver = false;
  }

  List<int> _generateItems() {
    List<int> items = List.generate(8, (index) => index + 1);
    items.addAll(List.generate(8, (index) => index + 1));
    items.shuffle(Random());
    return items;
  }

  void _onItemClicked(int index) {
    if (!_selected[index] && !_gameOver) {
      setState(() {
        _selected[index] = true;
        if (_previousIndex >= 0) {
          if (_items[_previousIndex] == _items[index]) {
            _previousIndex = -1;
            if (!_selected.contains(false)) {
              _gameOver = true;
              _showGameOverDialog();
            }
          } else {
            Future.delayed(const Duration(milliseconds: 500), () {
              setState(() {
                _selected[_previousIndex] = false;
                _selected[index] = false;
                _previousIndex = -1;
              });
            });
          }
        } else {
          _previousIndex = index;
        }
      });
    }
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: const Text('Congratulations, you won!'),
          actions: <Widget>[
            TextButton(
              child: const Text('Restart'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _selected = List.generate(16, (_) => false);
                  _items = _generateItems();
                  _previousIndex = -1;
                  _gameOver = false;
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Game'),
      ),
      body: GridView.count(
        crossAxisCount: 4,
        children: List.generate(16, (index) {
          return GestureDetector(
            onTap: () {
              _onItemClicked(index);
            },
            child: Card(
              color: _selected[index] || _gameOver ? Colors.grey[300] : Colors.blue,
              child: Center(
                child: _selected[index] || _gameOver
                    ? Text(
                        '${_items[index]}',
                        style: const TextStyle(fontSize: 24),
                      )
                    : null,
              ),
            ),
          );
        }),
      ),
    );
  }
}
