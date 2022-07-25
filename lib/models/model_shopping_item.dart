import 'dart:convert';

class ShoppingItemModel {
  final int id;
  String name;
  String amount;
  double? price;

  ShoppingItemModel({
    required this.id,
    required this.name,
    required this.amount,
    this.price,
  });

  factory ShoppingItemModel.fromJson(Map<String, dynamic> jsonData) {
    return ShoppingItemModel(
      id: jsonData['id'],
      name: jsonData['name'],
      amount: jsonData['amount'],
      price: jsonData['price'],
    );
  }

  static Map<String, dynamic> toMap(ShoppingItemModel shoppingItem) => {
        'id': shoppingItem.id,
        'name': shoppingItem.name,
        'amount': shoppingItem.amount,
        'price': shoppingItem.price,
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
