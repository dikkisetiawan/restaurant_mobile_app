import 'package:flutter/material.dart';
import 'package:restorant/home/detail.dart';
import 'package:restorant/data/api/api_search.dart';
import 'package:restorant/data/model/list_restaurant_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:restorant/response.dart';

// ignore: must_be_immutable
class SearchPage extends StatefulWidget {
  SearchPage({Key? key, required this.query}) : super(key: key);
  String query;

  @override
  State<SearchPage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<SearchPage> {
  ListRestaurant? listRestaurant;
  bool isload = true;
  double? rate;
  bool succes = false;

  final TextEditingController _search = TextEditingController();

  void getsearch() async {
    setState(() {
      _search.text = widget.query.toString();
    });
    Response response = await getsearchdata(widget.query);

    if (response.error == null) {
      setState(() {
        listRestaurant = response.data as ListRestaurant;
        succes = true;
        isload = false;
      });
    } else {
      setState(() {
        succes = false;
        isload = false;
      });
    }
  }

  @override
  void initState() {
    getsearch();
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
                Expanded(
                  child: Container(
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
                            setState(() {
                              widget.query = _search.text;
                              isload = true;
                              getsearch();
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          isload
              ? Center(
                  child: Container(
                      margin: const EdgeInsets.only(top: 250),
                      child: const CircularProgressIndicator()))
              : succes
                  ? searchscreen()
                  : Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 80),
                      child: Column(
                        children: [
                          Image.asset(
                            "Image/connectionerror.png",
                            height: 300,
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  isload = true;
                                  getsearch();
                                });
                              },
                              icon: const Icon(Icons.refresh))
                        ],
                      ),
                    )
        ]));
  }

  Widget searchscreen() {
    if (listRestaurant!.restaurants!.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: listRestaurant!.restaurants!.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailrestoranPage(
                      restaurants: listRestaurant!.restaurants![index],
                    ),
                  ));
            },
            child: Container(
              margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 20),
                    width: 90,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                          image: NetworkImage(
                              "https://restaurant-api.dicoding.dev/images/medium/${listRestaurant!.restaurants![index].pictureId}"),
                          fit: BoxFit.fill),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 80,
                      child: Column(
                        children: [
                          SizedBox(
                            width: 180,
                            child: Text(
                              listRestaurant!.restaurants![index].name
                                  .toString(),
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            width: 180,
                            child: Text(
                              listRestaurant!.restaurants![index].city
                                  .toString(),
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 69, 69, 69)),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              width: 180,
                              child: Row(
                                children: [
                                  RatingBarIndicator(
                                    rating: double.parse(listRestaurant!
                                        .restaurants![index].rating
                                        .toString()),
                                    itemBuilder: (context, index) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    itemSize: 18,
                                    direction: Axis.horizontal,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: Text(listRestaurant!
                                        .restaurants![index].rating
                                        .toString()),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      return Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 100, bottom: 20),
              child: Image.asset(
                "Image/notdatasearch.jpg",
                height: 200,
              ),
            ),
            const Text(
              "Data Not Found",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ],
        ),
      );
    }
  }
}
