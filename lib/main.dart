import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hive_latihan/hive/config.dart';
import 'package:hive_latihan/hive/dao/contact.dart';
import 'package:hive_latihan/view/home_page.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ContactAdapter());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
