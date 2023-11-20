import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SpeedList extends StatefulWidget {
  const SpeedList(
      {super.key, this.selectedSpeed = "1.0", required this.callback});

  final String selectedSpeed;

  final Function(String) callback;

  @override
  State<SpeedList> createState() => _SpeedListState();
}

class _SpeedListState extends State<SpeedList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );

  List speedList = ["0.25", "0.5", "0.75", "1.0", "1.25", "1.5", "1.75", "2.0"];

  @override
  void initState() {
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size biggest = constraints.biggest;

        const childHeight = 90.0;
        const childWidth = 60.0;

        const targetChildHeight = childHeight * 3;
        const targetChildWidth = childWidth * 3;

        var beginRect = RelativeRect.fromSize(
          Rect.fromLTWH(Get.width, Get.height, childWidth, childHeight),
          biggest,
        );

        var endRect = RelativeRect.fromSize(
          Rect.fromLTWH(
            biggest.width - targetChildWidth,
            biggest.height - targetChildHeight,
            targetChildWidth,
            targetChildHeight,
          ),
          biggest,
        );

        /// 补间动画
        final rectAnimation = RelativeRectTween(begin: beginRect, end: endRect)
            .animate(_controller);

        return Stack(
          children: [
            PositionedTransition(
              rect: rectAnimation,
              child: DecoratedBox(
                decoration: const BoxDecoration(color: Colors.black),
                child: Container(
                  width: childWidth,
                  height: childHeight,
                  color: Colors.white30,
                  child: ListView(
                    children: List.generate(
                      speedList.length,
                      (index) => ListTile(
                        trailing: widget.selectedSpeed == speedList[index]
                            ? const Icon(
                                Icons.check,
                                color: Colors.blueAccent,
                              )
                            : null,
                        title: Text(
                          speedList[index],
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
                        ),
                        onTap: () {
                          widget.callback(speedList[index],);
                          Navigator.pop(context);
                        },
                      ),
                      // 其他的 ListTile 属性可以根据需要设置
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
