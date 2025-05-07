import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';

import 'error_model.dart';

class ApiErrorHandler {
  String message;
  dynamic code;
  ApiErrorHandler({
    required this.message,
    required this.code,
  });

  factory ApiErrorHandler.fromDioException(DioException exception) {
    if (exception.response == null) {
      return ApiErrorHandler(
        message: 'No Response from Server',
        code: 500, // Assign a default error code
      );
    }
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
        return ApiErrorHandler(
          message: 'Connection Timeout',
          code: exception.response!.statusCode!,
        );
      case DioExceptionType.sendTimeout:
        return ApiErrorHandler(
          message: 'Send Timeout',
          code: exception.response!.statusCode!,
        );
      case DioExceptionType.receiveTimeout:
        return ApiErrorHandler(
          message: 'Receive Timeout',
          code: exception.response!.statusCode!,
        );
      case DioExceptionType.badCertificate:
        return ApiErrorHandler(
          message: 'Bad Cirtificate',
          code: exception.response!.statusCode!,
        );
      case DioExceptionType.badResponse:
        return ApiErrorHandler(
          message: 'Bad Response',
          code: exception.response!.statusCode!,
        );
      case DioExceptionType.cancel:
        return ApiErrorHandler(
          message: 'Request Canceled',
          code: exception.response!.statusCode!,
        );
      case DioExceptionType.connectionError:
        return ApiErrorHandler(
          message: 'Connection Error',
          code: 599,
        );
      case DioExceptionType.unknown:
        if (exception.error is SocketException) {
          return ApiErrorHandler(
            message: 'No Internet Connection',
            code: exception.response!.statusCode!,
          );
        }
        return ApiErrorHandler(
          message: 'Connection Error',
          code: exception.response!.statusCode!,
        );
    }
  }
  factory ApiErrorHandler.fromErrorModel(ErrorModel error) {
    return ApiErrorHandler(message: error.message, code: error.statusCode);
  }

  factory ApiErrorHandler.fromFirebaseException(FirebaseException exception) {
    final code = exception.code;
    String message;
    int statusCode;

    switch (code) {
      case 'permission-denied':
        message = 'You do not have permission to access this resource.';
        statusCode = 403;
        break;
      case 'not-found':
        message = 'Requested document or resource was not found.';
        statusCode = 404;
        break;
      case 'unavailable':
        message =
            'Firestore service is currently unavailable. Try again later.';
        statusCode = 503;
        break;
      case 'cancelled':
        message = 'The operation was cancelled.';
        statusCode = 499;
        break;
      case 'deadline-exceeded':
        message = 'The operation timed out.';
        statusCode = 504;
        break;
      case 'resource-exhausted':
        message = 'Quota exceeded or too many requests.';
        statusCode = 429;
        break;
      default:
        message = exception.message ?? 'An unknown Firestore error occurred.';
        statusCode = 500;
    }

    return ApiErrorHandler(
      message: message,
      code: statusCode,
    );
  }
}
