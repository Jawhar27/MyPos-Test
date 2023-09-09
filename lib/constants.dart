class ApiResponseCodes {
  static const int serviceUnavailable = 503;
  static const int successResponse = 200;
  static const int errorResponse = 400;
  static const int exception = 500;
  static const int insecureConnection = 403;
  static const int connectionError = 404;
  static const int noNetwork = 0;
  static const int requestTimeOut = 408;
}

class RequestType {
  static const String post = 'POST';
  static const String get = 'GET';
  static const String delete = 'DELETE';
  static const String put = 'PUT';
}

class ErrorMessages {
  static const String unexpectedError =
      "Something went wrong, Please try again";
}
