import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/features/home/home_page.dart';
import 'package:myapp/features/sign_up/sign_up_page.dart';
import 'package:myapp/firebase_options.dart';
import 'package:myapp/services/shared_preference/prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: startPage(),
    );
  }
}

Widget startPage() {
  return StreamBuilder(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        Prefs.saveUserId(snapshot.data!.uid);
        return AllPostPage();
      } else {
        Prefs.deleteUserId();
        return SignUpPage();
      }
    },
  );
}
