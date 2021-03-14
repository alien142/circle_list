import 'dart:math';

import 'package:circle_list_demo/pages/demo_page_two.dart';
import 'package:flutter/material.dart';
import 'package:circle_list/circle_list.dart';

class BottomShowWidget extends StatefulWidget {
  @override
  _BottomShowWidgetState createState() => _BottomShowWidgetState();
}

class _BottomShowWidgetState extends State<BottomShowWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animationBottomShow;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animationBottomShow = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    debugPrint("top_show销毁");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        doExit(context, _controller);
      },
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0),
        body: Container(
          width: size.width,
          height: size.height,
          child: Stack(
            children: <Widget>[
              Positioned(
                bottom: 20,
                left: size.width / 2 - 28,
                child: AnimatedBuilder(
                    animation: _animationBottomShow,
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          shape: BoxShape.circle),
                    ),
                    builder: (ctx, child) {
                      return Transform.scale(
                        scale:
                            (size.height / 28) * (_animationBottomShow.value),
                        child: child,
                      );
                    }),
              ),
              AnimatedBuilder(
                animation: _animationBottomShow,
                child: CircleList(
                  showInitialAnimation: false,
                  dragAngleRange: DragAngleRange(0.0, pi),
                  children: List.generate(10, (index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (ctx) {
                          return ShowDemoPageTwo();
                        }));
                      },
                      child: Icon(
                        Icons.drive_eta,
                        color: Colors.black.withOpacity(0.1 * (index + 1)),
                        size: 40,
                      ),
                    );
                  }),
                  innerCircleColor: Colors.black54,
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.red],
                  ),
                  centerWidget: GestureDetector(
                      onTap: () {
                        doExit(context, _controller);
                        debugPrint("点击");
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.width / 3,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          color: Colors.transparent,
                          margin: EdgeInsets.only(bottom: 40),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      )),
                ),
                builder: (ctx, child) {
                  return Transform.translate(
                      offset: Offset(
                          0,
                          MediaQuery.of(context).size.height -
                              (_animationBottomShow.value) * size.width),
                      child: child);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void doExit(BuildContext context, AnimationController controller) {
    controller.reverse().then((r) {
      Navigator.of(context).pop();
    });
  }
}
