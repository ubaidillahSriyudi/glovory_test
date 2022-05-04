class ServerException implements Exception {
  final String? message;

  const ServerException({this.message});

  @override
  String toString() {
    Object message = this.message!;
    if (message == null) {
      return "ServerException";
    } 
    return "$message";
  }
}