// File: frontend/lib/screens/auth/login_screen.dart
// Description: Login UI offering local credentials and Kakao/Google/Naver social buttons.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/login_method.dart';
import '../../providers/auth_provider.dart';

/// Login screen that supports multiple authentication methods.
class LoginScreen extends StatefulWidget {
  /// Default constructor.
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildLocalLoginForm(authProvider),
                const SizedBox(height: 32),
                _buildSocialButtons(authProvider),
                if (_errorMessage != null) ...<Widget>[
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the local login form with validation.
  Widget _buildLocalLoginForm(AuthProvider provider) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: '이메일'),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return '이메일을 입력해 주세요';
              }
              if (!value.contains('@')) {
                return '올바른 이메일 형식이 아닙니다';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: '비밀번호'),
            obscureText: true,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return '비밀번호를 입력해 주세요';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _isLoading ? null : () => _handleLocalLogin(provider),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('로컬 로그인'),
          ),
        ],
      ),
    );
  }

  /// Renders the social login buttons referencing OAuth placeholders.
  Widget _buildSocialButtons(AuthProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        OutlinedButton.icon(
          onPressed: () => _handleSocialLogin(provider, LoginMethod.kakao),
          icon: const Icon(Icons.chat_bubble_outline),
          label: const Text('카카오 로그인'),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => _handleSocialLogin(provider, LoginMethod.google),
          icon: const Icon(Icons.account_circle_outlined),
          label: const Text('구글 로그인'),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => _handleSocialLogin(provider, LoginMethod.naver),
          icon: const Icon(Icons.language_outlined),
          label: const Text('네이버 로그인'),
        ),
      ],
    );
  }

  Future<void> _handleLocalLogin(AuthProvider provider) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    final bool success = await provider.signInWithLocal(
      email: _emailController.text,
      password: _passwordController.text,
    );
    setState(() {
      _isLoading = false;
      _errorMessage = success ? null : '로그인에 실패했어요. 정보를 확인해 주세요.';
    });
    if (success && mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _handleSocialLogin(AuthProvider provider, LoginMethod method) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    final bool success = await provider.signInWithSocial(method);
    setState(() {
      _isLoading = false;
      _errorMessage = success ? null : '연동된 계정을 찾을 수 없습니다.';
    });
    if (success && mounted) {
      Navigator.of(context).pop();
    }
  }
}
