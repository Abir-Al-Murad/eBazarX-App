// lib/features/auth/presentation/screens/otp_screen.dart
import 'dart:async';

import 'package:ebazarx/app/app_routes_name.dart';
import 'package:ebazarx/common/widgets/loading_state.dart';
import 'package:ebazarx/core/utils/app_snackbar.dart';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/features/auth/presentation/providers/auth_provider.dart';
import 'package:ebazarx/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String email;
  final String fullName;
  final String phone;
  final String password;
  final String? profileImage;

  const OtpScreen({
    super.key,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.password,
    this.profileImage,
  });

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();

  // Locally ticking countdown — the previous version rendered
  // authState.seconds directly, which is a snapshot from the provider
  // and never decremented on its own, so the UI showed a static number.
  Timer? _timer;
  int _remainingSeconds = 0;
  int? _lastKnownSeconds;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final seconds = ref.read(authNotifierProvider).seconds;
      _startCountdown(seconds);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pinController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }

  void _startCountdown(int seconds) {
    _timer?.cancel();
    _lastKnownSeconds = seconds;
    setState(() => _remainingSeconds = seconds);

    if (seconds <= 0) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_remainingSeconds <= 1) {
        timer.cancel();
        setState(() => _remainingSeconds = 0);
      } else {
        setState(() => _remainingSeconds -= 1);
      }
    });
  }

  Future<void> _verifyOtp(String otp) async {
    if (otp.length != 6) {
      AppSnackBar.warning(context: context, 'Please enter a valid 6-digit OTP');
      return;
    }
    LoadingState.show(context, message: 'Verifying OTP');
    final authNotifier = ref.read(authNotifierProvider.notifier);
    final success = await authNotifier.register(
      fullName: widget.fullName,
      email: widget.email,
      phone: widget.phone,
      password: widget.password,
      profileImage: widget.profileImage,
      otp: otp,
    );

    if (!mounted) return;
    LoadingState.hide();
    if (success) {
      AppSnackBar.success(context: context, 'Account created successfully! Please login.');
      context.goNamed(AppRoutesName.login);
    } else {
      final authState = ref.read(authNotifierProvider);
      AppSnackBar.error(
        context: context,
        authState.failure?.message ?? 'Invalid OTP. Please try again.',
      );
      _pinController.clear();
      _pinFocusNode.requestFocus();
    }
    LoadingState.hide();
  }

  Future<void> _resendOtp() async {
    if (_remainingSeconds > 0) return;

    final authNotifier = ref.read(authNotifierProvider.notifier);
    final success = await authNotifier.request_registration_otp(
      fullName: widget.fullName,
      email: widget.email,
      phone: widget.phone,
      password: widget.password,
      profileImage: widget.profileImage,
    );

    if (!mounted) return;

    if (success) {
      AppSnackBar.success(context: context, 'OTP resent successfully!');
      _pinController.clear();
      _pinFocusNode.requestFocus();
      _startCountdown(ref.read(authNotifierProvider).seconds);
    } else {
      final authState = ref.read(authNotifierProvider);
      AppSnackBar.error(context: context, authState.failure?.message ?? 'Failed to resend OTP');
    }
  }

  String _formatCountdown(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // If the backend hands us a fresh `seconds` value (e.g. screen just
    // opened and the provider finished loading it), pick it up once.
    final authState = ref.watch(authNotifierProvider);
    if (_lastKnownSeconds != null &&
        authState.seconds != _lastKnownSeconds &&
        authState.seconds > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _startCountdown(authState.seconds);
      });
    }

    final canResend = _remainingSeconds <= 0;

    final defaultPinTheme = PinTheme(
      width: 52,
      height: 56,
      textStyle: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(context.radiusDefault),
        border: Border.all(color: theme.dividerColor),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: theme.colorScheme.primary, width: 2),
        color: theme.cardColor,
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        border: Border.all(color: theme.colorScheme.primary, width: 2),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppColors.error, width: 2),
        color: AppColors.error.withValues(alpha: 0.08),
      ),
    );

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(title: const Text('Verify OTP'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(context.paddingSizeLarge),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: context.paddingSizeDefault),
                  Container(
                    width: 64,
                    height: 64,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.mark_email_read_outlined,
                      color: theme.colorScheme.primary,
                      size: 30,
                    ),
                  ),
                  SizedBox(height: context.paddingSizeLarge),
                  Text(
                    'Enter the 6-digit code',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: context.paddingSizeExtraSmall),
                  Text(
                    'We sent a verification code to',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    widget.email,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: context.paddingSizeExtraLarge),
                  Center(
                    child: Pinput(
                      controller: _pinController,
                      focusNode: _pinFocusNode,
                      length: 6,
                      autofocus: true,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      submittedPinTheme: submittedPinTheme,
                      errorPinTheme: errorPinTheme,
                      onCompleted: _verifyOtp,
                      pinAnimationType: PinAnimationType.slide,
                    ),
                  ),
                  SizedBox(height: context.paddingSizeExtraLarge),
                  if (authState.isRegistering)
                    const Center(child: CircularProgressIndicator())
                  else
                    Center(
                      child: canResend
                          ? TextButton.icon(
                        onPressed: _resendOtp,
                        icon: Icon(Icons.refresh_rounded, size: 18, color: theme.colorScheme.primary),
                        label: const Text('Resend OTP'),
                      )
                          : Text.rich(
                        TextSpan(
                          text: 'Resend OTP in ',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          children: [
                            TextSpan(
                              text: _formatCountdown(_remainingSeconds),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  SizedBox(height: context.paddingSizeExtraLarge * 2),
                  Text(
                    "Didn't receive the code? Check your spam folder or try resending it.",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: context.paddingSizeDefault),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}