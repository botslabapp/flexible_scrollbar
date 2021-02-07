import 'dart:math';

import 'package:flexible_scrollbar/flexible_scrollbar.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController scrollController = ScrollController();

  BarPosition barPosition = BarPosition.end;

  Axis scrollDirection = Axis.vertical;

  final int itemsCount = 99;

  final List<Color> itemsColors = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < itemsCount; ++i) {
      final int randomColorNumber =
          (math.Random().nextDouble() * 0xFFFFFF).toInt();
      itemsColors.add(Color(randomColorNumber).withOpacity(1.0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (_, orientation) {
      final bool isVertical = orientation == Orientation.portrait;
      scrollDirection = isVertical ? Axis.vertical : Axis.horizontal;
      return Scaffold(
        body: SafeArea(
          child: FlexibleScrollbar(
            controller: scrollController,
            isAlwaysVisible: true,
            scrollThumb: (ScrollbarInfo info) {
              return AnimatedContainer(
                width: isVertical
                    ? info.isDragging
                        ? info.thumbSize.width
                        : info.thumbSize.width / 2
                    : info.thumbSize.height,
                height: !isVertical
                    ? info.isDragging
                        ? info.thumbSize.height
                        : info.thumbSize.height / 2
                    : info.thumbSize.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black.withOpacity(info.isDragging ? 1 : 0.6),
                ),
                duration: const Duration(milliseconds: 300),
              );
            },
            barPosition: barPosition,
            child: GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              controller: scrollController,
              itemCount: 99,
              scrollDirection: scrollDirection,
              itemBuilder: (context, int index) {
                final randomColor = itemsColors[index];
                return Container(
                  width: double.infinity,
                  height: 100,
                  color: randomColor,
                  child: Center(
                    child: Text(
                      (++index).toString(),
                      style: TextStyle(
                        color: randomColor.computeLuminance() > 0.5
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Transform.rotate(
            angle: scrollDirection == Axis.vertical ? pi / 2 : 0,
            child: Icon(Icons.height),
          ),
          onPressed: () => setState(() {
            switch (barPosition) {
              case BarPosition.start:
                barPosition = BarPosition.end;
                break;
              case BarPosition.end:
                barPosition = BarPosition.start;
                break;
            }
          }),
        ),
      );
    });
  }
}
