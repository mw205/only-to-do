import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';

class DioConfig {
  DioConfig._privateConstructor();
  static final DioConfig _instance = DioConfig._privateConstructor();
  static DioConfig get instance => _instance;
  Dio getDio() {
    final cacheOptions = CacheOptions(
      store: MemCacheStore(),
      policy: CachePolicy.request,
      hitCacheOnErrorExcept: [401, 404],
      maxStale: const Duration(days: 7),
      priority: CachePriority.normal,
      cipher: null,
      keyBuilder: CacheOptions.defaultCacheKeyBuilder,
      allowPostMethod: false,
    );
    Duration timeOut = const Duration(seconds: 60);
    BaseOptions options = BaseOptions(
      connectTimeout: timeOut,
      receiveTimeout: timeOut,
      headers: {
        Headers.contentTypeHeader: Headers.jsonContentType,
      },
    );
    return Dio(options)
      ..interceptors.addAll(
        [
          if (kDebugMode)
            LogInterceptor(
              request: true,
              error: true,
              responseBody: true,
            ),
          DioCacheInterceptor(options: cacheOptions)
        ],
      );
  }
}
