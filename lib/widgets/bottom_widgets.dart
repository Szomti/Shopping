import 'package:flutter/material.dart';
import 'package:shopping/models/model_additional_options.dart';
import 'package:shopping/view/shopping_list/screen_shopping_list.dart';

enum MainPages { home, list }

class BottomWidgets extends StatefulWidget {
  final AdditionalOptionsModel Function()? additionalOptions;

  const BottomWidgets({
    this.additionalOptions,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BottomWidgetsState();
}

class _BottomWidgetsState extends State<BottomWidgets> {
  static const _iconSize = 30.0;
  static const _iconColor = Colors.white;

  static MainPages currentPage = MainPages.home;

  AdditionalOptionsModel Function()? get additionalOptions =>
      widget.additionalOptions;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64.0,
      child: Row(
        children: [
          _createButton(
            _goToHome,
            Icons.home_outlined,
            "Home",
            MainPages.home,
          ),
          _createButton(
            _goToList,
            Icons.list_alt_outlined,
            "Lista",
            MainPages.list,
          ),
        ],
      ),
    );
  }

  void _goToHome() {
    if (!mounted) return;
    setState(() {
      currentPage = MainPages.home;
    });
    Navigator.pushNamedAndRemoveUntil(
      context,
      "/homeScreen",
      (r) => false,
    );
  }

  void _goToList() {
    if (!mounted) return;
    setState(() {
      currentPage = MainPages.list;
    });
    Navigator.pushNamed(
      context,
      ShoppingListScreen.routeName,
      arguments: additionalOptions,
    );
  }

  Widget _createButton(
    void Function() fun,
    IconData icon,
    String text,
    MainPages currentCreate,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: fun,
        child: Container(
          alignment: Alignment.center,
          color: _chooseContainerColor(currentCreate),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _createIcon(icon),
              _createText(text),
            ],
          ),
        ),
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

  Widget _createText(String text) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.fade,
      softWrap: false,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 16.0,
      ),
    );
  }

  Color _chooseContainerColor(MainPages currentCreate) {
    if (currentPage == currentCreate) {
      return Colors.blue;
    } else {
      return Colors.blue.shade700;
    }
  }
}
