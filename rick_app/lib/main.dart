import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alvic_tools/alvic_tools.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rick_app/components/characters/domain/use_cases/get_characters.dart';
import 'package:rick_app/components/common/config/fidelity_config.dart';
import 'package:rick_app/components/common/config/injector.dart';
import 'package:rick_app/components/common/data/character_dto.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AlvicToolsInitializer(
    config: FidelityConfig()
  ).init();
  Injector().inject();
  // final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.initFlutter();
  SystemChrome.setPreferredOrientations([]).then((value) => runApp(const Main()));
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _Main();
}

class _Main extends State<Main> {
  List<CharacterDto> chars = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text("Rick & Morty")),
        body: Container(
          color: Colors.indigo,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Center(
                  child: IconButton(
                      onPressed: () async {
                        List<CharacterDto> charsTemp = await const GetCharacters().call();
                        setState(() {
                          chars = charsTemp;
                        });
                      }, 
                      icon: const Icon(Icons.play_arrow)
                    ),
                )
              ),
              Expanded(
                flex: 4,
                child: ListView.builder(
                  itemCount: chars.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      width: double.infinity,
                      height: 50.0,
                      color: Colors.amberAccent,
                      child: ListTile(
                        title: Text(chars[index].name))
                    );
                  }
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
