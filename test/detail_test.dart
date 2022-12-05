import 'package:flutter_test/flutter_test.dart';
import 'package:restorant/data/Model/detail_restaurant_model.dart';

void main() {
  Restaurant r;
  r = Restaurant();

  group("testing Json", () {
    test("Cek Review", () {
      expect(r.customerReviews, equals(r.customerReviews));
    });
    test("Cek Name", () {
      expect(r.name, equals(r.name));
    });
    test("Cek Adders", () {
      expect(r.address, equals(r.address));
    });
    test("Cek Categories", () {
      expect(r.categories, equals(r.categories));
    });
    test("Cek Menu", () {
      expect(r.menus, equals(r.menus));
    });
    test("Cek Desc", () {
      expect(r.description, equals(r.description));
    });
    test("Cek City", () {
      expect(r.city, equals(r.city));
    });
    test("Cek Rating", () {
      expect(r.rating, equals(r.rating));
    });
    test("Cek ID", () {
      expect(r.id, equals(r.id));
    });
  });
}
