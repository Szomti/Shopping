import 'package:flutter/material.dart';
import 'package:shopping/models/model_additional_options.dart';
import 'package:shopping/view/main/screen_home.dart';
import 'package:shopping/view/shopping_list/screen_shopping_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: HomeScreen.routeName,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case HomeScreen.routeName:
            {
              return PageRouteBuilder(
                pageBuilder: (a, b, c) => HomeScreen(
                  settings.arguments as AdditionalOptionsModel?,
                ),
              );
            }
          case ShoppingListScreen.routeName:
            {
              return PageRouteBuilder(
                pageBuilder: (a, b, c) => ShoppingListScreen(
                  settings.arguments as AdditionalOptionsModel?,
                ),
              );
            }
          default:
            {
              return PageRouteBuilder(
                pageBuilder: (a, b, c) => HomeScreen(
                  settings.arguments as AdditionalOptionsModel?,
                ),
              );
            }
        }
      },
    );
  }
}
