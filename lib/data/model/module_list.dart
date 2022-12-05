import 'package:restorant/provider/done_resto.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModuleList extends StatelessWidget {
  final List<String> _moduleList = [
    'Melting Pot',
    'Istana Emas',
    'Drinky Squash',
    'Ampiran Kta',
    'Makan Mudah',
    'Tempat Siang Hari',
    'Rumah Senja',
    'Pasngsit Express',
  ];

  ModuleList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _moduleList.length,
      itemBuilder: (context, index) {
        return Consumer<DoneModuleProvider>(
          builder: (context, DoneModuleProvider data, widget) {
            return ModuleTile(
              moduleName: _moduleList[index],
              isDone: data.doneModuleList.contains(_moduleList[index]),
              onClick: () {
                data.complete(_moduleList[index]);
              },
            );
          },
        );
      },
    );
  }
}

class ModuleTile extends StatelessWidget {
  final String moduleName;
  final bool isDone;
  final Function() onClick;

  const ModuleTile({
    Key? key,
    required this.moduleName,
    required this.isDone,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(moduleName),
      trailing: isDone
          ? const Icon(Icons.done)
          : ElevatedButton(
              key: Key(moduleName),
              onPressed: onClick,
              child: const Text('Saya Setuju'),
            ),
    );
  }
}
