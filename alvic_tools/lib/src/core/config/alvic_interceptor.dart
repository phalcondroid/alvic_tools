import 'package:dio/dio.dart';

class AlvicInterceptor {

  final RequestOptions Function(RequestOptions options, RequestInterceptorHandler handler)? before;
  final Response Function(Response response, ResponseInterceptorHandler handler)? after;
  final DioException Function (DioException e, ErrorInterceptorHandler handler)? catchError;
  
  const AlvicInterceptor({
    this.before,
    this.after,
    this.catchError
  });
}