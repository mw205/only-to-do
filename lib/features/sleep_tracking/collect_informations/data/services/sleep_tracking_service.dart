// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:only_to_do/core/data/datasources/local_datasource.dart';
import 'package:only_to_do/core/network/api_call.dart';
import 'package:only_to_do/core/network/api_error_handler.dart';
import 'package:only_to_do/core/network/api_result.dart';
import 'package:only_to_do/features/yourevent/services/firebase_service.dart';

import '../models/predict_sleep_quality_request_body.dart';

class SleepTrackingService {
  Dio dio;
  LocalDataSource localDataSource;
  SleepTrackingService({required this.dio, required this.localDataSource});

  /// Retrieves the model URL for the currently logged-in user.
  ///
  /// This function checks if the user is logged in and is a premium user.
  /// If the user is not logged in, it returns an authentication error.
  /// If the user is not a premium user, it returns an authorization error.
  /// It attempts to fetch the model URL from the Firestore collection specified
  /// in the environment variables. If the model URL is found, it returns it
  /// as a success. Otherwise, it returns a not found error.
  ///
  /// Returns an [ApiResult<String>] which contains the model URL on success
  /// or an error message on failure.
  /// Possible error codes:
  /// - 401: User not logged in
  /// - 403: User is not premium
  /// - 404: Model URL not found
  /// - 500: Unexpected error occurred

  Future<ApiResult<String>> getModelUrl() async {
    FirebaseService firebaseService = FirebaseService();

    if (firebaseService.currentUserId == null) {
      return ApiResult<String>.failure(
        ApiErrorHandler(code: 401, message: 'User not logged in'),
      );
    } else {
      try {
        if (await firebaseService.isPremiumUser()) {
          final docSnapshot = await FirebaseService()
              .firestore
              .collection(dotenv.get('urls_collection'))
              .doc(dotenv.get('docId'))
              .get();

          if (docSnapshot.exists) {
            final modelUrl = docSnapshot.data()![dotenv.get('model_name')];
            if (modelUrl != null) {
              return ApiResult<String>.success(modelUrl);
            }
          } else {
            return ApiResult.failure(
              ApiErrorHandler(code: 404, message: 'Model URL not found'),
            );
          }
        } else {
          return ApiResult.failure(
            ApiErrorHandler(code: 403, message: 'User is not premium'),
          );
        }
      } on FirebaseException catch (e) {
        return ApiResult.failure(ApiErrorHandler.fromFirebaseException(e));
      }
    }
    return ApiResult.failure(
      ApiErrorHandler(code: 500, message: 'Unexpected error occurred'),
    );
  }

  Future<ApiResult<double>> predict(
    PredictSleepQualityRequestBody requestBody,
  ) async {
    ApiResult<String> result = await getModelUrl();
    return result.when(
      success: (data) {
        return ApiCallsHandler().handler(
          apiCall: () {
            return dio.post(
              data,
              data: requestBody.toJson(),
            );
          },
          parser: (data) {
            double predictionValue = data['predicted_quality_of_sleep'];
            localDataSource.saveSleepData(requestBody, predictionValue);
            return predictionValue;
          },
        );
      },
      failure: (error) {
        return ApiResult.failure(error);
      },
    );
  }
}
