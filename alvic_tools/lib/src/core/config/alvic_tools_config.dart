import 'dart:core';

import 'package:alvic_tools/src/core/config/alvic_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class AlvicToolsConfig {
  
  final String baseUrl;
  final Duration? connectTimeout;
  final Duration? receiveTimeout;
  final AlvicInterceptor? interceptor;

  const AlvicToolsConfig({
    this.baseUrl = "",
    this.connectTimeout = const Duration(seconds: 5),
    this.receiveTimeout = const Duration(seconds: 3),
    this.interceptor = const AlvicInterceptor()
  });

  BaseOptions getOptions() => BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: connectTimeout,
    receiveTimeout: receiveTimeout,
  );
  
  void initConfig(Dio dio) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        if (interceptor?.before != null) {
          return handler.next(interceptor?.before!(options, handler) ?? options);
        }
        return handler.next(options);
      },
      onResponse: (Response response, ResponseInterceptorHandler handler) {
        if (interceptor?.after != null) {
          return handler.next(interceptor?.after!(response, handler) ?? response);
        }
        return handler.next(response);
      },
      onError: (DioException e, ErrorInterceptorHandler handler) {
        if (interceptor?.catchError != null) {
          return handler.next(interceptor?.catchError!(e, handler) ?? e);
        }
        return handler.next(e);
      },
    ));
    dio.options = getOptions();
  }
}