import 'package:flutter/material.dart';
import 'package:shopping/widgets/basic_scaffold.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/homeScreen";

  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _divider = Divider(
    thickness: 1.0,
    height: 0.0,
  );
  static const _verticalMargin =
      SizedBox(height: BasicScaffold.marginValue / 2.5);
  static const _noOptionsSize = 24.0;

  static final _noOptionsColor = Colors.grey.shade300;
  static final _noOptionsTextStyle = TextStyle(
    color: _noOptionsColor,
    fontWeight: FontWeight.w600,
    fontSize: _noOptionsSize,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BasicScaffold(
      body: Column(
        children: [
          const Expanded(
            flex: 1,
            child: Center(
              child: Text(
                "Udanych zakupów!\n😊",
                style: TextStyle(
                  fontSize: 30.0,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                softWrap: false,
                overflow: TextOverflow.fade,
              ),
            ),
          ),
          _divider,
          _verticalMargin,
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _noOptionsColor,
                          width: 1.0,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.settings,
                              color: _noOptionsColor,
                              size: _noOptionsSize * 3,
                            ),
                            _verticalMargin,
                            Text(
                              "Brak opcji",
                              style: _noOptionsTextStyle,
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            ),
          ),
          _verticalMargin,
        ],
      ),
    );
  }
}
