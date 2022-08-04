import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopping/models/widget_configs/add_shopping_item_config.dart';
import 'package:shopping/view/main/screen_home.dart';
import 'package:shopping/view/shopping_item/screen_add_shopping_item.dart';
import 'package:shopping/view/shopping_list/screen_shopping_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      initialRoute: HomeScreen.routeName,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case HomeScreen.routeName:
            {
              return PageRouteBuilder(
                pageBuilder: (a, b, c) => const HomeScreen(),
              );
            }
          case ShoppingListScreen.routeName:
            {
              return PageRouteBuilder(
                pageBuilder: (a, b, c) => const ShoppingListScreen(),
              );
            }
          case AddShoppingItemScreen.routeName:
            {
              return PageRouteBuilder(
                pageBuilder: (a, b, c) => AddShoppingItemScreen(
                  settings.arguments as AddShoppingItemConfig,
                ),
              );
            }
          default:
            {
              return PageRouteBuilder(
                pageBuilder: (a, b, c) => const HomeScreen(),
              );
            }
        }
      },
    );
  }
}
