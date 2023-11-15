import 'package:flutter/material.dart';

class StandardSearchBarInner extends StatelessWidget
    implements PreferredSizeWidget {

  final Function(String) callback;

  final String hint;
  final bool autofocus;

  const StandardSearchBarInner({Key? key, required this.callback, required this.hint, this.autofocus = true}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(35 + 8 * 2);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
                height: 35,
                child: Material(
                  color: Colors.transparent,
                  child: TextField(
                    autofocus: autofocus,
                    enabled: true,
                    cursorColor: Colors.blue,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    onChanged: (str) => _doSearch(context, str),
                    onSubmitted: (str) {
                      //提交后,收起键盘
                      FocusScope.of(context).requestFocus(FocusNode());
                      callback(str);
                    },
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xff292929),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        border: const UnderlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius:
                              BorderRadius.all(Radius.circular(35 / 2)),
                        ),
                        hintText: hint,
                        hintStyle: const TextStyle(fontSize: 14, color: Colors.white70)),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  void _doSearch(BuildContext context, String str) {

  }
}
