import 'package:flutter/material.dart';
import 'package:shopping/models/model_additional_options.dart';
import 'package:shopping/shared_preferences.dart';
import 'package:shopping/widgets/basic_scaffold.dart';
import 'package:shopping/widgets/bottom_widgets.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/homeScreen";

  final AdditionalOptionsModel? additionalOptions;

  const HomeScreen(
    this.additionalOptions, {
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _divider = Divider(
    thickness: 1.0,
  );
  static const ScrollPhysics _scrollPhysics =
      BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());

  AdditionalOptionsModel _additionalOptions =
      AdditionalOptionsModel(usersPrice: false);

  AdditionalOptionsModel? get additionalOptionsModelBack =>
      widget.additionalOptions;

  @override
  void initState() {
    super.initState();
    if (additionalOptionsModelBack != null) {
      _additionalOptions = additionalOptionsModelBack!;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => loadData());
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
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    physics: _scrollPhysics,
                    shrinkWrap: true,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blueAccent,
                            width: 0.5,
                          ),
                        ),
                        child: CheckboxListTile(
                          title: const Text("Ceny [BETA]"),
                          value: _additionalOptions.usersPrice,
                          onChanged: (bool? value) {
                            setState(() {
                              _additionalOptions.usersPrice = value!;
                            });
                            _saveData();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          BottomWidgets(additionalOptions: _additionalOptions),
        ],
      ),
    );
  }

  void _saveData() async {
    SharedPref sharedPref = SharedPref();
    sharedPref.save("additional_options", _additionalOptions);
  }

  loadData() async {
    SharedPref sharedPref = SharedPref();
    try {
      AdditionalOptionsModel additionalOptions =
          AdditionalOptionsModel.fromJson(
              await sharedPref.read("additional_options"));
      setState(() {
        _additionalOptions = additionalOptions;
      });
    } catch (_) {}
  }
}
