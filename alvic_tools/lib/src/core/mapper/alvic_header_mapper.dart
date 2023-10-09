import 'package:alvic_tools/alvic_tools.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class AlvicHeaderMapper {
  final List<String> headers;
  const AlvicHeaderMapper({
    required this.headers
  });
  
  getAsMap() {
    Map<String, dynamic> headerAsMap = {};
    for (String element in headers) {
      headerAsMap[element] = GetIt.I.get<AlvicContainer>().getContent(element);
    }
    return headerAsMap;
  }
}