import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeSectionTitle extends StatefulWidget {
  const HomeSectionTitle({Key? key, this.callback, this.title})
      : super(key: key);
  final VoidCallback? callback;
  final String? title;

  @override
  HomeSectionTitleState createState() => HomeSectionTitleState();
}

class HomeSectionTitleState extends State<HomeSectionTitle>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_ctrl);
  }

  void _move() {
    _ctrl.isDismissed ? _ctrl.forward() : _ctrl.reverse();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {_move()},
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: 60,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            children: [
              Text(widget.title ?? "",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),
              GestureDetector(
                onTap: () {
                  if (widget.callback != null) {
                    widget.callback!();
                  }
                },
                child: FadeTransition(
                  opacity: _animation,
                  child: SizeTransition(
                    axis: Axis.horizontal,
                    sizeFactor:
                        CurvedAnimation(parent: _ctrl, curve: Curves.linear),
                    child: Container(
                      height: 90,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(width: 8.0),
                          Text('home_section_title'.tr,
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                              )),
                          const SizedBox(width: 8.0),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(child: Container(
                height: 90,
                decoration: const BoxDecoration(
                  color: Colors.transparent
                ),
              ))
            ],
          )),
    );
  }
}
