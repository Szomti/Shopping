import 'package:flutter/material.dart';
import 'package:shopping/models/model_shopping_item.dart';
import 'package:shopping/models/widget_configs/add_shopping_item_config.dart';
import 'package:shopping/widgets/basic_scaffold.dart';

class AddShoppingItemScreen extends StatefulWidget {
  static const routeName = "/addShoppingItem";

  final AddShoppingItemConfig addShoppingItemConfig;

  const AddShoppingItemScreen(
    this.addShoppingItemConfig, {
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddShoppingItemScreenState();
}

class _AddShoppingItemScreenState extends State<AddShoppingItemScreen> {
  static const _divider = Divider(
    thickness: 1.0,
    height: 0.0,
  );
  static const _verticalMargin =
      SizedBox(height: BasicScaffold.marginValue / 1.5);
  static const _horizontalMargin =
      SizedBox(width: BasicScaffold.marginValue / 2);
  static const _borderSide = BorderSide(width: 1.0, color: Colors.blueAccent);
  static const _textFieldPadding =
      EdgeInsets.all(BasicScaffold.marginValue / 1.9);
  static const _headerTextStyle = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  final _itemController = TextEditingController();
  final _amountController = TextEditingController();

  List<ShoppingItemModel> Function() get _shoppingListCallback =>
      widget.addShoppingItemConfig.shoppingListCallback;

  void Function(List<ShoppingItemModel>) get _shoppingListSetCallback =>
      widget.addShoppingItemConfig.shoppingListSetCallback;

  late List<ShoppingItemModel> tempShoppingList;

  @override
  void initState() {
    super.initState();
    tempShoppingList = _shoppingListCallback();
  }

  @override
  void dispose() {
    _itemController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasicScaffold(
      alignment: Alignment.topCenter,
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                _verticalMargin,
                const Text(
                  "Nowy przedmiot",
                  style: _headerTextStyle,
                ),
                _verticalMargin,
                _divider,
                _verticalMargin,
                // _createPriceTextField(),
                _createTextField(_amountController, "Ilość"),
                _createTextField(_itemController, "Przedmiot*"),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () => _handleAddPress(),
                style: OutlinedButton.styleFrom(
                  padding: _textFieldPadding,
                  primary: Colors.blueAccent,
                  side: _borderSide,
                ),
                child: const Text("Zatwierdź"),
              ),
              _horizontalMargin,
              OutlinedButton(
                onPressed: () => _handleCancelPress(),
                style: OutlinedButton.styleFrom(
                  padding: _textFieldPadding,
                  primary: Colors.red,
                  side: _borderSide.copyWith(color: Colors.red),
                ),
                child: const Text("Anuluj"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget _createPriceTextField() {
  //   return TextField(
  //     decoration: const InputDecoration(
  //       isDense: true,
  //       contentPadding: EdgeInsets.only(top: 5.0, bottom: 3.0),
  //       hintText: "Cena",
  //       helperText: "Cena",
  //     ),
  //     keyboardType: const TextInputType.numberWithOptions(decimal: true),
  //     inputFormatters: [
  //       FilteringTextInputFormatter.deny(',', replacementString: '.'),
  //       FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2}$)')),
  //     ],
  //   );
  // }

  Widget _createTextField(
    TextEditingController controller,
    String text,
  ) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: BasicScaffold.marginValue / 2),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: _textFieldPadding,
          border: const OutlineInputBorder(
            borderSide: _borderSide,
          ),
          labelText: text,
        ),
      ),
    );
  }

  void _handleCancelPress() {
    if (mounted) Navigator.pop(context);
  }

  void _handleAddPress() {
    if (_itemController.text.trim() == "") return;

    ShoppingItemModel shoppingItem = ShoppingItemModel(
      name: _itemController.text,
      amount: _amountController.text,
      isChecked: false,
    );
    tempShoppingList.add(shoppingItem);
    _shoppingListSetCallback(tempShoppingList);
    if (mounted) Navigator.pop(context);
  }
}
