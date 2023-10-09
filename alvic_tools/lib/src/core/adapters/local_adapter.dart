import 'package:alvic_tools/src/core/adapters/data_adapter.dart';
import 'package:alvic_tools/src/core/adapters/http_get_options.dart';

class LocalAdapter extends DataAdapter {
  @override
  Future<List<Map<String, dynamic>>> get<T>(
    String path, covariant HttpGetOptions options) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getOne<T>(String path, covariant HttpGetOptions options) {
    // TODO: implement getOne
    throw UnimplementedError();
  }

  @override
  Future<T> remove<T>(T data) {
    // TODO: implement remove
    throw UnimplementedError();
  }

  @override
  Future<T> save<T>(T data) {
    
    throw UnimplementedError();
  }

  @override
  Future<T> update<T>(T data) {
    // TODO: implement update
    throw UnimplementedError();
  }

}