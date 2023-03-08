import 'package:flutter/material.dart';

class Hotel {
  String name; // Hotel name.
  int capacity; // Number of rooms available for booking.
  double price;
  Image image = Image.network(
      "https://images.pexels.com/photos/258154/pexels-photo-258154.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1");

  Hotel({
    this.name = "Unknown",
    this.capacity = 0,
    this.price = 0.0,
  });

  static Hotel fromJson(Map<String, dynamic> json) => Hotel(
        name: json['Name'],
        capacity: int.parse(json['Capacity']),
        price: double.parse(json['Price']),
      );

  factory Hotel.fromMap(Map<dynamic, dynamic> map) {
    return Hotel(
      name: map['Name'],
      capacity: map['Capacity'],
      price: map['Price'],
    );
  }
}
