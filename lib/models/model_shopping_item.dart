import 'dart:convert';

enum AmountType {
  basic,
  gram,
  kilogram,
  milliliter,
  litre,
}

extension AmountTypeExtension on AmountType {
  String get getShortString {
    switch (this) {
      case AmountType.basic:
        return "szt";
      case AmountType.gram:
        return "g";
      case AmountType.kilogram:
        return "kg";
      case AmountType.milliliter:
        return "ml";
      case AmountType.litre:
        return "L";
    }
  }

  String get getFullString {
    switch (this) {
      case AmountType.basic:
        return "Sztuki [szt]";
      case AmountType.gram:
        return "Gramy [g]";
      case AmountType.kilogram:
        return "Kilogramy [kg]";
      case AmountType.milliliter:
        return "Mililitry [ml]";
      case AmountType.litre:
        return "Litry [L]";
    }
  }
}

class ShoppingItemModel {
  String name;
  double? amount;
  AmountType amountType;
  double? price;
  bool isChecked;

  ShoppingItemModel({
    required this.name,
    this.amount,
    this.amountType = AmountType.basic,
    this.price,
    this.isChecked = false,
  });

  factory ShoppingItemModel.fromJson(Map<String, dynamic> jsonData) {
    return ShoppingItemModel(
      name: jsonData['name'],
      amount: jsonData['amount'],
      amountType: AmountType.values.byName(jsonData['amountType']),
      price: jsonData['price'],
      isChecked: jsonData['isChecked'],
    );
  }

  static Map<String, dynamic> toMap(ShoppingItemModel shoppingItem) => {
        'name': shoppingItem.name,
        'amount': shoppingItem.amount,
        'amountType': shoppingItem.amountType.name,
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
