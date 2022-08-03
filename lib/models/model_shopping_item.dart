import 'dart:convert';

class ShoppingItemModel {
  String name;
  String amount;
  double? price;
  bool isChecked;

  ShoppingItemModel({
    required this.name,
    required this.amount,
    this.price,
    this.isChecked = false,
  });

  factory ShoppingItemModel.fromJson(Map<String, dynamic> jsonData) {
    return ShoppingItemModel(
      name: jsonData['name'],
      amount: jsonData['amount'],
      price: jsonData['price'],
      isChecked: jsonData['isChecked'],
    );
  }

  static Map<String, dynamic> toMap(ShoppingItemModel shoppingItem) => {
        'name': shoppingItem.name,
        'amount': shoppingItem.amount,
        'price': shoppingItem.price,
        'isChecked': shoppingItem.isChecked,
      };

  static String encode(List<ShoppingItemModel> shoppingList) => json.encode(
        shoppingList
            .map<Map<String, dynamic>>(
                (shoppingItem) => ShoppingItemModel.toMap(shoppingItem))
            .toList(),
      );

  static List<ShoppingItemModel> decode(String shoppingList) =>
      (json.decode(shoppingList) as List<dynamic>)
          .map<ShoppingItemModel>((item) => ShoppingItemModel.fromJson(item))
          .toList();
}
