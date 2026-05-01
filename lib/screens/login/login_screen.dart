import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../main/main_screen.dart';

import '../register/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background mesh effect
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.background,
                    AppColors.surfaceContainerLowest,
                  ],
                ),
              ),
            ),
          ),
          
          // Mesh glows
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.05),
              ),
            ),
          ),
          
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withValues(alpha: 0.05),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  
                  // Logo / App Name
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Welcome Text
                  Text(
                    'Chào mừng trở lại',
                    style: theme.textTheme.displaySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Quản lý tài chính thông minh hơn cùng Lumina',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Login Form
                  Text(
                    'Email',
                    style: theme.textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'user@example.com',
                      prefixIcon: Icon(Icons.email_outlined, size: 20),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  Text(
                    'Mật khẩu',
                    style: theme.textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Handle forgot password
                      },
                      child: Text(
                        'Quên mật khẩu?',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        // Mock login and navigate to MainScreen
                        Get.offAll(() => const MainScreen());
                      },
                      child: const Text('Đăng nhập'),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Register link
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Chưa có tài khoản? ',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Get.to(() => const RegisterScreen()),
                          child: Text(
                            'Đăng ký ngay',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
