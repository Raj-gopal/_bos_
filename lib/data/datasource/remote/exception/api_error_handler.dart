import 'package:dio/dio.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/error_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:provider/provider.dart';

class ApiErrorHandler {
  static dynamic getMessage(error) {
    dynamic errorDescription = "";

    // Check if error is an exception
    if (error is Exception) {
      try {
        if (error is DioException) {
          // Handle different types of Dio exceptions
          switch (error.type) {
            case DioExceptionType.cancel:
              errorDescription = "Request to API server was cancelled";
              break;
            case DioExceptionType.connectionTimeout:
              errorDescription = "Connection timeout with API server";
              break;
            case DioExceptionType.sendTimeout:
              errorDescription = "Send timeout";
              break;
            case DioExceptionType.receiveTimeout:
              errorDescription = "Receive timeout in connection with API server";
              break;
            case DioExceptionType.badResponse:
            // Handle specific HTTP status codes
              switch (error.response!.statusCode) {
                case 403:
                  errorDescription = _extractErrorMessage(error) ?? "Access forbidden";
                  break;
                case 401:
                  errorDescription = _extractErrorMessage(error) ?? "Unauthorized access";
                  Provider.of<AuthController>(Get.context!, listen: false).clearSharedData();
                  break;
                case 404:
                  errorDescription = "Requested resource not found";
                  break;
                case 500:
                  errorDescription = "Internal server error";
                  break;
                case 503:
                  errorDescription = "Service unavailable";
                  break;
                case 429:
                  errorDescription = "Too many requests. Please try again later.";
                  break;
                default:
                  errorDescription = _extractErrorMessage(error) ?? "Failed to load data - status code: ${error.response!.statusCode}";
              }
              break;
            case DioExceptionType.badCertificate:
              errorDescription = "Certificate verification failed";
              break;
            case DioExceptionType.connectionError:
              errorDescription = "Connection error occurred";
              break;
            case DioExceptionType.unknown:
              errorDescription = "An unexpected error occurred. Please try again later.";
              print("DioExceptionType.unknown error: ${error.toString()}");
              break;
          }
        } else {
          errorDescription = "An unexpected error occurred";
        }
      } on FormatException catch (e) {
        errorDescription = "Data format error: ${e.toString()}";
      }
    } else {
      errorDescription = "An unknown error occurred";
    }
    return errorDescription;
  }

  // Helper method to extract detailed error messages if available
  static String? _extractErrorMessage(DioException error) {
    if (error.response?.data != null) {
      ErrorResponse errorResponse = ErrorResponse.fromJson(error.response!.data);
      if (errorResponse.errors != null && errorResponse.errors!.isNotEmpty) {
        return errorResponse.errors![0].message;
      }
      return error.response!.data['message'];
    }
    return null;
  }
}
