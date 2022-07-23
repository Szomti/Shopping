import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping/models/model_is_checked.dart';
import 'package:shopping/models/model_shopping_item.dart';
import 'package:shopping/widgets/basic_scaffold.dart';
import 'package:shopping/widgets/bottom_widgets.dart';

class ShoppingListScreen extends StatefulWidget {
  static const String routeName = "/shoppingList";

  const ShoppingListScreen({Key? key}) : super(key: key);

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

  static final _itemController = TextEditingController();
  static final _amountController = TextEditingController();

  static List<ShoppingItemModel> _shoppingList = [];
  static List<IsCheckedModel> _isChecked = [];
  static int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadData());
  }

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
                onPressed: () => _handleAddPress(_currentIndex),
                style: OutlinedButton.styleFrom(
                  padding: _textFieldPadding,
                  primary: Colors.blueAccent,
                  side: _borderSide,
                ),
                child: const Text("Add"),
              ),
              _horizontalMargin,
              OutlinedButton(
                onPressed: () => _handleClearAll(),
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
                flex: 9,
                child: TextField(
                  controller: _itemController,
                  textInputAction: TextInputAction.next,
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
          _verticalMargin,
          _divider,
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: _shoppingList.length,
              itemBuilder: (BuildContext context, int index) {
                _currentIndex = index;
                return Column(
                  children: [
                    _verticalMargin,
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blueAccent,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(
                            BasicScaffold.marginValue / 2),
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_shoppingList.elementAt(index).name),
                              Text(_shoppingList.elementAt(index).amount),
                            ],
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () => _handleEditPress(index),
                            icon: const Icon(
                              Icons.edit_outlined,
                              color: Colors.blueAccent,
                              size: _iconSize,
                            ),
                          ),
                          IconButton(
                            onPressed: () => _handleRemovePress(index),
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
              },
            ),
          ),
          const BottomWidgets(),
        ],
      ),
    );
  }

  void _handleRemovePress(int index) {
    setState(() {
      _shoppingList.removeAt(index);
      _isChecked.removeAt(index);
    });
    saveData();
  }

  void _handleEditPress(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(helperText: "Item"),
              initialValue: _shoppingList.elementAt(index).name,
              onChanged: (name) => setState(() {
                _shoppingList.elementAt(index).name = name;
              }),
            ),
            TextFormField(
              decoration: InputDecoration(helperText: "Amount"),
              initialValue: _shoppingList.elementAt(index).amount,
              onChanged: (amount) => setState(() {
                _shoppingList.elementAt(index).amount = amount;
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
                  child: Text("Confirm"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.greenAccent,
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleClearAll() {
    setState(() {
      _shoppingList = [];
      _isChecked = [];
    });
    saveData();
  }

  void _handleAddPress(int index) {
    if (_itemController.text.trim() == "") return;
    if (_amountController.text.trim() == "") {
      _amountController.text = " ";
    }
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
