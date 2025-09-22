// File: lib/features/auth/presentation/screens/auth_screen.dart | Description: 로컬 및 소셜 로그인 플로우 UI.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../providers/auth_provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
      appBar: AppBar(title: const Text('CosmosAI 로그인')), // 🔐 로그인 화면 앱바
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: '이메일'),
                      validator: (String? value) =>
                          value != null && value.contains('@') ? null : '올바른 이메일을 입력하세요.',
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: '비밀번호 (로컬 로그인 시)'),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        icon: const Icon(Icons.lock_open),
                        label: const Text('로컬 로그인'),
                        onPressed: authProvider.isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState?.validate() ?? false) {
                                  await authProvider.signInWithLocal(
                                    _emailController.text,
                                    _passwordController.text,
                                  );
                                  if (context.mounted && authProvider.currentUser != null) {
                                    context.pop();
                                  }
                                }
                              },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              Text('소셜 로그인', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  _SocialLoginButton(
                    label: '카카오 로그인',
                    color: const Color(0xFFFEE500),
                    textColor: Colors.black,
                    onTap: authProvider.isLoading
                        ? null
                        : () async {
                            await authProvider.signInWithKakao();
                            if (context.mounted && authProvider.currentUser != null) {
                              context.pop();
                            }
                          },
                  ),
                  _SocialLoginButton(
                    label: '구글 로그인',
                    color: Colors.white,
                    textColor: Colors.black,
                    borderColor: Colors.black12,
                    onTap: authProvider.isLoading
                        ? null
                        : () async {
                            await authProvider.signInWithGoogle();
                            if (context.mounted && authProvider.currentUser != null) {
                              context.pop();
                            }
                          },
                  ),
                  _SocialLoginButton(
                    label: '네이버 로그인',
                    color: const Color(0xFF03C75A),
                    textColor: Colors.white,
                    onTap: authProvider.isLoading
                        ? null
                        : () async {
                            await authProvider.signInWithNaver();
                            if (context.mounted && authProvider.currentUser != null) {
                              context.pop();
                            }
                          },
                  ),
                ],
              ),
              if (authProvider.errorMessage != null) ...<Widget>[
                const SizedBox(height: 16),
                Text(authProvider.errorMessage!, style: const TextStyle(color: Colors.red)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  const _SocialLoginButton({
    required this.label,
    required this.color,
    required this.textColor,
    this.borderColor,
    this.onTap,
  });

  final String label;
  final Color color;
  final Color textColor;
  final Color? borderColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          side: BorderSide(color: borderColor ?? Colors.transparent),
        ),
        onPressed: onTap,
        child: Text(label),
      ),
    );
  }
}
