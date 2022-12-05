import 'package:flutter/material.dart';
import 'package:restorant/data/api/api_detail.dart';
import 'package:restorant/data/model/detail_restaurant_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:restorant/data/model/list_restaurant_model.dart';
import 'package:restorant/response.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
// ignore: must_be_immutable
class DetailrestoranPage extends StatefulWidget {
  DetailrestoranPage({Key? key, required this.restaurants}) : super(key: key);
  Restaurants restaurants;

  @override
  State<DetailrestoranPage> createState() => _DetailrestoranState();
}

class _DetailrestoranState extends State<DetailrestoranPage> {
  var database;
  bool onthefav = false;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  final TextEditingController _name = TextEditingController();
  final TextEditingController _review = TextEditingController();

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
    onthefav = await read(widget.restaurants.name);
    setState(() {});
  }

  //Read
  Future<bool> read(String? name) async {
    final Database db = await database;
    final data = await db.query('saved', where: "name = ?", whereArgs: [name]);
    if (data.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  //delete
  Future<void> delete(Restaurants? restaurants) async {
    final db = await database;
    await db.delete(
      'saved',
      where: "name = ?",
      whereArgs: [restaurants!.name],
    );
    setState(() {
      onthefav = false;
    });
  }

//Insert data dari api ke database
  Future<void> insertApi(Restaurants restaurants) async {
    final db = await database;
    await db.insert(
      'saved',
      restaurants.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    setState(() {
      onthefav = true;
    });
  }

  bool isload = true;
  bool succes = false;
  DetailRestaurant? detailrestoran;
  Drinks? drinks;
  Foods? foods;
  void getdata() async {
    Response response = await getdetailresto(widget.restaurants.id);

    if (response.error == null) {
      setState(() {
        detailrestoran = response.data as DetailRestaurant;
      });
      Response responsedrink = await getdrinks(widget.restaurants.id);
      if (responsedrink.error == null) {
        setState(() {
          drinks = responsedrink.data as Drinks;
        });
        Response responsefood = await getfoods(widget.restaurants.id);
        if (responsefood.error == null) {
          setState(() {
            foods = responsefood.data as Foods;
            succes = true;
            isload = false;
          });
        }
      }
    } else {
      setState(() {
        succes = false;
        isload = false;
      });
    }
  }

  void postreview() async {
    Response responsepost = await PostReview(
        widget.restaurants.id.toString(), _name.text, _review.text);

    if (responsepost.error == null) {
      getdata();
      setState(() {
        _name.text = "";
        _review.text = "";
      });
    } else {
      isload = false;
      ScaffoldMessenger.of(this.context)
          .showSnackBar(const SnackBar(content: Text('Error')));
    }
  }

  @override
  void initState() {
    initDb();
    getdata();
    // ignore: todo
    // TODO: implement initState
    super.initState();
    // initDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: isload
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  "https://restaurant-api.dicoding.dev/images/medium/${detailrestoran!.restaurant!.pictureId}"),
                              fit: BoxFit.fill)),
                    ),
                    Container(
                      height: 200,
                      color: const Color.fromARGB(111, 0, 0, 0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  )),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(left: 260),
                                  child: IconButton(
                                    onPressed: () {
                                      onthefav
                                          ? delete(widget.restaurants)
                                          : insertApi(widget.restaurants);
                                    },
                                    icon: onthefav
                                        ? const Icon(
                                            Icons.bookmark,
                                            color: Colors.blue,
                                          )
                                        : const Icon(
                                            Icons.bookmark_border_rounded,
                                            color: Colors.white,
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 243, 243, 243),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15))),
                      margin: const EdgeInsets.only(top: 180),
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 5),
                              width: double.infinity,
                              child: Text(
                                detailrestoran!.restaurant!.name.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(3),
                              width: double.infinity,
                              child: Row(
                                children: [
                                  RatingBarIndicator(
                                    rating: double.parse(detailrestoran!
                                        .restaurant!.rating
                                        .toString()),
                                    itemBuilder: (context, index) => const Icon(
                                      Icons.star,
                                      color: Colors.blue,
                                    ),
                                    itemCount: 5,
                                    itemSize: 18,
                                    direction: Axis.horizontal,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: Text(detailrestoran!
                                        .restaurant!.rating
                                        .toString()),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(top: 5, left: 5),
                              child: Text(
                                detailrestoran!.restaurant!.city.toString(),
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: Color.fromARGB(255, 155, 155, 155)),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(top: 5, left: 5),
                              child: Text(
                                detailrestoran!.restaurant!.address.toString(),
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 67, 67, 67)),
                              ),
                            ),
                            Container(
                                height: 50,
                                width: 300,
                                margin: const EdgeInsets.only(right: 24),
                                child: getcatgorylist()),
                            Container(
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                detailrestoran!.restaurant!.description
                                    .toString(),
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [getDrink(), getfood()],
                            ),
                            Container(
                              padding: const EdgeInsets.all(5),
                              child: getreview(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget getfood() {
    return Container(
      width: 120,
      margin: const EdgeInsets.all(10),
      child: ElevatedButton.icon(
          onPressed: () {
            showModalBottomSheet<int>(
              backgroundColor: Colors.transparent,
              context: this.context,
              builder: (context) {
                return Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 114, 114, 114),
                              borderRadius: BorderRadius.circular(20)),
                          alignment: Alignment.center,
                          height: 5,
                          width: 120,
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 340,
                          child: ListView.builder(
                            itemCount: detailrestoran!
                                .restaurant!.menus!.foods!.length,
                            itemBuilder: (BuildContext context, int i) {
                              return Container(
                                margin: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    const Icon(Icons.food_bank_rounded),
                                    Container(
                                      margin: const EdgeInsets.only(left: 20),
                                      child: Text(
                                        detailrestoran!
                                            .restaurant!.menus!.foods![i].name
                                            .toString(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          icon: const Icon(Icons.food_bank_rounded),
          label: const Text("Food")),
    );
  }

  Widget getDrink() {
    return Container(
      width: 120,
      margin: const EdgeInsets.all(10),
      child: ElevatedButton.icon(
          onPressed: () {
            showModalBottomSheet<int>(
              backgroundColor: Colors.transparent,
              context: this.context,
              builder: (context) {
                return Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 114, 114, 114),
                              borderRadius: BorderRadius.circular(20)),
                          alignment: Alignment.center,
                          height: 5,
                          width: 120,
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 340,
                          child: ListView.builder(
                            itemCount: detailrestoran!
                                .restaurant!.menus!.drinks!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    const Icon(Icons.local_drink_rounded),
                                    Container(
                                      margin: const EdgeInsets.only(left: 20),
                                      child: Text(
                                        detailrestoran!.restaurant!.menus!
                                            .drinks![index].name
                                            .toString(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          icon: const Icon(Icons.local_drink_rounded),
          label: const Text("Drinks")),
    );
  }

  Widget getcatgorylist() {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: detailrestoran!.restaurant!.categories!.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 5),
              padding:
                  const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(5)),
              child: Text(
                  detailrestoran!.restaurant!.categories![index].name
                      .toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Widget getreview() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            vertical: 12.0,
          ),
          alignment: Alignment.bottomLeft,
          child: const Text(
            'Kirim Ulasan',
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 21, fontWeight: FontWeight.w700, color: Colors.blue),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                Container(
                  width: 300,
                  margin: const EdgeInsets.only(top: 10),
                  child: TextFormField(
                    controller: _name,
                    validator: (val) =>
                        val!.isEmpty ? 'Mohon isi nama anda' : null,
                    decoration: const InputDecoration(
                        hintText: 'Masukkan Nama Anda', labelText: 'Nama'),
                  ),
                ),
                Container(
                  width: 300,
                  margin: const EdgeInsets.only(top: 10),
                  child: TextFormField(
                    controller: _review,
                    validator: (val) =>
                        val!.isEmpty ? 'Mohon isi ulasan anda' : null,
                    decoration: const InputDecoration(
                        hintText: 'Masukkan Ulasan Anda', labelText: 'Ulasan'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                          onPressed: () {
                            if (formkey.currentState!.validate()) {
                              setState(() {
                                isload = true;
                              });
                              postreview();
                            }
                          },
                          icon: const Icon(Icons.send),
                          label: const Text("Send "))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(
            vertical: 14.0,
          ),
          child: Column(
            children: [
              Container(
                alignment: Alignment.bottomLeft,
                child: const Text(
                  'Semua Ulasan',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                width: double.infinity,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount:
                      detailrestoran!.restaurant!.customerReviews!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          width: 320,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      width: 280,
                                      child: Text(
                                        detailrestoran!.restaurant!
                                            .customerReviews![index].name
                                            .toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 2, bottom: 5),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        width: 280,
                                        child: Text(
                                          detailrestoran!.restaurant!
                                              .customerReviews![index].date
                                              .toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Color.fromARGB(
                                                  255, 175, 175, 175)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      width: 280,
                                      child: Text(
                                        detailrestoran!.restaurant!
                                            .customerReviews![index].review
                                            .toString(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
