import 'dart:math' as math;

import 'package:kori_wis_demo/Debug/test_api_feedback/pathFindingTest2.dart';

class Spot {
  int h;
  int g;
  int f;
  final int i;
  final int j;
  final List<Spot> neighbors = [];
  bool isWall = false;

  Spot? previous;

  Spot({
    required this.h,
    required this.g,
    required this.f,
    required this.i,
    required this.j,
  }) {
    if (
        //717, 718호
        (i < 34 && j < 75) ||
            // 701호
            (i < 34 && j > 75) ||
            //704호
            ((i < 61 && i > 33) && j > 76) ||
            //705,6,8호
            ((i < 119 && i > 60) && j > 77) ||
            //708,10호
            // ((i < 107 && i > 88) && j > 77) ||
            //710호
            ((i > 118) && j > 77) ||
            //716,19호
            ((i < 48 && i > 34) && j < 47) ||
            //716호
            ((i == 48) && j < 25) ||
            //715,16호
            ((i < 107 && i > 48) && j < 47) ||
            //711,2,3호,비상구
            ((i < 107 && i > 71) && j == 47) ||
            ((i < 107 && i > 71) && j == 48) ||
            ((i < 107 && i > 71) && j == 49) ||
            ((i < 107 && i > 82) && j == 50) ||
            ((i < 107 && i > 82) && j == 51) ||
            ((i < 107 && i > 90) && j == 52) ||
            ((i < 107 && i > 90) && j == 53) ||
            ((i < 107 && i > 96) && (j>53 && j<56)) ||
            ((i < 119 && i > 106) && j < 56) ||
            //711호
            ((i < 121 && i > 118) && j < 41) ||
            //공조실
            ((i > 119) && j < 77) ||
            //화장실1, 계단
            ((i < 61 && i > 34) && (j > 47 && j < 76)) ||
            //엘리베이터
            ((i < 96 && i > 89) && (j > 54 && j < 77)) ||
            ((i < 90 && i > 86) && (j > 52 && j < 77))||
            ((i < 87 && i > 81) && (j > 52 && j < 77))||
            ((i < 82 && i > 75) && (j > 50 && j < 77))||
            ((i < 76 && i > 70) && (j > 50 && j < 77))||
            // ((i < 72 && i > 67) && (j > 49 && j < 77))||
            ((i < 71 && i > 61) && (j > 47 && j < 77))||
            //화장실2 및 계단
            ((i < 119 && i > 96) && (j > 56 && j < 77))) {
      isWall = true;
    }
    // if((i<13 && j<28)||(i<13 && j>30)||(14<i && i<18 && j<15)){
    //   isWall = true;
    // }else{
    //   isWall = false;
    // }
    // isWall = math.Random().nextDouble() < 0.3;
  }

  addNeighbors(List<List<Spot>> grid, int columns, int rows) {
    if (i < columns - 1) {
      neighbors.add(grid[i + 1][j]);
    }
    if (i > 0) {
      neighbors.add(grid[i - 1][j]);
    }
    if (j < rows - 1) {
      neighbors.add(grid[i][j + 1]);
    }
    if (j > 0) {
      neighbors.add(grid[i][j - 1]);
    }
    // // 대각선 제한
    // if (i > 0 && j > 0) {
    //   neighbors.add(grid[i - 1][j - 1]);
    // }
    // if (i < columns - 1 && j > 0) {
    //   neighbors.add(grid[i + 1][j - 1]);
    // }
    // if (i > 0 && j < rows - 1) {
    //   neighbors.add(grid[i - 1][j + 1]);
    // }
    // if (i < columns - 1 && j < rows - 1) {
    //   neighbors.add(grid[i + 1][j + 1]);
    // }
  }

  Spot copyWith({
    int? h,
    int? g,
    int? f,
    int? i,
    int? j,
  }) {
    return Spot(
      h: h ?? this.h,
      g: g ?? this.g,
      f: f ?? this.f,
      i: i ?? this.i,
      j: j ?? this.j,
    );
  }

  @override
  String toString() {
    return 'Spot(h: $h, g: $g, f: $f, i: $i, j: $j, neighbors:${neighbors.length})';
  }

  @override
  bool operator ==(Object other) {
    return other is Spot && other.i == i && other.j == j;
  }

  @override
  int get hashCode {
    return h.hashCode ^ g.hashCode ^ f.hashCode ^ i.hashCode ^ j.hashCode;
  }

  // heuristic
  int distanceFrom(Spot other) {
    return math
        .sqrt(((i - other.i) * (i - other.i)) + ((j - other.j) * (j - other.j)))
        .toInt();
  }
}
