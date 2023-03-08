import 'package:flutter_web_project/Data/hotel.dart';
import 'package:flutter_web_project/Widgets/hotel_card.dart';

class WebUser {
  String name;
  String email;
  String password;
  bool? isManager; // Defines if the registered user is a manager of the site.

  List<Hotel> _hotels = [];
  List<Hotel> _bookedHotels = [];

  // Class constructor that takes the parameters and initializes the attributes.
  WebUser({
    this.name = "Unknown",
    this.email = "example@site.com",
    this.isManager = false,
    this.password = "",
  });

  static WebUser fromJson(Map<String, dynamic> json) => WebUser(
      password: json['Password'],
      email: json['Email'],
      isManager: json['isManager']);

  get getHotels {
    return _hotels;
  }

  get getHotelLength {
    return _hotels.length;
  }

  get getBookedHotels {
    return _bookedHotels;
  }

  get getBookedHotelLength {
    return _bookedHotels.length;
  }

  String getBookedHotelName(int index) {
    return _bookedHotels.elementAt(index).name;
  }

  double getBookedHotelPrice(int index) {
    return _bookedHotels.elementAt(index).price;
  }

  int getBookedHotelCap(int index) {
    return _bookedHotels.elementAt(index).capacity;
  }

  void clearBookedHotels() {
    _bookedHotels.clear();
  }

  void clearHotels() {
    _hotels.clear();
  }

  void addHotels(Hotel h) {
    _hotels.add(h);
  }

  void addBookedHotels(Hotel h) {
    _bookedHotels.add(h);
  }

  void setHotels(List<Hotel> h) {
    _hotels.clear();
    _hotels = h;
    // for (Hotel hotel in h) {
    //   if (!_hotels.contains(h)) _hotels.add(hotel);
    // }
  }
}
