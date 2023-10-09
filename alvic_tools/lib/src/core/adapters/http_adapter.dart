import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:alvic_tools/src/core/adapters/data_adapter.dart';
import 'package:alvic_tools/src/core/adapters/http_options.dart';
import 'package:alvic_tools/src/core/config/alvic_tools_config.dart';

class HttpAdapter implements DataAdapter {

  @override
  Future<List<Map<String, dynamic>>> get<T>(String path, covariant HttpOptions options) async {
    print('---- Dio [RequestType][Many]');
    var response = await _callInternalGet(path, options);
    List<Map<String, dynamic>> mapped = [];
    (response as Iterable).forEach((element) {
      try {
        Map<String, dynamic> auxItem = element;
        mapped.add(auxItem);
      } catch (e) {}
    });
    return mapped;
  }

  @override
  Future<Map<String, dynamic>> getOne<T>(String path, covariant HttpOptions options) async {
    print('---- Dio [RequestType][Single]');
    var response = await _callInternalGet(path, options) as Map<String, dynamic>;
    Map<String, dynamic> auxItem = {};
    try {
      (response as Iterable).forEach((mapElement) {
        auxItem.addAll(mapElement);
      });
    } catch (e) {}
    return auxItem;
  }

  Future<dynamic> _callInternalGet(String path, HttpOptions options) async {
    AlvicToolsConfig config = GetIt.instance.get<AlvicToolsConfig>();
    Dio dio = GetIt.instance.get<Dio>();
    String url = config.baseUrl + path;
    if (options.paths.isNotEmpty) {
      url += options.paths;
    }
    Response response;
    if (options.headers.isNotEmpty) {
      response = await dio.get(url, queryParameters: options.queries, options: Options(
        headers: options.headers
      ));
    } else {
      response = await dio.get(url, queryParameters: options.queries);
    }
    return response.data;
  }

  @override
  Future<bool> remove<T>(String path, covariant HttpOptions options) async {
    // TODO: implement remove
    throw UnimplementedError();
  }

  @override
  Future<bool> save(String path, List<Map<String, dynamic>> data, covariant HttpOptions options) async {
    AlvicToolsConfig config = GetIt.instance.get<AlvicToolsConfig>();
    Dio dio = GetIt.instance.get<Dio>();
    String url = config.baseUrl + path;
    if (options.headers.isNotEmpty) {
      await dio.post(url, data: data.first, options: Options(headers: options.headers));
      return true;
    }
    await dio.post(url, data: data.first);
    return true;
  }

  @override
  Future<bool> update<T>(String path, List<Map<String, dynamic>> data, covariant HttpOptions options) {
    throw UnimplementedError();
  }
  
  @override
  Future<void> clear(String path) {
    throw UnimplementedError();
  }
}