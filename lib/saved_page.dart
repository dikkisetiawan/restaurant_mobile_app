// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:restorant/home/detail.dart';
import 'package:restorant/data/model/list_restaurant_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({Key? key}) : super(key: key);

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  // ignore: prefer_typing_uninitialized_variables
  var database;

  List<Restaurants> saved = <Restaurants>[];

//open database
  Future initDb() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'save.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE saved(id TEXT, name TEXT, description TEXT, pictureId TEXT, city TEXT, rating TEXT)',
        );
      },
      version: 1,
    );

    getsaved().then((value) {
      setState(() {
        saved = value;
      });
    });
  }

//Read
  Future<List<Restaurants>> getsaved() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('saved');
    print(saved.toString());

    return List.generate(maps.length, (i) {
      return Restaurants(
        id: maps[i]['id'] as String,
        name: maps[i]['name'] as String,
        description: maps[i]['description'] as String,
        pictureId: maps[i]['pictureId'] as String,
        city: maps[i]['city'],
        rating: maps[i]['rating'],
      );
    });
  }

//Delete data
  Future<void> deleteResult(String? id) async {
    final db = await database;
    await db.delete(
      'saved',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  void initState() {
    super.initState();
    initDb();
  }

  @override
  Widget build(BuildContext context) {
    if (saved.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 244, 244, 244),
          automaticallyImplyLeading: false,
          elevation: 0,
          title: const Text(
            "Favorite",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
          ),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailrestoranPage(
                        restaurants: saved[index],
                      ),
                    )).then((value) => initDb());
              },
              child: Container(
                margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [popupmenumorefav(index)],
                    ),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 20),
                          width: 90,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                                image: NetworkImage(
                                    "https://restaurant-api.dicoding.dev/images/medium/${saved[index].pictureId}"),
                                fit: BoxFit.fill),
                          ),
                        ),
                        SizedBox(
                          height: 80,
                          child: Column(
                            children: [
                              Container(
                                width: 180,
                                child: Text(
                                  saved[index].name.toString(),
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                width: 180,
                                child: Text(
                                  saved[index].city.toString(),
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 69, 69, 69)),
                                ),
                              ),
                              Container(
                                width: 180,
                                child: Row(
                                  children: [
                                    RatingBarIndicator(
                                      rating: double.parse(
                                          saved[index].rating.toString()),
                                      itemBuilder: (context, index) =>
                                          const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      itemCount: 5,
                                      itemSize: 18,
                                      direction: Axis.horizontal,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      child:
                                          Text(saved[index].rating.toString()),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: saved.length,
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 244, 244, 244),
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          elevation: 0,
          title: const Text(
            "Favorite",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 244, 244, 244),
        body: Center(
          child: Container(
            margin: const EdgeInsets.only(top: 140),
            child: Column(
              children: [
                Image.asset(
                  "Image/notdatasearch.jpg",
                  height: 200,
                ),
                const Text(
                  "You haven't added a favorite",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget popupmenumorefav(int index) {
    return PopupMenuButton(
        onSelected: (result) {
          if (result == 0) {
            showDialog(
              context: this.context,
              builder: (ctx) => AlertDialog(
                title: Text("Delete ${saved[index].name}"),
                content: Text(
                    "Are you sure you want to remove ${saved[index].name} from your saved list?"),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.pop(this.context);
                      },
                      child: const Text("No")),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(this.context);
                        deleteResult(saved[index].id!).then((value) {
                          getsaved().then((value) {
                            setState(() {
                              saved = value;
                            });
                          });
                        });
                      },
                      child: const Text("Yes")),
                ],
              ),
            );
          }
        },
        child: const Icon(
          Icons.more_vert,
          color: Colors.black,
        ),
        itemBuilder: (context) => [
              PopupMenuItem(
                  value: 0,
                  child: Row(
                    children: const [
                      Icon(
                        Icons.delete_rounded,
                        color: Colors.black,
                        size: 15,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          'Delete',
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      ),
                    ],
                  )),
            ]);
  }
}
