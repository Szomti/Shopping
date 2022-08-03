import 'package:shopping/models/model_shopping_item.dart';

class AddShoppingItemConfig {
  List<ShoppingItemModel> Function() shoppingListCallback;
  void Function(List<ShoppingItemModel>) shoppingListSetCallback;

  AddShoppingItemConfig(
    this.shoppingListCallback,
    this.shoppingListSetCallback,
  );
}
