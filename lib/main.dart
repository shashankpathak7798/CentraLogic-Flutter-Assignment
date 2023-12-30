import 'package:assignment_1/home_screen/ScreenMainScreen.dart';
import 'package:flutter/material.dart';

import 'dashboard/screens/home/ScreenHomeTab.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple,),
        useMaterial3: true,
        scaffoldBackgroundColor: MediaQuery.of(context).size.width <= 400 ? const Color.fromRGBO(250, 250, 250, 1) : null,
      ),
      home: const ScreenMainScreen(),
      initialRoute: "/home",
      routes: {
        "/home": (context) => const ScreenMainScreen(),
        "/dashboard": (context) => const ScreenHomeTab(),
      },
    );
  }
}