// File: frontend/lib/main.dart
// Description: Application entry point bootstrapping providers and launching the Cosmos board app.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'providers/auth_provider.dart';
import 'providers/board_provider.dart';

void main() {
  // Ensure Flutter binding is initialized before provider setup.
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: <ChangeNotifierProvider<dynamic>>[
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<BoardProvider>(create: (_) => BoardProvider()),
      ],
      child: const CosmosBoardApp(),
    ),
  );
}
