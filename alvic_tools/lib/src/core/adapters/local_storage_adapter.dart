import 'package:alvic_tools/src/core/adapters/data_adapter.dart';
import 'package:alvic_tools/src/core/adapters/local_storage_options.dart';
import 'package:alvic_tools/src/core/mapper/alvic_mapper.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalStorageAdapter extends DataAdapter {

  @override
  Future<List<Map<String, dynamic>>> get<T>(String path, covariant LocalStorageOptions options) async {
    var box = await Hive.openBox(path);
    List<dynamic> result = box.get(path) ?? [];
    print("hive [get]: $result");
    await box.close();
    List<Map<String, dynamic>> mapped = [];
    (result as Iterable).forEach((element) {
      try {
        Map<String, dynamic> auxItem = element;
        mapped.add(auxItem);
      } catch(e) {}
    });
    return mapped;
  }

  @override
  Future<Map<String, dynamic>> getOne<T>(String path, covariant LocalStorageOptions options) async {
    var box = await Hive.openBox(path);
    List<dynamic> result = box.get(path);
    print("hive [get one]: ${result.first}");
    await box.close();
    Map<String, dynamic> mapped = {};
    (result.first).forEach((key, val) {
      // print("hive [$key]: ${val}");
      try {
        mapped[key] = val;
      } catch(e) {}
    });
    return mapped;
  }

  @override
  Future<bool> remove<T>(String path, covariant LocalStorageOptions options) async {
    var box = await Hive.openBox(path);
    await box.clear();
    await box.close();
    return true;
  }

  @override
  Future<bool> save(String path, List<Map<String, dynamic>> data, covariant LocalStorageOptions options) async {
    var box = await Hive.openBox(path);
    await box.put(path, data);
    print("hive [save]: $data");
    await box.close();
    return true;
  }

  @override
  Future<bool> update<T>(String path, List<Map<String, dynamic>> data, covariant LocalStorageOptions options) async {
    await remove(path, options);
    await save(path, data, options);
    return true;
  }
  
  @override
  Future<void> clear(String path) async {
    var box = await Hive.openBox(path);
    await box.clear();
    await box.close();
  }

}