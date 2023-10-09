import 'package:alvic_tools/src/core/adapters/data_options.dart';

abstract class DataAdapter {
  Future<List<Map<String, dynamic>>> get<T>(String path, DataOptions options);
  Future<Map<String, dynamic>> getOne<T>(String path, DataOptions options);
  Future<bool> save(String path, List<Map<String, dynamic>> data, DataOptions options);
  Future<bool> update<T>(String path, List<Map<String, dynamic>> data, DataOptions options);
  Future<bool> remove<T>(String path, DataOptions options);
  Future<void> clear(String path);
}