class AddressState {
  final bool isLoading;
  final bool isSuccess;
  final String? error;

  const AddressState({
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
  });

  AddressState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? error,
    bool clearError = false,
  }) {
    return AddressState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: clearError ? null : error ?? this.error,
    );
  }
}