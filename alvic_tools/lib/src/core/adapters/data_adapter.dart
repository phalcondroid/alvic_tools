import 'package:alvic_tools/src/core/adapters/data_options.dart';

abstract class DataAdapter {
  Future<List<Map<String, dynamic>>> get<T>(String path, dynamic options);
  Future<Map<String, dynamic>> getOne<T>(String path, DataOptions options);
  Future<T> save<T>(T data);
  Future<T> update<T>(T data);
  Future<T> remove<T>(T data);
}