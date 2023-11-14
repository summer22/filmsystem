import 'package:flutter/material.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class ItemModel {
  String title;
  String code;
  ItemModel(this.title, this.code);
}

class _LoginPageState extends State<LoginPage> {

  late List<ItemModel> menuItems;
  final CustomPopupMenuController _controller = CustomPopupMenuController();

  @override
  void initState() {
    menuItems = [
      ItemModel('简体中文',"zh_CN"),
      ItemModel('English',"en_US"),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          CustomPopupMenu(
            child: Container(
              child: Icon(Icons.add_circle_outline, color: Colors.black),
              margin: EdgeInsets.only(right: 100),
            ),
            menuBuilder: () =>
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    color: const Color(0xFF4C4C4C),
                    child: IntrinsicWidth(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: menuItems
                            .map(
                              (item) =>
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  _controller.hideMenu();
                                },
                                child: Container(
                                  height: 40,
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Container(
                                    margin: EdgeInsets.only(left: 10),
                                    padding:
                                    EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                      item.title,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        ).toList(),
                      ),
                    ),
                  ),
                ),
            pressType: PressType.singleClick,
            verticalMargin: 10,
            controller: _controller,
          ),
        ],
      ),
      body: Center(
        child: Text("login"),
      )
    );
  }
}
