// File: lib/main.dart | Description: CosmosAI 멀티 게시판 애플리케이션 진입점.
import 'package:flutter/material.dart';

import 'app/app.dart';

Future<void> main() async {
  // 🚀 플러터 바인딩 초기화 후 앱 실행
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CosmosApp());
}
