import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game/sanke_pixel.dart';

import 'blank_pixel.dart';
import 'food_pixel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

enum SnakeDirection { up, down, left, right }

class _HomePageState extends State<HomePage> {
  int row = 10;
  int noofrows = 100;

  List<int> snakePos = [0, 1, 2];
  SnakeDirection currentDirection = SnakeDirection.right;

  int foodPos = 7;

  void startGame() {
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {
        moveSnake();
      });
    });
  }

  void eatFood() {
    while (snakePos.contains(foodPos)) {
      foodPos = Random().nextInt(noofrows);
    }
  }

  void moveSnake() {
    int snakeHead = snakePos.last;
    int nextPos = 0;

    switch (currentDirection) {
      case SnakeDirection.right:
        nextPos = snakeHead + 1;
        if (nextPos % row == 0) {
          nextPos -= row;
        }
        break;
      case SnakeDirection.left:
        nextPos = snakeHead - 1;
        if (nextPos % row == row - 1) {
          nextPos += row;
        }
        break;
      case SnakeDirection.up:
        nextPos = snakeHead - row;
        if (nextPos < 0) {
          nextPos += noofrows;
        }
        break;
      case SnakeDirection.down:
        nextPos = snakeHead + row;
        if (nextPos >= noofrows) {
          nextPos -= noofrows;
        }
        break;
    }

    snakePos.add(nextPos);

    if (nextPos == foodPos) {
      eatFood();
    } else {
      snakePos.removeAt(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Column(
        children: [
          Expanded(
            child: Container(),
          ),
          Expanded(
            flex: 4,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0 && currentDirection != SnakeDirection.up) {
                  setState(() {
                    currentDirection = SnakeDirection.down;
                  });
                } else if (details.delta.dy < 0 && currentDirection != SnakeDirection.down) {
                  setState(() {
                    currentDirection = SnakeDirection.up;
                  });
                }
              },
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 0 && currentDirection != SnakeDirection.left) {
                  setState(() {
                    currentDirection = SnakeDirection.right;
                  });
                } else if (details.delta.dx < 0 && currentDirection != SnakeDirection.right) {
                  setState(() {
                    currentDirection = SnakeDirection.left;
                  });
                }
              },
              child: GridView.builder(
                itemCount: noofrows,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: row,
                ),
                itemBuilder: (context, index) {
                  if (snakePos.contains(index)) {
                    return const SnakePixel();
                  } else if (foodPos == index) {
                    return const FoodPixel();
                  } else {
                    return const BlankPixel();
                  }
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Center(
                child: MaterialButton(
                  child: Text('Play'),
                  textColor: Colors.white,
                  color: Colors.pink,
                  onPressed: startGame,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
