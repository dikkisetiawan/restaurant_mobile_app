import 'package:flutter/material.dart';


class SearchPagedefault extends StatefulWidget {
  const SearchPagedefault({Key? key}) : super(key: key);

  @override
  State<SearchPagedefault> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<SearchPagedefault> {
  final TextEditingController _search = TextEditingController();

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 243, 243, 243),
        body: ListView(children: [
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back)),
                Container(
                  width: 285,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    title: TextField(
                      controller: _search,
                      decoration: const InputDecoration(
                          hintText: 'Search', border: InputBorder.none),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.search,
                        size: 20,
                      ),
                      onPressed: () {
                        if (_search.text != "") {
                          Navigate_to_search2(context);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Center(
              child: Column(
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 100),
                  child: Image.asset(
                    "Image/searchlogo.png",
                    height: 250,
                  )),
              const SizedBox(
                width: 300,
                child: Text(
                  "Ayo Cari Restoran Yang Kamu Minati",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ))
        ]));
  }

  // ignore: non_constant_identifier_names
  Future<void> Navigate_to_search2(BuildContext context) async {
    if (!mounted) return;
    setState(() {
      _search.text = "";
    });
  }
}
