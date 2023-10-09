import 'package:alvic_tools/alvic_tools.dart';
import 'package:rick_app/components/common/config/exceptions/project_exception.dart';

class FidelityConfig extends AlvicToolsConfig {
  @override
  String get baseUrl => "https://rickandmortyapi.com/api";
  
  @override
  AlvicInterceptor get interceptor => AlvicInterceptor(
    after: (response, handler) {
      try {
        print("Alvic interceptor after method: ${response.data}");
        response.data = response.data['results'];
        return response;
      } catch(e) {
        throw ProjectException("$e");
      }
    },
  );
}