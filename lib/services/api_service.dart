import 'dart:convert';
import 'package:mypos_task/constants.dart';
import 'package:mypos_task/models/api_response.dart';
import 'package:mypos_task/models/employee.dart';
import 'package:mypos_task/parameters.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mypos_task/utils/logger_util.dart';

const String baseUrl = ApiConstants.baseUrl;
const String token = ApiConstants.token;

//Get All Categories
Future<dynamic> getRecords(
  String endpoint,
  BuildContext context, {
  required Function(dynamic data) success,
  required Function() failed,
  VoidCallback? complete,
}) async {
  try {
    printLogs(Uri.parse(baseUrl + endpoint));
    final response = await http
        .get(Uri.parse(baseUrl + endpoint), headers: {"apiToken": token});
    final responseJson = json.decode(response.body);
    if (response.body.isNotEmpty) {
      success(responseJson);
    } else {
      failed();
    }
  } catch (exception) {
    printLogs("Exception: $exception");
  } finally {
    complete?.call();
  }
}

Future<void> initializeApiRequest(
  String url,
  BuildContext context, {
  required Function(String? title, String? message, Map data) success,
  required Function(String title, String message, Map data) failed,
  VoidCallback? complete,
  Employee? employee,
  required String requestType,
}) async {
  ApiResponse? apiResponse = await makeApiRequest(
      context: context,
      requestType: requestType,
      url: url,
      jsonMap: json.encode({
        "empNo": employee?.empNo,
        "empName": employee?.empName,
        "empAddressLine1": employee?.empAddressLine1,
        "empAddressLine2": employee?.empAddressLine2,
        "empAddressLine3": employee?.empAddressLine3,
        "departmentCode": employee?.departmentCode,
        "dateOfJoin": employee?.dateOfJoin,
        "dateOfBirth": employee?.dateOfBirth,
        "basicSalary": employee?.basicSalary.toString(),
        "isActive": employee?.isActive
      }));
  try {
    printLogs("responseCode: ${apiResponse!.status}");
    switch (apiResponse.status) {
      case ApiResponseCodes.successResponse:
        String title = 'Success';
        String message = '';
        final Map? data = apiResponse.data;
        success(title, message, data!["data"] ?? {});
        break;

      case ApiResponseCodes.errorResponse:
        Map? data = apiResponse.data;
        String title = 'Failed';
        String message = 'Something went wrong, Please try again';
        failed(title, message, data ?? {});
        break;

      case ApiResponseCodes.insecureConnection:
        Map map = {};
        failed("Incompatible app version", "Please update your app", map);
        break;
      case ApiResponseCodes.exception:
        Map map = {};
        failed("Failed", ErrorMessages.unexpectedError, map);

        break;
      case ApiResponseCodes.connectionError:
        Map map = {};
        failed(
            "Unable to connect", "Please check your internet connection", map);

        break;

      case ApiResponseCodes.noNetwork:
        failed('No Network!',
            "Please check your mobile data or WiFi connection.", {});
        break;
    }
  } catch (e, s) {
    printLogs("exception: $e");
    failed("Failed", ErrorMessages.unexpectedError, {});
  } finally {
    complete?.call();
  }
}

Future<ApiResponse?> makeApiRequest({
  required BuildContext context,
  required String requestType,
  required String url,
  Object? jsonMap,
}) async {
  try {
    dynamic response;
    if (requestType == RequestType.get) {
      response = await http.get(
        Uri.parse(
          baseUrl + url,
        ),
        headers: {
          "apiToken": token,
        },
      );
    } else if (requestType == RequestType.post) {
      response = await http.post(
        Uri.parse(
          baseUrl + url,
        ),
        headers: {
          "apiToken": token,
          "Content-Type": "application/json",
        },
        body: jsonMap,
      );
    } else if (requestType == RequestType.put) {
      printLogs('PUT Request Called!');
      response = await http.put(
        Uri.parse(
          baseUrl + url,
        ),
        headers: {
          "apiToken": token,
          "Content-Type": "application/json",
        },
        body: jsonMap,
      );
      printLogs(response.body);
    } else {
      response = await http.delete(
        Uri.parse(
          baseUrl + url,
        ),
        headers: {
          "apiToken": token,
        },
      );
    }
    if (response.body.isNotEmpty) {
      final responseJson = json.decode(response.body);
      if (responseJson['status'] == "Successful") {
        return ApiResponse(
          status: ApiResponseCodes.successResponse,
          data: responseJson,
        );
      } else {
        return ApiResponse(status: ApiResponseCodes.errorResponse, data: {});
      }
    } else {
      return ApiResponse(status: ApiResponseCodes.errorResponse, data: {});
    }
  } catch (exception) {
    printLogs("Exception: $exception");
    return ApiResponse(status: ApiResponseCodes.exception);
  }
}
