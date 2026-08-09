import 'package:ebazarx/core/failures/failure.dart';

class AuthState {
  final bool isLogging;
  final bool isRegistering;
  final bool isLoggingOut;
  final Failure? failure;

  const AuthState({
     this.isLogging = false,
     this.isRegistering = false,
     this.isLoggingOut = false,
     this.failure,
  });

  AuthState copyWith({
    bool? isLogging,
    bool? isRegistering,
    bool? isLoggingOut,
    Failure? failure,
  }){
    return AuthState(
      isLogging: isLogging ?? this.isLogging,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
      isRegistering: isRegistering ?? this.isRegistering,
      failure: failure ?? this.failure,
    );
  }
}