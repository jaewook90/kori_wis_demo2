import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Screens/Services/Facility/FacilityScreen.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Utills/spot/spot_model.dart';
import 'package:kori_wis_demo/Utills/spot/spot_widget.dart';

class PathFindingTest2 extends StatefulWidget {
  const PathFindingTest2({Key? key}) : super(key: key);

  @override
  State<PathFindingTest2> createState() => _PathFindingTest2State();
}

class _PathFindingTest2State extends State<PathFindingTest2> {
  // number of rows , change it according to your screen size
  int columns = 133;
// number of columns
  int rows = 97;

  // the complete grid
  final List<List<Spot>> grid = [];

  List<Spot> openSet = [];
  List<Spot> closedSet = [];

  List<Spot> path = [];

  Spot? start;
  Spot? end;

  late String backgroundImage;

  @override
  void initState() {
    super.initState();
    init();
    backgroundImage = "assets/screens/Facility/FacilityMain.png";
  }

  @override
  Widget build(BuildContext context) {
    final sizeConfig = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(onPressed: (){navPage(context: context, page: FacilityScreen()).navPageToPage();}, icon: Icon(Icons.home))
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(backgroundImage), fit: BoxFit.cover)),
        child: Stack(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 150,
              ),
              for (List<Spot> row in grid)
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  for (Spot spot in row)
                    SpotWidget(
                      onTap: onSpotTap,
                      spot: spot,
                      color: spot == end
                          ? Colors.red
                          : spot.isWall
                              ? Colors.black.withOpacity(0.1)
                              : path.contains(spot)
                                  ? Colors.green
                                  : closedSet.contains(spot)
                                      ? Colors.red
                                      : openSet.contains(spot)
                                          ? Colors.orange
                                          : Colors.white.withOpacity(0.5),
                    )
                ]),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      onPressed: () {
                        startSearching();
                      },
                      child: const Text(
                        "Start",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 21,
                          color: Colors.green,
                        ),
                      )),
                  TextButton(
                      onPressed: () {
                        init();
                      },
                      child: const Text(
                        "Reset",
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 21),
                      )),
                ],
              )
            ],
          ),
        ]),
      ),
    );
  }


  // 도착점 설정 함수
  onSpotTap(Spot spot) {
    if (!spot.isWall) {
      // print('a');
      setState(() {
        end = grid[spot.i][spot.j];
      });
    }
  }

  // randome init for spots and walls positions
  init() {
    // print('b');
    grid.clear();
    openSet.clear();
    closedSet.clear();
    path.clear();
    for (var i = 0; i < columns; i++) {
      // print('c');
      grid.add([]);
    }

    for (var i = 0; i < columns; i++) {
      // print('d');
      for (var j = 0; j < rows; j++) {
        // print('e');
        grid[i].add(Spot(i: i, j: j, h: 0, g: 0, f: 0));
      }
    }

    for (List<Spot> row in grid) {
      for (Spot spot in row) {
        // print('g');
        spot.addNeighbors(grid, columns, rows);
      }
    }
    start = grid[61][50];
    end = grid[columns - 1][rows - 1];
    start!.isWall = false;
    end!.isWall = false;

    setState(() {});
  }

  // start the algorithm
  startSearching() async {
    // print('h');
    openSet.clear();
    closedSet.clear();
    path.clear();
    openSet.add(start!);
    while (openSet.isNotEmpty) {
      // print('i');
      // some delaytion just for whatching the operation on the screen
      await Future.delayed(const Duration(milliseconds: 100));
      int winner = 0;
      for (int i = 0; i < openSet.length; i++) {
        // print('j');
        if (openSet[i].f < openSet[winner].f) {
          // print('k');
          winner = i;
        }
      }
      Spot current = openSet[winner];
      if (current == end) {
        // print('l');
        // find the path
        setState(() {
          path.clear();
          var temp = current;
          path.add(temp);
          while (temp.previous != null) {
            path.add(temp.previous!);
            temp = temp.previous!;
          }
        });
        print("done!!");
        return;

        // done
      }

      openSet.remove(current);
      closedSet.add(current);

      final neighbors = current.neighbors;
      for (int i = 0; i < neighbors.length; i++) {
        // print('m');
        var neighbor = neighbors[i];
        if (!closedSet.contains(neighbor) && !neighbor.isWall) {
          // print('n');
          var tempG = current.g + neighbor.distanceFrom(current);
          var newPath = false;
          if (openSet.contains(neighbor)) {
            // print('o');
            if (neighbor.g > tempG) {
              // print('p');
              neighbor.g = tempG;
              newPath = true;
            }
          } else {
            // print('q');
            neighbor.g = tempG;
            newPath = true;
            openSet.add(neighbor);
          }
          if (newPath) {
            // print('r');
            neighbor.h = neighbor.distanceFrom(end!);
            neighbor.f = neighbor.g + neighbor.h;
            neighbor.previous = current;
          }
          // print('s');
          path.clear();
          var temp = current;
          path.add(temp);
          while (temp.previous != null) {
            // print('t');
            path.add(temp.previous!);
            temp = temp.previous!;
          }
          // setState(() {
          //   print('s');
          //   path.clear();
          //   var temp = current;
          //   path.add(temp);
          //   while (temp.previous != null) {
          //     print('t');
          //     path.add(temp.previous!);
          //     temp = temp.previous!;
          //   }
          // });
        }
      }
    }
    // setState(() {});
    print("no Solution!!");
    return;
  }
}
