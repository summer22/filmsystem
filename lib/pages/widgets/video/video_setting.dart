import 'package:flutter/material.dart';
import 'package:get/get.dart';


class VideoSetting extends StatefulWidget {
  const VideoSetting({Key? key, required this.speedCallBack, this.pipCallBack, this.downloadCallBack}) : super(key: key);

  final VoidCallback speedCallBack;
  final VoidCallback? pipCallBack;
  final VoidCallback? downloadCallBack;

  @override
  State<StatefulWidget> createState() => _VideoSettingState();
}

class _VideoSettingState extends State<VideoSetting>
    with SingleTickerProviderStateMixin {

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,);

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
    return  LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size biggest = constraints.biggest;

        const childHeight = 60.0;
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
        final rectAnimation =
        RelativeRectTween(begin: beginRect, end: endRect)
            .animate(_controller);

        return Stack(
          children: [
            PositionedTransition(
              rect: rectAnimation,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                    color: Colors.black
                ),
                child: Container(
                  width: childWidth,
                  height: childHeight,
                  color: Colors.white30,
                  child: ListView(
                    children: [
                      // ListTile(
                      //   leading: const Icon(Icons.download, color: Colors.white),
                      //   title: Text('download'.tr, style: const TextStyle(color: Colors.white, fontSize: 15),),
                      //   onTap: () {
                      //     if(widget.downloadCallBack != null) {
                      //       Navigator.pop(context);
                      //       widget.downloadCallBack!();
                      //     }
                      //   },
                      // ),
                      ListTile(
                        leading: const Icon(Icons.speed, color: Colors.white,),
                        title: Text('play_speed'.tr, style: const TextStyle(color: Colors.white, fontSize: 15),),
                        onTap: () {
                          Navigator.pop(context);
                          widget.speedCallBack();
                        },
                      ),
                      // ListTile(
                      //   leading: const Icon(Icons.picture_in_picture, color: Colors.white,),
                      //   title: Text('picture_in_picture'.tr, style: const TextStyle(color: Colors.white, fontSize: 15),),
                      //   onTap: () {
                      //     if(widget.pipCallBack != null) {
                      //       Navigator.pop(context);
                      //       widget.pipCallBack!();
                      //     }
                      //   },
                      // ),
                    ],
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
