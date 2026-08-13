import 'package:ebazarx/core/failures/failure.dart';

class AuthState {
  final bool isLogging;
  final bool isRegistering;
  final bool isLoggingOut;
  final bool isRequestingRegistrationOtp;
  final int seconds;
  final Failure? failure;

  const AuthState({this.isRequestingRegistrationOtp = false,
     this.isLogging = false,
     this.isRegistering = false,
     this.isLoggingOut = false,
      this.seconds = 0,
     this.failure,
  });

  AuthState copyWith({
    bool? isLogging,
    bool? isRegistering,
    bool? isRequestingRegistrationOtp,
    bool? isLoggingOut,
    int? minute,
    Failure? failure,
  }){
    return AuthState(
      isLogging: isLogging ?? this.isLogging,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
      isRequestingRegistrationOtp: isRequestingRegistrationOtp ?? this.isRequestingRegistrationOtp,
      isRegistering: isRegistering ?? this.isRegistering,
      seconds: minute ?? this.seconds,
      failure: failure ?? this.failure,
    );
  }

  bool get canResend => seconds <= 0;
}