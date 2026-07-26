import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../widgets/auth_divider.dart';
import '../widgets/auth_footer_link.dart';
import '../widgets/auth_social_button.dart';
import '../widgets/auth_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    // TODO: wire to AuthCubit once Firebase Auth is integrated.
    Navigator.of(context).pushReplacementNamed(AppRoutes.main);
  }

  void _forgotPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Coming soon')),
    );
  }

  void _goToRegister() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.register);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 96.r,
                  height: 96.r,
                  padding: EdgeInsets.all(1.r),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryStart.withValues(alpha: 0.12),
                        blurRadius: 12.r,
                        offset: Offset(0, 4.h),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset('assets/images/logo.png', fit: BoxFit.cover),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'NutriMind AI',
                textAlign: TextAlign.center,
                style: AppTextStyles.h1(color: const Color(0xFF006D37)),
              ),
              SizedBox(height: 8.h),
              Text(
                'Your personal holistic health companion',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyLarge(color: const Color(0xFF3D4A3E)),
              ),
              SizedBox(height: 32.h),
              AuthTextField(
                controller: _emailController,
                hintText: 'Email Address',
                icon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                showShadow: true,
              ),
              SizedBox(height: 16.h),
              AuthTextField(
                controller: _passwordController,
                hintText: 'Password',
                icon: Icons.lock_outline_rounded,
                obscureText: true,
                showShadow: true,
              ),
              SizedBox(height: 8.h),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: _forgotPassword,
                  child: Text(
                    'Forgot password?',
                    style: AppTextStyles.caption(color: const Color(0xFF006D37))
                        .copyWith(fontWeight: FontWeight.w500, fontSize: 12.sp),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              GradientButton(
                label: 'Login',
                onPressed: _login,
                icon: Icons.arrow_forward_rounded,
                iconTrailing: true,
                gradient: AppColors.ctaGradient,
              ),
              SizedBox(height: 32.h),
              const AuthDivider(label: 'OR CONTINUE WITH'),
              SizedBox(height: 16.h),
              Row(
                children: [
                  AuthSocialButton(
                    iconAsset: 'assets/images/icon_google.png',
                    label: 'Google',
                    onTap: () {},
                  ),
                  SizedBox(width: 16.w),
                  AuthSocialButton(
                    iconAsset: 'assets/images/icon_apple.png',
                    label: 'Apple',
                    onTap: () {},
                  ),
                ],
              ),
              SizedBox(height: 32.h),
              AuthFooterLink(
                prefixText: "Don't have an account? ",
                actionText: 'Create account',
                onTap: _goToRegister,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
