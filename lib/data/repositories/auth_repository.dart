// File: lib/data/repositories/auth_repository.dart | Description: 로그인 및 인증 관련 더미 구현.
import '../../core/config/app_config.dart';
import '../../models/user_model.dart';
import '../datasources/dummy_data_source.dart';

class AuthRepository {
  AuthRepository(this._dataSource);

  final DummyDataSource _dataSource;

  Future<UserModel> signInWithLocal({
    required String email,
    required String password,
  }) async {
    // 🔑 실제 구현에서는 보안 검증 로직 추가 예정
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _dataSource.users.firstWhere(
      (user) => user.email == email && user.loginType == LoginType.local,
      orElse: () => UserModel(
        name: '새 사용자',
        email: email,
        nickname: 'Newbie',
        loginType: LoginType.local,
        password: password,
      ),
    );
  }

  Future<UserModel> signInWithKakao() async {
    await Future<void>.delayed(const Duration(milliseconds: 320));
    return UserModel(
      name: 'Kakao User',
      email: 'kakao@cosmos.ai',
      nickname: '카카오인',
      loginType: LoginType.kakao,
      memo1: 'AppKey: ${AppConfig.kakaoNativeAppKey}',
    );
  }

  Future<UserModel> signInWithGoogle() async {
    await Future<void>.delayed(const Duration(milliseconds: 320));
    return UserModel(
      name: 'Google Explorer',
      email: 'google@cosmos.ai',
      nickname: '구글러',
      loginType: LoginType.google,
      memo1: 'ClientId: ${AppConfig.googleClientId}',
    );
  }

  Future<UserModel> signInWithNaver() async {
    await Future<void>.delayed(const Duration(milliseconds: 320));
    return UserModel(
      name: 'Naver Navigator',
      email: 'naver@cosmos.ai',
      nickname: '네이버러',
      loginType: LoginType.naver,
      memo1: 'ClientId: ${AppConfig.naverClientId}',
      memo2: 'ClientSecret: ${AppConfig.naverClientSecret}',
    );
  }
}
