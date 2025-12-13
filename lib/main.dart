import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tennis_pottema3/presentation/screens/home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: GoogleFonts.rubik().fontFamily,
        scaffoldBackgroundColor: Colors.yellow,
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
