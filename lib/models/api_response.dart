import 'package:mypos_task/constants.dart';

class ApiResponse {
  int? status;
  Map<String, dynamic>? data;

  ApiResponse({
    this.status = ApiResponseCodes.serviceUnavailable,
    this.data,
  });
}
