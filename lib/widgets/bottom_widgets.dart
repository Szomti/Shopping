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
            currentPage == MainPages.home ? Icons.home : Icons.home_outlined,
            "Home",
            MainPages.home,
          ),
          _createButton(
            _goToList,
            currentPage == MainPages.list
                ? Icons.view_list
                : Icons.view_list_outlined,
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
              _createIcon(icon, currentCreate),
              _createText(text, currentCreate),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createIcon(IconData icon, MainPages currentCreate) {
    return Icon(
      icon,
      size: _iconSize,
      color: _chooseIconAndTextColor(currentCreate),
    );
  }

  Widget _createText(String text, MainPages currentCreate) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.fade,
      softWrap: false,
      style: TextStyle(
        color: _chooseIconAndTextColor(currentCreate),
        fontWeight: FontWeight.w600,
        fontSize: 16.0,
      ),
    );
  }

  Color _chooseContainerColor(MainPages currentCreate) {
    if (currentPage == currentCreate) {
      return Colors.blue.shade600;
    } else {
      return Colors.blue.shade700;
    }
  }

  Color _chooseIconAndTextColor(MainPages currentCreate) {
    if (currentPage == currentCreate) {
      return Colors.white;
    } else {
      return const Color(0xFFD6d6d6);
    }
  }
}
