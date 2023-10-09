import 'dart:convert';

class BaseResponse<T> {
  final String statusCode;
  final int count;
  final List<T> data;
  final List message;

  const BaseResponse({
    required this.statusCode,
    required this.count,
    required this.data,
    required this.message
  });
}