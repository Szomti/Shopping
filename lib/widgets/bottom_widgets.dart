import 'package:flutter/material.dart';
import 'package:shopping/models/model_additional_options.dart';
import 'package:shopping/view/shopping_list/screen_shopping_list.dart';
import 'package:shopping/widgets/basic_scaffold.dart';

class BottomWidgets extends StatefulWidget {
  final AdditionalOptionsModel? additionalOptions;

  const BottomWidgets({
    this.additionalOptions,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BottomWidgetsState();
}

class _BottomWidgetsState extends State<BottomWidgets> {
  static const _divider = Divider(
    thickness: 1.0,
    height: 0.0,
  );
  static const _iconSize = 24.0;
  static const _iconColor = Colors.white;

  static final _pageButtonStyle = ElevatedButton.styleFrom(
    splashFactory: NoSplash.splashFactory,
    primary: Colors.blue.shade700,
    fixedSize: const Size.fromWidth(BasicScaffold.marginValue * 5),
    padding: const EdgeInsets.all(BasicScaffold.marginValue / 3),
  );

  AdditionalOptionsModel? get additionalOptions => widget.additionalOptions;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _divider,
        ButtonBar(
          alignment: MainAxisAlignment.center,
          children: [
            _createButton(_goToHome, Icons.home_outlined, "Home"),
            _createButton(_goToList, Icons.list_alt_outlined, "List"),
          ],
        ),
      ],
    );
  }

  void _goToHome() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      "/homeScreen",
      (r) => false,
      arguments: additionalOptions,
    );
  }

  void _goToList() {
    Navigator.pushNamed(
      context,
      ShoppingListScreen.routeName,
      arguments: additionalOptions,
    );
  }

  Widget _createButton(void Function() fun, IconData icon, String text) {
    return ElevatedButton(
      onPressed: fun,
      style: _pageButtonStyle,
      child: Column(
        children: [
          _createIcon(icon),
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
