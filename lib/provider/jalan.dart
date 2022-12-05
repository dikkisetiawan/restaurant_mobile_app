import 'package:restorant/provider/page_module.dart';
import 'package:restorant/provider/done_resto.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class jalankan extends StatelessWidget {
  const jalankan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DoneModuleProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const ModulePage(),
      ),
    );
  }
}