// File: frontend/lib/app.dart
// Description: Root Flutter app wiring providers, theming, and router configuration.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'providers/board_provider.dart';
import 'router/app_router.dart';

/// Root widget of the Cosmos board service.
class CosmosBoardApp extends StatefulWidget {
  /// Default constructor.
  const CosmosBoardApp({super.key});

  @override
  State<CosmosBoardApp> createState() => _CosmosBoardAppState();
}

class _CosmosBoardAppState extends State<CosmosBoardApp> {
  GoRouter? _router;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final BoardProvider boardProvider =
        Provider.of<BoardProvider>(context, listen: false);
    _router ??= createRouter(boardProvider);
  }

  @override
  Widget build(BuildContext context) {
    if (_router == null) {
      return const SizedBox.shrink();
    }
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Cosmos Board',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
