
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _animation;

  @override
  void initState() {
    _ctrl =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_ctrl);

    _ctrl.forward();
    super.initState();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _ctrl.forward(from: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 200,),
          FadeTransition(
            opacity: _animation,
            child: SizeTransition(
              axis: Axis.horizontal,
              sizeFactor: CurvedAnimation(parent: _ctrl, curve: Curves.linear),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.orange,
                  child:
                  const Icon(Icons.android, color: Colors.green, size: 80)),
            ),
          ),
          const SizedBox(height: 100,),
          GestureDetector(
           onTap: (){
             _ctrl.reverse();
           },
           child: const Text("反向点击", style: TextStyle(color: Colors.black),),
         ),
          const SizedBox(height: 100,),
          GestureDetector(
            onTap: (){
              _ctrl.forward();
            },
            child: const Text("正向点击", style: TextStyle(color: Colors.black),),
          )
        ],
      ),
    );
  }
}