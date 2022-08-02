import 'package:flutter/material.dart';

class BasicScaffold extends StatefulWidget {
  static const double marginValue = 16.0;
  final Alignment? alignment;
  final Widget? bottomWidgets;
  final Widget body;

  const BasicScaffold({
    this.alignment,
    this.bottomWidgets,
    required this.body,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BasicScaffoldState();
}

class _BasicScaffoldState extends State<BasicScaffold> {
  Alignment? get alignment => widget.alignment;

  Widget get bottomWidgets => widget.bottomWidgets ?? const SizedBox.shrink();

  Widget get body => widget.body;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: BasicScaffold.marginValue),
                    child: Column(
                      children: [
                        Expanded(
                          child: body,
                        ),
                      ],
                    ),
                  ),
                ),
                bottomWidgets,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
