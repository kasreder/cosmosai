// File: lib/providers/auth_provider.dart | Description: 로그인 상태 및 사용자 세션 관리를 담당하는 Provider.
import 'package:flutter/material.dart';

import '../data/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider(this._repository);

  final AuthRepository _repository;

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> signInWithLocal(String email, String password) async {
    await _signIn(() => _repository.signInWithLocal(email: email, password: password));
  }

  Future<void> signInWithKakao() async {
    await _signIn(_repository.signInWithKakao);
  }

  Future<void> signInWithGoogle() async {
    await _signIn(_repository.signInWithGoogle);
  }

  Future<void> signInWithNaver() async {
    await _signIn(_repository.signInWithNaver);
  }

  Future<void> _signIn(Future<UserModel> Function() signInAction) async {
    // 🔐 공통 로그인 흐름 처리 (로딩 상태 및 에러 관리)
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await signInAction();
    } catch (error) {
      _errorMessage = '로그인에 실패했습니다. ${error.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void signOut() {
    // 🚪 로그아웃 처리
    _currentUser = null;
    notifyListeners();
  }
}
