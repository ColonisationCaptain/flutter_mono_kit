import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mono_kit/mono_kit.dart';
import 'package:provider/provider.dart';

import 'pages/pages.dart';
import 'router.dart';

class App extends StatelessWidget {
  App();

  final _router = Router();

  @override
  Widget build(BuildContext context) {
    const title = 'mono_kit Demo';
    return MaterialApp(
      title: title,
      home: const HomePage(title: title),
      builder: (context, child) => MultiProvider(
        providers: const [
          TextScaleFactor(),
          // 以下2つを合わせた `BarrierKit()` もある
          BarrierControllerProvider(),
          Barrier(),
        ],
        child: child,
      ),
      onGenerateRoute: _router.onGenerateRoute,
      onUnknownRoute: (settings) => MaterialPageRoute<void>(
        settings: settings,
        builder: (context) => const NotFoundPage(),
      ),
    );
  }
}
