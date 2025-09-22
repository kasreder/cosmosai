// File: lib/app/app.dart | Description: 전역 Provider와 라우터를 초기화하는 최상위 위젯.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_theme.dart';
import '../data/datasources/dummy_data_source.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/board_repository.dart';
import '../models/board_category.dart';
import '../providers/auth_provider.dart';
import '../providers/view_count_provider.dart';
import 'router/app_router.dart';

class CosmosApp extends StatefulWidget {
  const CosmosApp({super.key});

  @override
  State<CosmosApp> createState() => _CosmosAppState();
}

class _CosmosAppState extends State<CosmosApp> {
  late final DummyDataSource _dummyDataSource;
  late final BoardRepository _boardRepository;
  late final AuthRepository _authRepository;
  late final ViewCountProvider _viewCountProvider;
  late final AuthProvider _authProvider;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _dummyDataSource = DummyDataSource();
    _boardRepository = BoardRepository(_dummyDataSource);
    _authRepository = AuthRepository(_dummyDataSource);
    _viewCountProvider = ViewCountProvider(_boardRepository);
    _authProvider = AuthProvider(_authRepository);
    _appRouter = AppRouter();
    // 🚀 초기 데이터 프리로드 (홈 화면 요약용)
    Future<void>.delayed(Duration.zero, _viewCountProvider.prefetchForHome);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <ChangeNotifierProvider<dynamic>>[
        ChangeNotifierProvider<AuthProvider>.value(value: _authProvider),
        ChangeNotifierProvider<ViewCountProvider>.value(value: _viewCountProvider),
      ],
      child: MaterialApp.router(
        title: 'CosmosAI Board',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: _appRouter.router,
      ),
    );
  }
}
