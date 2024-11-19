import 'package:demo/provider/user_provider.dart';
import 'package:demo/screens/chat_screen.dart';
import 'package:demo/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider()..fetchUser()
        )
      ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.user != null) {
            return ChatScreen(
                chatPartnerId: 'targetUserId'
            );
          }
          return SigninScreen();
        },
      ),
    );
  }
}

