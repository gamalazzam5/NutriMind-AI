import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/auth_divider.dart';
import '../widgets/auth_footer_link.dart';
import '../widgets/auth_social_button.dart';
import '../widgets/auth_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signUp() {
    context.read<AuthCubit>().signUpWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      displayName: _nameController.text.trim(),
    );
  }

  void _signUpWithGoogle() {
    context.read<AuthCubit>().signInWithGoogle();
  }

  void _goToLogin() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.of(context).pushReplacementNamed(AppRoutes.main);
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            return _buildForm(isLoading: isLoading);
          },
        ),
      ),
    );
  }

  Widget _buildForm({required bool isLoading}) {
    return SingleChildScrollView(
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
                    border: Border.all(color: const Color(0xFFBBCBBB)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 2.r,
                        offset: Offset(0, 1.h),
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
                'Create Account',
                textAlign: TextAlign.center,
                style: AppTextStyles.h1(color: const Color(0xFF161D17)),
              ),
              SizedBox(height: 8.h),
              Text(
                'Join the NutriMind community',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyLarge(color: const Color(0xFF3D4A3E)),
              ),
              SizedBox(height: 32.h),
              Container(
                padding: EdgeInsets.all(25.r),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryStart.withValues(alpha: 0.08),
                      blurRadius: 12.r,
                      offset: Offset(0, 4.h),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AuthTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      hintText: 'Alex Wellness',
                      icon: Icons.person_outline_rounded,
                      fillColor: const Color(0xFFF3F3EF),
                    ),
                    SizedBox(height: 20.h),
                    AuthTextField(
                      controller: _emailController,
                      label: 'Email Address',
                      hintText: 'alex@example.com',
                      icon: Icons.mail_outline_rounded,
                      keyboardType: TextInputType.emailAddress,
                      fillColor: const Color(0xFFF3F3EF),
                    ),
                    SizedBox(height: 20.h),
                    AuthTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hintText: '••••••••',
                      icon: Icons.lock_outline_rounded,
                      obscureText: true,
                      showObscureToggle: true,
                      fillColor: const Color(0xFFF3F3EF),
                    ),
                    SizedBox(height: 24.h),
                    GradientButton(
                      label: 'Sign Up',
                      onPressed: isLoading ? null : _signUp,
                      isLoading: isLoading,
                      gradient: AppColors.signUpGradient,
                    ),
                    SizedBox(height: 24.h),
                    const AuthDivider(label: 'OR SIGN UP WITH'),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        AuthSocialButton(
                          iconAsset: 'assets/images/icon_google.png',
                          label: 'Google',
                          onTap: isLoading ? () {} : _signUpWithGoogle,
                        ),
                        SizedBox(width: 16.w),
                        AuthSocialButton(
                          iconAsset: 'assets/images/icon_apple.png',
                          label: 'Apple',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              AuthFooterLink(
                prefixText: 'Already have an account? ',
                actionText: 'Login',
                onTap: _goToLogin,
              ),
            ],
          ),
        );
  }
}
