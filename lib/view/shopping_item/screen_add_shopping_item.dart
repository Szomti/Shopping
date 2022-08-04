import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  static const _horizontalMargin = SizedBox(width: BasicScaffold.marginValue);
  static const _borderSide = BorderSide(width: 1.0, color: Colors.blueAccent);
  static const _textFieldPadding =
      EdgeInsets.all(BasicScaffold.marginValue / 1.9);
  static const _headerTextStyle = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );
  static const _itemErrorText = "To pole musi być wypełnione!";
  static const _textFieldInnerSize = 16.0;
  static final _textFieldTextStyle = TextStyle(
    fontSize: _textFieldInnerSize,
    color: Colors.black.withOpacity(0.9),
  );

  static final _amountInputFormatter = [
    FilteringTextInputFormatter.deny(',', replacementString: '.'),
    FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,3})')),
  ];

  final _priceController = TextEditingController();
  final _itemController = TextEditingController();
  final _amountController = TextEditingController();

  List<ShoppingItemModel> Function() get _shoppingListCallback =>
      widget.addShoppingItemConfig.shoppingListCallback;

  void Function(List<ShoppingItemModel>) get _shoppingListSetCallback =>
      widget.addShoppingItemConfig.shoppingListSetCallback;

  late List<ShoppingItemModel> tempShoppingList;

  AmountType _chosenAmountType = AmountType.basic;

  bool _itemFieldNotValid = false;

  @override
  void initState() {
    super.initState();
    tempShoppingList = _shoppingListCallback();
  }

  @override
  void dispose() {
    _priceController.dispose();
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
                _createPriceTextField("Cena"),
                _verticalMargin,
                InputDecorator(
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: _textFieldPadding,
                    border: OutlineInputBorder(
                      borderSide: _borderSide,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<AmountType>(
                      isDense: true,
                      icon: const FittedBox(
                        child: Icon(Icons.expand_more_outlined),
                      ),
                      dropdownColor: Colors.grey.shade100,
                      value: _chosenAmountType,
                      style: _textFieldTextStyle,
                      items: AmountType.values.map((AmountType amountType) {
                        return DropdownMenuItem<AmountType>(
                          alignment: Alignment.bottomLeft,
                          value: amountType,
                          child: Text(
                            amountType.getFullString,
                          ),
                        );
                      }).toList(),
                      onChanged: (AmountType? newValue) {
                        _chosenAmountType = newValue!;
                        if (mounted) setState(() {});
                      },
                    ),
                  ),
                ),
                _verticalMargin,
                _createTextField(
                  _amountController,
                  "Ilość",
                  inputFormatters: _amountInputFormatter,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                _verticalMargin,
                _createTextField(
                  _itemController,
                  "Przedmiot*",
                  errorText: _itemFieldNotValid ? _itemErrorText : null,
                ),
                _verticalMargin,
              ],
            ),
          ),
          _verticalMargin,
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
                child: const Text(
                  "Zatwierdź",
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              _horizontalMargin,
              OutlinedButton(
                onPressed: () => _handleCancelPress(),
                style: OutlinedButton.styleFrom(
                  padding: _textFieldPadding,
                  primary: Colors.red,
                  side: _borderSide.copyWith(color: Colors.red),
                ),
                child: const Text(
                  "Anuluj",
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ],
          ),
          _verticalMargin,
        ],
      ),
    );
  }

  Widget _createPriceTextField(String text) {
    return TextField(
      controller: _priceController,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: _textFieldPadding,
        border: const OutlineInputBorder(
          borderSide: _borderSide,
        ),
        labelStyle: _textFieldTextStyle,
        labelText: text,
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.deny(',', replacementString: '.'),
        FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2}$)')),
      ],
    );
  }

  Widget _createTextField(
    TextEditingController controller,
    String text, {
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
    String? errorText,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: _textFieldPadding,
        border: const OutlineInputBorder(
          borderSide: _borderSide,
        ),
        labelStyle: _textFieldTextStyle,
        labelText: text,
        errorText: errorText,
      ),
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
    );
  }

  void _handleCancelPress() {
    if (mounted) Navigator.pop(context);
  }

  void _handleAddPress() {
    _itemFieldNotValid = false;
    if (_itemController.text.trim().isEmpty) {
      _itemFieldNotValid = true;
      return;
    }
    ShoppingItemModel shoppingItem = ShoppingItemModel(
      name: _itemController.text,
      amount: double.tryParse(_amountController.text),
      amountType: _chosenAmountType,
      price: double.tryParse(_priceController.text),
      isChecked: false,
    );
    tempShoppingList.add(shoppingItem);
    _shoppingListSetCallback(tempShoppingList);
    if (mounted) Navigator.pop(context);
  }
}
