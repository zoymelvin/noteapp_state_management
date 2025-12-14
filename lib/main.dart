import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import ini penting
import 'package:flutter_note/auth_helper.dart';
import 'package:flutter_note/features/auth/bloc/auth_bloc.dart';
import 'package:flutter_note/features/auth/bloc/auth_event.dart';
import 'package:flutter_note/features/auth/bloc/auth_state.dart';
import 'package:flutter_note/firebase_options.dart';
import 'package:flutter_note/firestore_user_helper.dart';
import 'package:flutter_note/pages/note_home_page.dart';
import 'package:flutter_note/pages/signin_page.dart';
import 'package:flutter_note/pages/singup_page.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(
        authHelper: AuthHelper(),
        fsUserHelper: FirestoreUserHelper(),
      )..add(AuthCheckRequested()),
      child: MaterialApp(
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
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
           Navigator.of(context).pushReplacementNamed('/home');
        } else if (state is AuthUnauthenticated) {
           Navigator.of(context).pushReplacementNamed('/signin');
        } else if (state is AuthError) {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: const SigninPage(),
    );
  }
}