import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping/models/model_shopping_item.dart';
import 'package:shopping/models/widget_configs/add_shopping_item_config.dart';
import 'package:shopping/view/shopping_item/screen_add_shopping_item.dart';
import 'package:shopping/view/shopping_list/widget_shopping_tile.dart';
import 'package:shopping/widgets/basic_scaffold.dart';

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
  static const _verticalMargin =
      SizedBox(height: BasicScaffold.marginValue / 3);
  static const _horizontalMargin =
      SizedBox(width: BasicScaffold.marginValue / 2);
  static const _borderSide = BorderSide(width: 1.0, color: Colors.blueAccent);
  static const _textFieldPadding =
      EdgeInsets.all(BasicScaffold.marginValue / 1.9);
  static const ScrollPhysics _scrollPhysics =
      BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());

  static final _priceTextStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    color: Colors.green.shade900.withOpacity(0.9),
  );

  static List<ShoppingItemModel> _shoppingList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasicScaffold(
      alignment: Alignment.topLeft,
      body: Column(
        children: [
          _verticalMargin,
          _createTopButtons(),
          _verticalMargin,
          _divider,
          _createTotalPrice(),
          Expanded(
            child: ListView.builder(
              physics: _scrollPhysics,
              itemCount: _shoppingList.length,
              itemBuilder: (BuildContext context, int index) {
                return ShoppingTileWidget(
                  index: index,
                  shoppingListCallback: () => _shoppingList,
                  shoppingListSetCallback: shoppingListSetCallback,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void shoppingListSetCallback(List<ShoppingItemModel> newList) {
    _shoppingList = newList;
    if (mounted) setState(() {});
    saveData();
  }

  double _getPriceMultiplier(ShoppingItemModel item) {
    if (item.amount == null) return 1;
    final amount = item.amount!;
    switch (item.amountType) {
      case AmountType.basic:
        return (amount * 1);
      case AmountType.gram:
        return (amount * 0.001);
      case AmountType.kilogram:
        return (amount * 1);
      case AmountType.milliliter:
        return (amount * 0.001);
      case AmountType.litre:
        return (amount * 1);
    }
  }

  Widget _createTotalPrice() {
    double totalPrice = 0;
    for (var item in _shoppingList) {
      if (item.price != null) {
        totalPrice += (item.price! * _getPriceMultiplier(item));
      }
    }
    return Column(
      children: [
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
        _verticalMargin,
        _divider,
      ],
    );
  }

  Widget _createTopButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton(
          onPressed: () => Navigator.pushNamed(
            context,
            AddShoppingItemScreen.routeName,
            arguments: AddShoppingItemConfig(
              () => _shoppingList,
              shoppingListSetCallback,
            ),
          ),
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
        _horizontalMargin,
        OutlinedButton(
          onPressed: () => _handleClearSelected(),
          style: OutlinedButton.styleFrom(
            padding: _textFieldPadding,
            primary: Colors.red,
            side: _borderSide.copyWith(color: Colors.red),
          ),
          child: const Text("Usuń Zaznaczone"),
        ),
      ],
    );
  }

  void _handleClearAll() {
    Widget cancelButton = TextButton(
      child: const Text("Anuluj"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Zatwierdź"),
      onPressed: () {
        setState(() {
          _shoppingList = [];
          saveData();
        });
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Uwaga!"),
      content: const Text("Czy na pewno chcesz wyczyścić CAŁĄ listę?"),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            continueButton,
            cancelButton,
          ],
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _handleClearSelected() {
    Widget cancelButton = TextButton(
      child: const Text("Anuluj"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Zatwierdź"),
      onPressed: () {
        setState(() {
          _shoppingList.removeWhere((element) => (element.isChecked == true));
          saveData();
        });
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Uwaga!"),
      content: const Text("Czy na pewno chcesz usunąć zaznaczone przedmioty?"),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            continueButton,
            cancelButton,
          ],
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void saveData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String encodedShoppingList = ShoppingItemModel.encode(_shoppingList);
    await prefs.setString('shopping_list', encodedShoppingList);
  }

  void loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String shoppingString = prefs.getString('shopping_list') ?? "no_list";

    setState(() {
      _shoppingList = [];
      _shoppingList = ShoppingItemModel.decode(shoppingString);
    });
  }
}
