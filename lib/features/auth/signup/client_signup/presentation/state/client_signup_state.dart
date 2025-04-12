class ClientSignupState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  ClientSignupState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  ClientSignupState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return ClientSignupState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}