class HttpException implements Exception {
  final String message;
  final int errorCode;

  HttpException(this.message,this.errorCode);

  @override
  String toString() {
    return message;
    // return super.toString(); // Instance of HttpException
  }
}