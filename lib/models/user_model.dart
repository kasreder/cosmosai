// File: lib/models/user_model.dart | Description: 사용자 계정 및 프로필 모델 정의.
import 'package:uuid/uuid.dart';

enum LoginType { local, kakao, google, naver }

class UserModel {
  UserModel({
    String? id,
    required this.name,
    required this.email,
    required this.nickname,
    required this.loginType,
    this.password,
    this.point = 0,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.memo1,
    this.memo2,
    this.memo3,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  final String id;
  final String name;
  final String email;
  final LoginType loginType;
  final String nickname;
  final String? password;
  final int point;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? memo1;
  final String? memo2;
  final String? memo3;

  UserModel copyWith({
    String? name,
    String? nickname,
    String? password,
    int? point,
    DateTime? updatedAt,
    String? memo1,
    String? memo2,
    String? memo3,
  }) {
    // 🛠️ 사용자 정보 업데이트를 위한 copyWith 메서드
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email,
      nickname: nickname ?? this.nickname,
      loginType: loginType,
      password: password ?? this.password,
      point: point ?? this.point,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      memo1: memo1 ?? this.memo1,
      memo2: memo2 ?? this.memo2,
      memo3: memo3 ?? this.memo3,
    );
  }
}
