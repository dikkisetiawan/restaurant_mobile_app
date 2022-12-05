class Review {
  bool? error;
  String? message;
  List<CustomerReviews>? customerReviews;

  Review({this.error, this.message, this.customerReviews});

  Review.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    if (json['customerReviews'] != null) {
      customerReviews = <CustomerReviews>[];
      json['customerReviews'].forEach((v) {
        customerReviews!.add(CustomerReviews.fromJson(v));
      });
    }
  }

  
}

class CustomerReviews {
  String? name;
  String? review;
  String? date;

  CustomerReviews({this.name, this.review, this.date});

  CustomerReviews.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    review = json['review'];
    date = json['date'];
  }
}
