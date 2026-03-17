class ProvisioningResponse{

  final bool success;
  final String message;

  ProvisioningResponse({required this.success, required this.message});

  /// Creates a WifiNetwork from a map received from the platform channel
  factory ProvisioningResponse.fromMap(Map<dynamic, dynamic> map) {
    return ProvisioningResponse(
      success: map['success'] as bool,
      message: map['message'] as String,
    );
  }

  /// Converts this WifiNetwork to a map for platform channel communication
  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'message': message,
    };
  }

  @override
  String toString() => 'ProvisioningResponse(success: $success, message: $message)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ProvisioningResponse &&
              runtimeType == other.runtimeType &&
              success == other.success &&
              message == other.message;

  @override
  int get hashCode => success.hashCode ^ message.hashCode;

}
