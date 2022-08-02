import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping/models/model_additional_options.dart';
import 'package:shopping/models/model_is_checked.dart';
import 'package:shopping/models/model_shopping_item.dart';
import 'package:shopping/widgets/basic_scaffold.dart';
import 'package:shopping/widgets/bottom_widgets.dart';

class ShoppingListScreen extends StatefulWidget {
  static const String routeName = "/shoppingList";

  final AdditionalOptionsModel? additionalOptions;

  const ShoppingListScreen(this.additionalOptions, {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  static const _divider = Divider(
    thickness: 1.0,
    height: 0.0,
  );
  static const _iconSize = BasicScaffold.marginValue * 1.5;
  static const _verticalMargin =
      SizedBox(height: BasicScaffold.marginValue / 3);
  static const _horizontalMargin =
      SizedBox(width: BasicScaffold.marginValue / 2);
  static const _borderSide = BorderSide(width: 1.0, color: Colors.blueAccent);
  static const _textFieldPadding =
      EdgeInsets.all(BasicScaffold.marginValue / 1.9);
  static const ScrollPhysics _scrollPhysics =
      BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());

  static final _itemController = TextEditingController();
  static final _amountController = TextEditingController();
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
  static const _itemTextStyle = TextStyle(
    fontSize: 20.0,
  );

  static List<ShoppingItemModel> _shoppingList = [];
  static List<IsCheckedModel> _isChecked = [];
  static int _currentIndex = 0;

  AdditionalOptionsModel? additionalOptions;

  AdditionalOptionsModel? get _additionalOptions => widget.additionalOptions;

  @override
  void initState() {
    super.initState();
    if (_additionalOptions == null) {
      setState(() {
        additionalOptions = AdditionalOptionsModel();
      });
    } else {
      setState(() {
        additionalOptions = _additionalOptions;
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasicScaffold(
      alignment: Alignment.topLeft,
      bottomWidgets: BottomWidgets(additionalOptions: additionalOptions),
      body: Column(
        children: [
          _verticalMargin,
          _verticalMargin,
          _createTopButtons(),
          _verticalMargin,
          _createTextFields(),
          _verticalMargin,
          _verticalMargin,
          _divider,
          Expanded(
            child: ListView.builder(
              physics: _scrollPhysics,
              itemCount: _shoppingList.length,
              itemBuilder: (BuildContext context, int index) {
                _currentIndex = index;
                return _createListTile(index);
              },
            ),
          ),
          additionalOptions!.usersPrice == true
              ? _createTotalPrice()
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _createTotalPrice() {
    double totalPrice = 0;
    for (var item in _shoppingList) {
      if (item.price != null) {
        totalPrice += item.price!;
      }
    }
    return Column(
      children: [
        _divider,
        _verticalMargin,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Suma: ${totalPrice.toStringAsFixed(2)} zł",
              style: _priceTextStyle.copyWith(fontSize: 20.0),
            ),
          ],
        ),
        _verticalMargin
      ],
    );
  }

  Widget _createTopButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton(
          onPressed: () => _handleAddPress(_currentIndex),
          style: OutlinedButton.styleFrom(
            padding: _textFieldPadding,
            primary: Colors.blueAccent,
            side: _borderSide,
          ),
          child: const Text("Dodaj"),
        ),
        _horizontalMargin,
        OutlinedButton(
          onPressed: () => _handleClearAll(),
          style: OutlinedButton.styleFrom(
            padding: _textFieldPadding,
            primary: Colors.red,
            side: _borderSide.copyWith(color: Colors.red),
          ),
          child: const Text("Wyczyść"),
        ),
      ],
    );
  }

  Widget _createTextFields() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: _createTextField(_amountController, "Ilość"),
        ),
        _horizontalMargin,
        Expanded(
          flex: 9,
          child: _createTextField(_itemController, "Przedmiot*"),
        ),
      ],
    );
  }

  Widget _createTextField(
    TextEditingController controller,
    String text,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: _textFieldPadding,
        border: const OutlineInputBorder(
          borderSide: _borderSide,
        ),
        labelText: text,
      ),
    );
  }

  Widget _createListTile(int index) {
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
            color: _isChecked[index].isChecked
                ? Colors.black.withOpacity(0.2)
                : Colors.white,
          ),
          child: Row(
            children: [
              Checkbox(
                value: _isChecked[index].isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    _isChecked[index].isChecked = value!;
                  });
                  saveData();
                },
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ..._createPriceOnItem(index),
                    _shoppingList.elementAt(index).amount.trim() != ""
                        ? Text(
                            "Ilość: ${_shoppingList.elementAt(index).amount}",
                            style: _amountTextStyle,
                            softWrap: true,
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                          )
                        : const SizedBox.shrink(),
                    Text(
                      _shoppingList.elementAt(index).name,
                      style: _itemTextStyle,
                      softWrap: true,
                      maxLines: 10,
                      overflow: TextOverflow.fade,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _handleEditPress(index),
                padding: const EdgeInsets.all(4.0),
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.edit_outlined,
                  color: Colors.blueAccent,
                  size: _iconSize,
                ),
              ),
              IconButton(
                onPressed: () => _handleRemovePress(index),
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
    if (_shoppingList.elementAt(index).price == null ||
        additionalOptions!.usersPrice == false) return [];
    if (_shoppingList.elementAt(index).price! == 0.00) {
      return [];
    }
    return [
      Text(
        "Cena: ${_shoppingList.elementAt(index).price!.toStringAsFixed(2)} zł",
        style: _priceTextStyle,
        softWrap: true,
        maxLines: 1,
        overflow: TextOverflow.clip,
      ),
    ];
  }

  void _handleRemovePress(int index) {
    setState(() {
      _shoppingList.removeAt(index);
      _isChecked.removeAt(index);
    });
    saveData();
  }

  void _handleEditPress(int index) {
    if (_shoppingList.elementAt(index).price == null) {
      _shoppingList.elementAt(index).price = 0.00;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edycja"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _additionalOptions!.usersPrice == true
                ? TextFormField(
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.only(top: 5.0, bottom: 3.0),
                      hintText: "Cena",
                      helperText: "Cena",
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    initialValue: _shoppingList
                        .elementAt(index)
                        .price!
                        .toStringAsFixed(2),
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(',',
                          replacementString: '.'),
                      FilteringTextInputFormatter.allow(
                          RegExp(r'(^\d*\.?\d{0,2}$)')),
                    ],
                    onChanged: (price) => setState(() {
                      if (price.trim() == "") price = "0";
                      _shoppingList.elementAt(index).price =
                          double.parse(double.parse(price).toStringAsFixed(2));
                    }),
                  )
                : const SizedBox.shrink(),
            TextFormField(
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.only(top: 5.0, bottom: 2.0),
                hintText: "Ilość",
                helperText: "Ilość",
              ),
              initialValue: _shoppingList.elementAt(index).amount,
              onChanged: (amount) => setState(() {
                _shoppingList.elementAt(index).amount = amount;
              }),
            ),
            TextFormField(
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.only(top: 5.0, bottom: 3.0),
                hintText: "Przedmiot*",
                helperText: "Przedmiot*",
              ),
              initialValue: _shoppingList.elementAt(index).name,
              onChanged: (name) => setState(() {
                _shoppingList.elementAt(index).name = name;
              }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    saveData();
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

  void _handleClearAll() {
    Widget cancelButton = TextButton(
      child: Text("Anuluj"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Zatwierdź"),
      onPressed: () {
        setState(() {
          _shoppingList = [];
          _isChecked = [];
          saveData();
        });
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Uwaga!"),
      content: Text("Czy na pewno chcesz wyczyścić CAŁĄ listę?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _handleAddPress(int index) {
    if (_itemController.text.trim() == "") return;

    ShoppingItemModel shoppingItem = ShoppingItemModel(
      id: index,
      name: _itemController.text,
      amount: _amountController.text,
    );
    setState(() {
      _isChecked.add(IsCheckedModel(isChecked: false));
      _shoppingList.add(shoppingItem);
      _itemController.text = "";
      _amountController.text = "";
    });
    saveData();
  }

  void saveData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String encodedShoppingList = ShoppingItemModel.encode(_shoppingList);
    await prefs.setString('shopping_list', encodedShoppingList);
    final String encodedIsCheckedList = IsCheckedModel.encode(_isChecked);
    await prefs.setString('is_checked_list', encodedIsCheckedList);
  }

  void loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String shoppingString = prefs.getString('shopping_list') ?? "no_list";

    setState(() {
      _shoppingList = [];
      _shoppingList = ShoppingItemModel.decode(shoppingString);
    });

    final String isCheckedString =
        prefs.getString('is_checked_list') ?? "no_list";

    setState(() {
      _isChecked = [];
      _isChecked = IsCheckedModel.decode(isCheckedString);
    });
  }
}
