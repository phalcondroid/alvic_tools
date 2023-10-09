class AlvicMapper {
  
  List<Map<String, dynamic>> mapList(List<dynamic> list) {
    return list.map((item) {
      print(item.runtimeType);
      Map<String, dynamic> auxItem = {};
      return {"": 1};
    }).toList();
  }

  Map<String, dynamic> mapMap(Map<dynamic, dynamic> dynamic) {
    return {"": 1};
  }
}