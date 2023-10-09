import 'dart:convert';

import 'package:alvic_tools/src/core/adapters/data_adapter.dart';
import 'package:alvic_tools/src/core/adapters/http_get_options.dart';
import 'package:alvic_tools/src/core/config/alvic_tools_config.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class HttpAdapter implements DataAdapter {

  @override
  Future<List<Map<String, dynamic>>> get<T>(String path, covariant HttpGetOptions options) async {
    var response = await _callInternalGet(path, options);
    List<Map<String, dynamic>> mapped = [];
    (response as Iterable).forEach((element) {
      Map<String, dynamic> auxItem = element;
      mapped.add(auxItem);
    });
    return mapped;
  }

  @override
  Future<Map<String, dynamic>> getOne<T>(String path, covariant HttpGetOptions options) async {
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

  Future<dynamic> _callInternalGet(String path, HttpGetOptions options) async {
    AlvicToolsConfig config = GetIt.instance.get<AlvicToolsConfig>();
    Dio dio = GetIt.instance.get<Dio>();
    String url = config.baseUrl + path;
    if (options.paths.isNotEmpty) {
      url += options.paths;
    }
    print("---- Dio [Url]: $url");
    Response response = await dio.get(url, queryParameters: options.queries);
    if (options.sourceKey.isNotEmpty) {
      print("---- Dio [Response][SourceKey:${options.sourceKey}]: ${response.data[options.sourceKey]}");
      return response.data[options.sourceKey];
    }
    print("---- Dio [Response]: ${response.data}");
    return response.data;
  }

  @override
  Future<T> remove<T>(T data) {
    // TODO: implement remove
    throw UnimplementedError();
  }

  @override
  Future<T> save<T>(T data) {
    // TODO: implement save
    throw UnimplementedError();
  }

  @override
  Future<T> update<T>(T data) {
    // TODO: implement update
    throw UnimplementedError();
  }

}