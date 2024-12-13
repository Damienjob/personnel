import 'package:projet/ui/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDxBLc6L4PYKYyYZpUvwDqjVbyUhJbrX4Y",
      projectId: "facturaapp-28d00",
      messagingSenderId: "1009277934311",
      appId: "1:1009277934311:android:dcf93efa0673f4e853e042",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: SplashScreen());
  }
}
