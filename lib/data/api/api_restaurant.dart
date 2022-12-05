import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restorant/data/model/list_restaurant_model.dart';
import 'package:restorant/response.dart';
import 'package:restorant/data/api/const.dart';

Future<Response> getrestaurantlist() async {
  Response apiresponse = Response();

  try {
    final response = await http.get(Uri.parse("$baseUrl/list"));

    switch (response.statusCode) {
      case 200:
        apiresponse.data = ListRestaurant.fromJson(jsonDecode(response.body));
        break;
    }
  } catch (e) {
    apiresponse.error = serverError;
  }

  return apiresponse;
}
