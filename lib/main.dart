import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Wajib import
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_note/firebase_options.dart';
import 'package:flutter_note/pages/note_home_page.dart';
import 'package:flutter_note/pages/signin_page.dart';
import 'package:flutter_note/pages/singup_page.dart';
import 'package:flutter_note/features/auth/controller/auth_controller.dart'; // Import controller kita

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true);

  // Bungkus root dengan ProviderScope
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Note',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lime),
      ),
      home: const AuthWrapper(),
      routes: {
        '/home': (context) => const NoteHomePage(),
        '/signin': (context) => const SigninPage(),
        '/signup': (context) => const SignupPage(),
      },
    );
  }
}

// Widget khusus untuk mengatur navigasi Login/Home
class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Kita pantau stream user dari authStateProvider
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user != null) return const NoteHomePage();
        return const SigninPage();
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, trace) => Scaffold(body: Center(child: Text('Error: $e'))),
    );
  }
}