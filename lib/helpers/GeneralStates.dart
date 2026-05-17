// Enumeration representing the general status of an operation.
enum GeneralStatus {
  initial, // Initial status
  loading, // Loading status
  success, // Success status
  error, // Error status
  navigate // Navigation status
}

// Extension to provide utility methods for GeneralStatus enum.
extension GeneralStatusX on GeneralStatus {
  bool get isInitial =>
      this == GeneralStatus.initial; // Check if status is initial.
  bool get isLoading =>
      this == GeneralStatus.loading; // Check if status is loading.
  bool get isSuccess =>
      this == GeneralStatus.success; // Check if status is success.
  bool get isError => this == GeneralStatus.error; // Check if status is error.
  bool get shouldNavigate =>
      this == GeneralStatus.navigate; // Check if status indicates navigation.
}
