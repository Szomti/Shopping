import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopping/models/model_is_checked.dart';
import 'package:shopping/models/model_shopping_item.dart';
import 'package:shopping/widgets/basic_scaffold.dart';

class ShoppingTileWidget extends StatefulWidget {
  final int index;
  final List<ShoppingItemModel> Function() shoppingListCallback;
  final void Function(List<ShoppingItemModel>) shoppingListSetCallback;
  final List<IsCheckedModel> Function() isCheckedCallback;
  final void Function(List<IsCheckedModel>) isCheckedSetCallback;
  final void Function() additionalOptionsCallback;

  const ShoppingTileWidget({
    required this.index,
    required this.shoppingListCallback,
    required this.shoppingListSetCallback,
    required this.isCheckedCallback,
    required this.isCheckedSetCallback,
    required this.additionalOptionsCallback,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ShoppingTileWidgetState();
}

class _ShoppingTileWidgetState extends State<ShoppingTileWidget> {
  static const _iconSize = BasicScaffold.marginValue * 1.5;
  static const _verticalMargin =
      SizedBox(height: BasicScaffold.marginValue / 3);
  static const _itemTextStyle = TextStyle(
    fontSize: 20.0,
  );
  static final _amountTextStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    color: Colors.black.withOpacity(0.5),
  );
  static final _priceTextStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    color: Colors.green.shade900.withOpacity(0.9),
  );

  int get _index => widget.index;

  List<ShoppingItemModel> Function() get _shoppingListCallback =>
      widget.shoppingListCallback;

  void Function(List<ShoppingItemModel>) get _shoppingListSetCallback =>
      widget.shoppingListSetCallback;

  List<IsCheckedModel> Function() get _isCheckedCallback =>
      widget.isCheckedCallback;

  void Function(List<IsCheckedModel>) get _isCheckedSetCallback =>
      widget.isCheckedSetCallback;

  Function() get _additionalOptionsCallback => widget.additionalOptionsCallback;

  late List<ShoppingItemModel> tempShoppingList;
  late List<IsCheckedModel> tempIsChekedList;

  @override
  void initState() {
    super.initState();
    tempShoppingList = _shoppingListCallback();
    tempIsChekedList = _isCheckedCallback();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _verticalMargin,
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.blueAccent,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(BasicScaffold.marginValue / 2),
            color: tempIsChekedList[_index].isChecked
                ? Colors.black.withOpacity(0.2)
                : Colors.white,
          ),
          child: Row(
            children: [
              Checkbox(
                value: tempIsChekedList[_index].isChecked,
                onChanged: (value) {
                  tempIsChekedList[_index].isChecked = value!;
                  _isCheckedSetCallback(tempIsChekedList);
                },
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ..._createPriceOnItem(_index),
                    tempShoppingList.elementAt(_index).amount.trim() != ""
                        ? Text(
                            "Ilość: ${tempShoppingList.elementAt(_index).amount}",
                            style: _amountTextStyle,
                            softWrap: true,
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                          )
                        : const SizedBox.shrink(),
                    Text(
                      tempShoppingList.elementAt(_index).name,
                      style: _itemTextStyle,
                      softWrap: true,
                      maxLines: 10,
                      overflow: TextOverflow.fade,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _handleEditPress(_index),
                padding: const EdgeInsets.all(4.0),
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.edit_outlined,
                  color: Colors.blueAccent,
                  size: _iconSize,
                ),
              ),
              IconButton(
                onPressed: () => _handleRemovePress(_index),
                padding: const EdgeInsets.all(4.0),
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.remove_circle_outline,
                  color: Colors.red,
                  size: _iconSize,
                ),
              ),
            ],
          ),
        ),
        _verticalMargin,
      ],
    );
  }

  List<Widget> _createPriceOnItem(int index) {
    if (tempShoppingList.elementAt(index).price == null ||
        _additionalOptionsCallback.call().usersPrice == false) return [];
    if (tempShoppingList.elementAt(index).price! == 0.00) {
      return [];
    }
    return [
      Text(
        "Cena: ${tempShoppingList.elementAt(index).price!.toStringAsFixed(2)} zł",
        style: _priceTextStyle,
        softWrap: true,
        maxLines: 1,
        overflow: TextOverflow.clip,
      ),
    ];
  }

  void _handleRemovePress(int index) {
    tempShoppingList.removeAt(index);
    tempIsChekedList.removeAt(index);
    _shoppingListSetCallback(tempShoppingList);
    _isCheckedSetCallback(tempIsChekedList);
  }

  void _handleEditPress(int index) {
    if (tempShoppingList.elementAt(index).price == null) {
      tempShoppingList.elementAt(index).price = 0.00;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edycja"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _additionalOptionsCallback.call().usersPrice == true
                ? TextFormField(
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.only(top: 5.0, bottom: 3.0),
                      hintText: "Cena",
                      helperText: "Cena",
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    initialValue: tempShoppingList
                        .elementAt(index)
                        .price!
                        .toStringAsFixed(2),
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(',',
                          replacementString: '.'),
                      FilteringTextInputFormatter.allow(
                          RegExp(r'(^\d*\.?\d{0,2}$)')),
                    ],
                    onChanged: (price) {
                      if (price.trim() == "") price = "0";
                      tempShoppingList.elementAt(index).price =
                          double.parse(double.parse(price).toStringAsFixed(2));
                    },
                  )
                : const SizedBox.shrink(),
            TextFormField(
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.only(top: 5.0, bottom: 2.0),
                hintText: "Ilość",
                helperText: "Ilość",
              ),
              initialValue: tempShoppingList.elementAt(index).amount,
              onChanged: (amount) {
                tempShoppingList.elementAt(index).amount = amount;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.only(top: 5.0, bottom: 3.0),
                hintText: "Przedmiot*",
                helperText: "Przedmiot*",
              ),
              initialValue: tempShoppingList.elementAt(index).name,
              onChanged: (name) {
                tempShoppingList.elementAt(index).name = name;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _shoppingListSetCallback(tempShoppingList);
                    ;
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.greenAccent,
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Text("Zatwierdź"),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
