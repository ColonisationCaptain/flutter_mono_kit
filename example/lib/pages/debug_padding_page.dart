import 'package:flutter/material.dart';
import 'package:mono_kit/mono_kit.dart';

class DebugPaddingPage extends StatelessWidget {
  const DebugPaddingPage({Key key}) : super(key: key);

  static const routeName = '/debug_padding';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return DebugPadding(
//      showPadding: false,
//      showViewPadding: false,
//      showViewInsets: false,
//      showSize: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(routeName),
        ),
        body: UnfocusOnTap(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 48),
            children: List.filled(
              10,
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
        ),
        bottomNavigationBar: BottomAppBar(
          color: colorScheme.secondaryVariant,
          child: Text(
            'bottomNavigationBar',
            textAlign: TextAlign.center,
            style: theme.primaryTextTheme.bodyText2,
          ),
        ),
        bottomSheet: Container(
          width: double.infinity,
          color: colorScheme.secondary,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: const Text(
            'bottomSheet',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
