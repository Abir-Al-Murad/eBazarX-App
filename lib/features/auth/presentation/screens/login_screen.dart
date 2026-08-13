import 'dart:ui';
import 'package:ebazarx/app/app_routes_name.dart';
import 'package:ebazarx/app/assets_path.dart';
import 'package:ebazarx/common/utils/invalidate_providers.dart';
import 'package:ebazarx/common/utils/load_necessary_data.dart';
import 'package:ebazarx/common/utils/styles.dart';
import 'package:ebazarx/common/utils/user_based_login.dart';
import 'package:ebazarx/common/widgets/aurora_background.dart';
import 'package:ebazarx/core/utils/app_snackbar.dart';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../notifiers/auth_notifier.dart';


class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

   Future<void> _handleLogin(AuthNotifier authNotifier) async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final result = await authNotifier.login(
      username: _usernameController.text.trim(),
      password: _passwordController.text,
    );
    if(result == true) {
      invalidateUserProviders(ref.read);
      if (!context.mounted) return;
      // if(context.canPop()){
      //   // await loadNecessaryData(ref);
      //   context.pop(true);
      // }else{
      //   // await loadNecessaryData(ref);
      //   context.goNamed(AppRoutesName.widgetTree);
      // }
      bool navigated = await userBasedNavigation(ref, context);
      if(navigated) return;
    }else{
      AppSnackBar.warning(context: context, ref.watch(authNotifierProvider).failure?.message ?? "Login failed. Please check your credentials.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = context.isDesktop;
    final isTablet = context.isTablet;

    final authState = ref.watch(authNotifierProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);
    final isLoading = authState.isLogging;

    // ref.listen(authNotifierProvider, (previous, next) {
    //   if (next.error != null && next.error != previous?.error) {
    //     AppSnackbar.show(
    //       message: next.error.toString(),
    //       type: SnackbarType.error,
    //     );
    //   }
    // });

    final cardWidth = isDesktop ? 420.0 : (isTablet ? 460.0 : double.infinity);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // ---- Background gradient + soft blobs ----
          AuroraBackground(theme: theme),

          // ---- Content ----
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: cardWidth),
                  child: _GlassCard(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildHeader(theme),
                          const SizedBox(height: 28),
                          _GlassTextField(
                            controller: _usernameController,
                            label: 'Username',
                            icon: Icons.person_outline_rounded,
                            textInputAction: TextInputAction.next,
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Username is required'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          _GlassTextField(
                            controller: _passwordController,
                            label: 'Password',
                            icon: Icons.lock_outline_rounded,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _handleLogin(authNotifier as AuthNotifier),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_rounded
                                    : Icons.visibility_rounded,
                                size: 20,
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.6),
                              ),
                              onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Password is required';
                              }
                              if (v.length < 4) return 'Password is too short';
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                // TODO: forgot password
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildLoginButton(
                            theme,
                            isLoading,
                                () => _handleLogin(authNotifier as AuthNotifier),
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: GestureDetector(
                                onTap: (){
                                  context.pushNamed(AppRoutesName.register);
                                },
                                child: Text("Sign Up",style: context.bold.copyWith(fontWeight: FontWeight.w400),)),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.85),
                Colors.white.withOpacity(0.55),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.35),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Image.asset(AssetsPath.logoRaw)
        ),
        const SizedBox(height: 20),
        Text(
          'Welcome back',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Login to continue shopping with eBazar',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(
      ThemeData theme,
      bool isLoading,
      VoidCallback onPressed,
      ) {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: isLoading
            ? const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2.2,
            color: Colors.white,
          ),
        )
            : const Text(
          'Login',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

/// ---------------- Reusable glass building blocks ----------------



class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: theme.colorScheme.surface.withOpacity(0.35),
            border: Border.all(
              color: theme.colorScheme.onSurface.withOpacity(0.12),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _GlassTextField extends StatelessWidget {
  const _GlassTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.obscureText = false,
    this.textInputAction,
    this.suffixIcon,
    this.validator,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      style: TextStyle(fontSize: 15, color: theme.colorScheme.onSurface),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 13,
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
        prefixIcon: Icon(
          icon,
          size: 20,
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: theme.colorScheme.surface.withOpacity(0.25),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: theme.colorScheme.onSurface.withOpacity(0.12),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: theme.colorScheme.onSurface.withOpacity(0.12),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: theme.colorScheme.error),
        ),
      ),
    );
  }
}