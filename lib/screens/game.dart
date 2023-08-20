import 'dart:math';

import 'package:flutter/material.dart';

import '../config/app_constants.dart';

void main() => runApp(MaterialApp(home: GameScreen()));

enum SwipeDirection {
  up,
  down,
  left,
  right,
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<List<int>> grid = List.generate(4, (i) => List.generate(4, (j) => 0));

  // 最大のタイルの値を保持する変数
  int maxTileValue = 0;

  @override
  void initState() {
    super.initState();
    addRandomTwo(); // 初期化時にランダムに2のタイルを配置
  }

  // ランダムな空いているセルに2のタイルを追加する関数
  void addRandomTwo() {
    List<int> emptyCells = [];
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (grid[i][j] == 0) {
          emptyCells.add(i * 4 + j);
        }
      }
    }
    int randomCell = emptyCells[Random().nextInt(emptyCells.length)];
    int row = randomCell ~/ 4;
    int col = randomCell % 4;
    grid[row][col] = 2;
  }

  // スワイプした際の処理を行う関数
  void handleSwipe(SwipeDirection direction) {
    bool shouldAddRandomTwo = false;

    for (int col = 0; col < 4; col++) {
      List<int> column = [];
      for (int row = 0; row < 4; row++) {
        int value = 0;
        if (direction == SwipeDirection.up) {
          value = grid[row][col];
        } else if (direction == SwipeDirection.down) {
          value = grid[3 - row][col];
        } else if (direction == SwipeDirection.left) {
          value = grid[col][row];
        } else if (direction == SwipeDirection.right) {
          value = grid[col][3 - row];
        }
        if (value != 0) {
          column.add(value);
        }
      }

      // 同じ値のタイルが隣り合う場合にマージする処理
      int i = 0;
      while (i < column.length - 1) {
        if (column[i] == column[i + 1]) {
          column[i] *= 2;
          column.removeAt(i + 1);
        }
        i++;
      }

      // 方向に移動させる処理
      for (int row = 0; row < 4; row++) {
        int value = row < column.length ? column[row] : 0;
        if (direction == SwipeDirection.up) {
          if (grid[row][col] != value) shouldAddRandomTwo = true;
          grid[row][col] = value;
        } else if (direction == SwipeDirection.down) {
          if (grid[3 - row][col] != value) shouldAddRandomTwo = true;
          grid[3 - row][col] = value;
        } else if (direction == SwipeDirection.left) {
          if (grid[col][row] != value) shouldAddRandomTwo = true;
          grid[col][row] = value;
        } else if (direction == SwipeDirection.right) {
          if (grid[col][3 - row] != value) shouldAddRandomTwo = true;
          grid[col][3 - row] = value;
        }
      }
    }
    if (shouldAddRandomTwo) {
      addRandomTwo(); // タイルが動いた場合のみ、ランダムに2のタイルを追加
    }
    // 最大のタイルの値を更新
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (grid[i][j] > maxTileValue) {
          maxTileValue = grid[i][j];
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: width / 3.5,
                  height: width / 3.5,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.orange[100], // 背景色
                    borderRadius: BorderRadius.circular(8.0), // 角の丸み
                    boxShadow: [
                      // 影を追加
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      '4096',
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold), // テキストのスタイル
                      textAlign: TextAlign.center, // テキストの位置
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  width: width / 4,
                  height: width / 4,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.orange[100], // 背景色
                    borderRadius: BorderRadius.circular(8.0), // 角の丸み
                    boxShadow: [
                      // 影を追加
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'SCORE',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold), // テキストのスタイル
                        textAlign: TextAlign.center, // テキストの位置
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '$maxTileValue',
                        style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold), // テキストのスタイル
                        textAlign: TextAlign.center, // テキストの位置
                      ),
                    ],
                  ),
                ),
                Container(
                  width: width / 4,
                  height: width / 4,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.orange[100], // 背景色
                    borderRadius: BorderRadius.circular(8.0), // 角の丸み
                    boxShadow: [
                      // 影を追加
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'BEST',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold), // テキストのスタイル
                        textAlign: TextAlign.center, // テキストの位置
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '$maxTileValue',
                        style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold), // テキストのスタイル
                        textAlign: TextAlign.center, // テキストの位置
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 70),
            const Text(
              'Join the tiles and go to 2048 and beyond!',
              style: TextStyle(
                fontSize: 15, // フォントサイズ
                color: Colors.black45, // テキストの色
                letterSpacing: 1.2, // 文字間隔
                wordSpacing: 2.0, // 単語間隔
                shadows: [
                  // 影の効果
                  Shadow(
                    color: Colors.grey,
                    offset: Offset(1.0, 1.0),
                    blurRadius: 3.0,
                  ),
                ],
              ),
              textAlign: TextAlign.center, // テキストの位置
            ),
            const SizedBox(height: 30),
            SwipeArea(handleSwipe: handleSwipe, width: width, grid: grid),
          ],
        ),
      ),
    );
  }
}

// タイルを移動させるエリアのウィジェット
class SwipeArea extends StatelessWidget {
  final Function(SwipeDirection) handleSwipe;
  final double width;
  final List<List<int>> grid;

  SwipeArea(
      {required this.handleSwipe, required this.width, required this.grid});

  @override
  Widget build(BuildContext context) {
    double totalDy = 0; // 垂直方向のスワイプ距離の累積を追跡
    double totalDx = 0; // 水平方向のスワイプ距離の累積を追跡

    return GestureDetector(
      onPanUpdate: (details) {
        totalDy += details.delta.dy;
        totalDx += details.delta.dx;
      },
      onPanEnd: (details) {
        if (totalDy.abs() > totalDx.abs()) {
          if (totalDy < -50) {
            handleSwipe(SwipeDirection.up);
          } else if (totalDy > 50) {
            handleSwipe(SwipeDirection.down);
          }
        } else {
          if (totalDx < -50) {
            handleSwipe(SwipeDirection.left);
          } else if (totalDx > 50) {
            handleSwipe(SwipeDirection.right);
          }
        }
        // ここでグリッドを更新する場合は親ウィジェットでsetStateを呼び出す
      },
      child: Container(
        width: width * (5 / 6),
        height: width * (5 / 6),
        decoration: BoxDecoration(
          color: Colors.grey[100], // 背景色を少し明るく
          borderRadius: BorderRadius.circular(10), // 角の丸み
          boxShadow: [
            // 影を追加
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(8), // タイルとの間の隙間
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 8, // 縦方向の隙間
              crossAxisSpacing: 8), // 横方向の隙間
          itemCount: 16,
          itemBuilder: (context, index) =>
              GridItem(grid[index ~/ 4][index % 4]),
        ),
      ),
    );
  }
}

// 各タイルを表現するウィジェット
class GridItem extends StatelessWidget {
  final int value;
  const GridItem(this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: tileColors[value], // 対応する色をtileColorsから取得
        // border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Center(
        child: Text(
          value == 0 ? '' : value.toString(),
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800]),
        ),
      ),
    );
  }
}
