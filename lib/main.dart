import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/app_state.dart';
import 'core/theme.dart';
import 'screens/love_os_home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => LoveAppState(),
      child: const LoveOSApp(),
    ),
  );
}

class LoveOSApp extends StatelessWidget {
  const LoveOSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Secret Message ❤️',
      debugShowCheckedModeBanner: false,
      theme: LoveTheme.darkTheme,
      home: const LoveOSHome(),
    );
  }
}
