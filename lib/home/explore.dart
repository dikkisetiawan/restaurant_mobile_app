import 'package:flutter/material.dart';
import 'package:restorant/home/detail.dart';
import 'package:restorant/data/api/api_restaurant.dart';
import 'package:restorant/login_&_register/login.dart';
import 'package:restorant/data/model/list_restaurant_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:restorant/response.dart';
import 'package:restorant/search/searchscreen.dart';


class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  ListRestaurant? listRestaurant;
  bool isload = true;
  bool succes = false;
  double? rate;

  final TextEditingController _search = TextEditingController();

  void getdata() async {
    Response response = await getrestaurantlist();

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
    getdata();
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: ListView(
        children: [
          Stack(
            children: [
              imagebanner(),
              popupmenu(),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 243, 243, 243),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))),
                margin: const EdgeInsets.only(top: 180),
                child: Container(
                    margin: const EdgeInsets.only(top: 40),
                    padding: const EdgeInsets.all(10),
                    child: isload
                        ? Center(
                            child: Container(
                                margin: const EdgeInsets.only(top: 200),
                                child: const CircularProgressIndicator()))
                        : succes
                            ? Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        "Kami Bantu Rekomendasiin Buat Kamu Nih 😉",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount:
                                                  MediaQuery.of(context)
                                                              .orientation ==
                                                          Orientation.landscape
                                                      ? 3
                                                      : 2,
                                              crossAxisSpacing: 8,
                                              mainAxisSpacing: 8,
                                              childAspectRatio: 200 / 250),
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount:
                                          listRestaurant!.restaurants!.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailrestoranPage(
                                                  restaurants: listRestaurant!
                                                      .restaurants![index],
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                Container(
                                                  margin:
                                                      const EdgeInsets.all(20),
                                                  width: 100,
                                                  height: 70,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            "https://restaurant-api.dicoding.dev/images/medium/${listRestaurant!.restaurants![index].pictureId}"),
                                                        fit: BoxFit.fill),
                                                  ),
                                                ),
                                                Text(
                                                  listRestaurant!
                                                      .restaurants![index].name
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                ),
                                                Text(
                                                  listRestaurant!
                                                      .restaurants![index].city
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 119, 119, 119)),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 10, top: 30),
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  width: double.infinity,
                                                  child: Row(
                                                    children: [
                                                      RatingBarIndicator(
                                                        rating: double.parse(
                                                            listRestaurant!
                                                                .restaurants![
                                                                    index]
                                                                .rating
                                                                .toString()),
                                                        itemBuilder:
                                                            (context, index) =>
                                                                const Icon(
                                                          Icons.star,
                                                          color: Colors.blue,
                                                        ),
                                                        itemCount: 5,
                                                        itemSize: 18,
                                                        direction:
                                                            Axis.horizontal,
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10),
                                                          child: Text(
                                                              listRestaurant!
                                                                  .restaurants![
                                                                      index]
                                                                  .rating
                                                                  .toString()),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(top: 20),
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
                                            getdata();
                                          });
                                        },
                                        icon: const Icon(Icons.refresh))
                                  ],
                                ),
                              )),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 150),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    width: 300,
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
                            Navigate_to_search(context);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget imagebanner() {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('Image/banner.jpg'), fit: BoxFit.fill)),
    );
  }

  Widget popupmenu() {
    return Container(
      height: 200,
      color: const Color.fromARGB(181, 0, 0, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: PopupMenuButton(
                      onSelected: (result) {
                        if (result == 0) {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("Logout"),
                              content: const Text("Are you sure to logout?"),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("No")),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginPage(),
                                          ),
                                          (route) => false);
                                    },
                                    child: const Text("Yes")),
                              ],
                            ),
                          );
                        }
                      },
                      child: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ),
                      itemBuilder: (context) => [
                            PopupMenuItem(
                                value: 0,
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.logout,
                                      color: Colors.red,
                                      size: 15,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                        'Logout',
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.red),
                                      ),
                                    ),
                                  ],
                                )),
                          ]))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 20),
                child: const Text(
                  "Explore",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Haloo👋, Mau makan apa hari ini?",
                style: TextStyle(fontSize: 12, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Future<void> Navigate_to_search(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SearchPage(
                query: _search.text,
              )),
    );
    if (!mounted) return;
    setState(() {
      isload = true;
      _search.text = "";
      getdata();
    });
  }
}
