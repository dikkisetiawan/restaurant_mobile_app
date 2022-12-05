import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restorant/data/model/detail_restaurant_model.dart';
import 'package:restorant/data/model/review_model.dart';
import 'package:restorant/response.dart';
import 'package:restorant/data/api/const.dart';

Future<Response> getdetailresto(String? id) async {
  Response apiresponse = Response();

  try {
    final response = await http.get(Uri.parse("$baseUrl/detail/$id"));

    switch (response.statusCode) {
      case 200:
        apiresponse.data = DetailRestaurant.fromJson(jsonDecode(response.body));
        break;
    }
  } catch (e) {
    apiresponse.error = serverError;
  }

  return apiresponse;
}

Future<Response> getdrinks(String? id) async {
  Response apiresponsedrink = Response();

  try {
    final responsedrink = await http.get(Uri.parse("$baseUrl/detail/$id"));

    switch (responsedrink.statusCode) {
      case 200:
        apiresponsedrink.data = Drinks.fromJson(jsonDecode(responsedrink.body));
        break;
    }
  } catch (e) {
    apiresponsedrink.error = serverError;
  }

  return apiresponsedrink;
}

Future<Response> getfoods(String? id) async {
  Response apiresponsefood = Response();

  try {
    final responsefood = await http.get(Uri.parse("$baseUrl/detail/$id"));

    switch (responsefood.statusCode) {
      case 200:
        apiresponsefood.data = Foods.fromJson(jsonDecode(responsefood.body));
        break;
    }
  } catch (e) {
    apiresponsefood.error = serverError;
  }

  return apiresponsefood;
}

// ignore: non_constant_identifier_names
Future<Response> PostReview(String id, String name, String review) async {
  Response apiresponse = Response();
  try {
    final response = await http.post(Uri.parse("$baseUrl/review"), headers: {
      'Accept': 'application/json'
    }, body: {
      'id': id,
      'name': name,
      'review': review,
    });

    switch (response.statusCode) {
      case 200:
        apiresponse.data = Review.fromJson(jsonDecode(response.body));
        break;
    }
  } catch (e) {
    apiresponse.error = serverError;
  }
  return apiresponse;
}
