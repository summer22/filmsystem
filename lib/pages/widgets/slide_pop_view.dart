import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    // 创建动画控制器
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // 创建一个Offset的Tween
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(_controller);
  }

  // 显示弹框
  void _showDialog() {
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        return SlideTransition(
          position: _offsetAnimation,
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 250.0,
              height: 150.0,
              color: Colors.white,
              child: Center(
                child: Text(
                  'Slide Dialog',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
          ),
        );
      },
    );
    // 执行弹框动画
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Slide Dialog Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _showDialog,
          child: Text('Show Slide Dialog'),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
