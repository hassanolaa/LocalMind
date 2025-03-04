import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gpt/core/shared/get_storage.dart';
import 'package:gpt/features/home/ui/screens/mainscreen.dart';

import 'features/home/data/objectbox_service.dart';

late ObjectBox objectbox;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  objectbox = await ObjectBox.create();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MainScreen(),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
