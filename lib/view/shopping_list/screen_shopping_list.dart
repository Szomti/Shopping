import 'package:flutter/material.dart';
import 'package:shopping/widgets/basic_scaffold.dart';
import 'package:shopping/widgets/bottom_widgets.dart';

class ShoppingListScreen extends StatefulWidget {
  static const String routeName = "/shoppingList";

  const ShoppingListScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  static const _divider = Divider(thickness: 1.0);
  static const _verticalMargin =
      SizedBox(height: BasicScaffold.marginValue / 3);
  static const _horizontalMargin =
      SizedBox(width: BasicScaffold.marginValue / 2);
  static const _borderSide = BorderSide(width: 1.0, color: Colors.blueAccent);
  static const _textFieldPadding =
      EdgeInsets.all(BasicScaffold.marginValue / 1.9);

  static final _itemController = TextEditingController();
  static final _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BasicScaffold(
      alignment: Alignment.topLeft,
      body: Column(
        children: [
          _verticalMargin,
          _verticalMargin,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: _textFieldPadding,
                  primary: Colors.blueAccent,
                  side: _borderSide,
                ),
                child: const Text("Add"),
              ),
              _horizontalMargin,
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: _textFieldPadding,
                  primary: Colors.red,
                  side: _borderSide.copyWith(color: Colors.red),
                ),
                child: const Text("Clear All"),
              ),
            ],
          ),
          _verticalMargin,
          Row(
            children: [
              Expanded(
                flex: 7,
                child: TextField(
                  controller: _itemController,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: _textFieldPadding,
                    border: OutlineInputBorder(
                      borderSide: _borderSide,
                    ),
                    labelText: "Item",
                  ),
                ),
              ),
              _horizontalMargin,
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: _textFieldPadding,
                    border: OutlineInputBorder(
                      borderSide: _borderSide,
                    ),
                    labelText: "Amount",
                  ),
                ),
              ),
            ],
          ),
          _verticalMargin,
          _divider,
          Expanded(
            child: Column(),
          ),
          const BottomWidgets(),
        ],
      ),
    );
  }
}
