import 'package:get_it/get_it.dart';

class AlvicInjector {

  final void Function(GetIt injector)? inject;
  
  const AlvicInjector({
    this.inject
  });
}