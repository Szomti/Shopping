import 'package:flutter/material.dart';
import 'package:shopping/widgets/bottom_widgets.dart';

class BasicScaffold extends StatefulWidget {
  static const double marginValue = 16.0;
  final Alignment? alignment;
  final Widget? bottomWidgets;
  final Widget body;
  final bool showBottomWidgets;

  const BasicScaffold({
    this.alignment,
    this.bottomWidgets,
    required this.body,
    Key? key,
  })  : showBottomWidgets = true,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _BasicScaffoldState();
}

class _BasicScaffoldState extends State<BasicScaffold> {
  Alignment? get alignment => widget.alignment;

  Widget get bottomWidgets => widget.bottomWidgets ?? const BottomWidgets();

  Widget get body => widget.body;

  bool get showBottomWidgets => widget.showBottomWidgets;

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
                showBottomWidgets ? bottomWidgets : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
