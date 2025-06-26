import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/home/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Optional delay for preview
  Future.delayed(const Duration(seconds: 2), () {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Robert Kayanja Ministries',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        // This is the theme of your application.

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Check Pastors'),
    );
  }
}
