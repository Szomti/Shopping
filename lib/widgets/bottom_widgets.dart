import 'package:flutter/material.dart';
import 'package:shopping/view/shopping_list/screen_shopping_list.dart';
import 'package:shopping/widgets/basic_scaffold.dart';

class BottomWidgets extends StatefulWidget {
  const BottomWidgets({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BottomWidgetsState();
}

class _BottomWidgetsState extends State<BottomWidgets> {
  static const _iconSize = 24.0;
  static const _iconColor = Colors.white;

  static final _pageButtonStyle = ElevatedButton.styleFrom(
    splashFactory: NoSplash.splashFactory,
    primary: Colors.blue.shade700,
    fixedSize: const Size.fromWidth(BasicScaffold.marginValue * 5),
    padding: const EdgeInsets.all(BasicScaffold.marginValue / 3),
  );

  @override
  Widget build(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: [
        _createButton(_goToHome, "Home"),
        _createButton(_goToList, "List"),
      ],
    );
  }

  void _goToHome() {
    Navigator.pushNamedAndRemoveUntil(context, "/homeScreen", (r) => false);
  }

  void _goToList() {
    Navigator.pushNamed(context, ShoppingListScreen.routeName);
  }

  Widget _createButton(void Function() fun, String text) {
    return ElevatedButton(
      onPressed: fun,
      style: _pageButtonStyle,
      child: Column(
        children: [
          _createIcon(Icons.list_alt_outlined),
          Text(text),
        ],
      ),
    );
  }

  Widget _createIcon(IconData icon) {
    return Icon(
      icon,
      size: _iconSize,
      color: _iconColor,
    );
  }
}
