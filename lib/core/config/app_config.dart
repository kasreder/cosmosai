// File: lib/core/config/app_config.dart | Description: 외부 서비스 연동 키 및 기본 설정 보관.
class AppConfig {
  const AppConfig._();

  // 🔐 소셜 로그인에 사용할 클라이언트 키 (실제 서비스에서 주입 필요)
  static const String kakaoNativeAppKey = '실제 사용키 삽입';
  static const String googleClientId = '실제 사용키 삽입';
  static const String naverClientId = '실제 사용키 삽입';
  static const String naverClientSecret = '실제 사용키 삽입';

  // 🌐 백엔드 API 엔드포인트 (추후 백엔드 구축 시 교체)
  static const String apiBaseUrl = 'https://placeholder.cosmosai.dev';
}
