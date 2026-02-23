import 'package:flutter/material.dart';

import 'package:weather/network/remote/dio_helper.dart';
import 'package:weather/view/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  diohelper.init();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
