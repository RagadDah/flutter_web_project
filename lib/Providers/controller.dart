import 'dart:io';
import 'dart:js';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_project/Data/constants.dart';

import 'package:flutter_web_project/Data/hotel.dart';

import 'package:flutter_web_project/Data/user.dart';
import 'package:flutter_web_project/Utils/util.dart';

import 'package:flutter_web_project/Widgets/hotel_card.dart';

class Controller extends ChangeNotifier {
  List<WebUser> _users = [];
  // List<Hotel> _hotels = [
  //   Hotel(name: "plaza"),
  //   Hotel(name: "just"),
  //   Hotel(name: "tahaluf"),
  //   Hotel(name: "plah"),
  // ];

  bool isLogin = true;
  WebUser user = WebUser();

  List<HotelCard> _searchList = [];
  final List<HotelCard> _cardHotels = [];

  String _name = "";
  int _cap = -1;
  double _price = -1.0;

  get getName {
    return _name;
  }

  get getCap {
    return _cap;
  }

  get getPrice {
    return _price;
  }

  void setUser(String email, String password, bool isManager) {
    user.email = email;
    user.password = password;
    user.isManager = isManager;
    notifyListeners();
  }

  Future signUp(BuildContext context, String email, String password,
      GlobalKey<FormState> formKey) async {
    final isValid = formKey.currentState!.validate();

    if (!isValid) return;

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseFirestore.instance
          .collection('Users')
          .doc('${email}')
          .get()
          .then((document) {
        user.isManager = document['isManager'];
        user.email = document['Email'];
        user.password = document['Password'];
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      Util.showSnackBar(e.message);
    }
  }

  Future logIn(WebUser user, String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // user.email = _email.text;
      // user.password = _password.text;
      await FirebaseFirestore.instance
          .collection('Users')
          .doc('${email}')
          .get()
          .then((document) {
        user.isManager = document['isManager'];
        user.email = document['Email'];
        user.password = document['Password'];
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      Util.showSnackBar(e.message);
    }
    notifyListeners();
  }

  void buildHotelCards() {
    //user.setHotels(user.getHotels);

    for (Hotel h in user.getHotels) {
      _cardHotels.add(HotelCard(hotel: h));
    }
    //notifyListeners();
  }

  void isManagerToggle(bool? value) {
    user.isManager = value;
    notifyListeners();
  }

  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  void setCap(int cap) {
    _cap = cap;
    notifyListeners();
  }

  void setPrice(double price) {
    _price = price;
    notifyListeners();
  }

  // get getHotels {
  //   return _hotels;
  // }

  List<HotelCard> getCardHotels() {
    return _cardHotels;
  }

  void toggle() {
    isLogin = !isLogin;
    notifyListeners();
  }

  void managerSearchList(String name) {
    _cardHotels.clear();
    for (Hotel h in user.getHotels) {
      if (h.name.contains(name)) {
        _cardHotels.add(HotelCard(hotel: h));
      }
    }

    notifyListeners();
  }

  void setUserHotels(List<Hotel> h) {
    user.setHotels(h);
  }

  void customerSearchList(String name) {
    _cardHotels.clear();
    for (Hotel h in user.getHotels) {
      if (h.name.contains(name)) {
        _cardHotels.add(HotelCard(hotel: h));
      }
    }

    notifyListeners();
  }

  void getCustomerHotels() async {
    _cardHotels.clear();
    user.clearHotels();

    final snapshot = FirebaseFirestore.instance.collection('Hotels');

    await snapshot.get().then((snapshot) {
      for (var document in snapshot.docs) {
        var h = Hotel(
            name: document['Name'],
            price: double.parse(document['Price']),
            capacity: int.parse(document['Capacity']));

        user.addHotels(h);
      }
    });
    buildHotelCards();
    notifyListeners();
  }

  void updateManagerHotel(
      String oldName, String newName, String cap, String price) {
    print(oldName);
    final managerHotelDoc = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.email)
        .collection('Hotels')
        .doc(oldName);

    final hotelDoc =
        FirebaseFirestore.instance.collection('Hotels').doc(oldName);

    managerHotelDoc.update({
      'Name': newName,
      'Price': price,
      'Capacity': cap,
    });

    hotelDoc.update({
      'Name': newName,
      'Price': price,
      'Capacity': cap,
    });

    getManagerHotels();
  }

  void getManagerHotels() async {
    _cardHotels.clear();
    user.clearHotels();
    final snapshot = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.email)
        .collection('Hotels');

    await snapshot.get().then((snapshot) {
      for (var document in snapshot.docs) {
        var h = Hotel(
            name: document['Name'],
            price: double.parse(document['Price']),
            capacity: int.parse(document['Capacity']));

        user.addHotels(h);
      }
    });
    buildHotelCards();
    notifyListeners();
  }

  void clearAllLists() {
    user.clearBookedHotels();
    user.clearHotels();
    _cardHotels.clear();
    notifyListeners();
  }

  // Stream<List<Hotel>> readHotels() => FirebaseFirestore.instance
  //     .collection('Users')
  //     .doc(user.email)
  //     .collection('Hotels')
  //     .snapshots()
  //     .map((snapshot) =>
  //         snapshot.docs.map((doc) => Hotel.fromJson(doc.data())).toList());

  Future createHotel(String name, String cap, String price) async {
    var managerRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.email)
        .collection('Hotels')
        .doc(name);

    var hotelRef = FirebaseFirestore.instance.collection('Hotels').doc(name);

    var id = Random().nextInt(999);

    final json = {
      'Capacity': cap,
      'Id': id,
      'Manager': user.email,
      'Name': name,
      'Price': price
    };

    await hotelRef.set(json);

    await managerRef.set(json);
  }

  Future<void Function()?> customerAddToCartOnPressed(
      Hotel hotel, BuildContext context) async {
    var json = {
      'Capacity': hotel.capacity.toString(),
      'Name': hotel.name,
      'Price': hotel.price.toString()
    };

    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.email)
          .collection('Hotels')
          .doc(hotel.name)
          .set(json);

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Hotel added to cart!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "OK",
                  style: TextStyle(
                    color: kBeigeColor,
                  ),
                ),
              ),
            ],
          );
        },
      );
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<void Function()?> customerCartViewOnPress(BuildContext context) async {
    user.clearBookedHotels();
    if (context.mounted) {
      final snapshot = FirebaseFirestore.instance
          .collection('Users')
          .doc(user.email)
          .collection('Hotels');

      await snapshot.get().then((snapshot) {
        for (var document in snapshot.docs) {
          var h = Hotel(
              name: document['Name'],
              price: double.parse(document['Price']),
              capacity: int.parse(document['Capacity']));

          user.addBookedHotels(h);

          print(user.getBookedHotelLength);
        }
      });
      showBottomSheet(
        backgroundColor: kBeigeColor,
        context: context,
        builder: (context) {
          return Container(
            height: 500.0,
            width: 500.0,
            child: Column(
              children: <Widget>[
                Text('Booked hotels',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 10.0,
                ),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: user.getBookedHotelLength,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.white,
                      shadowColor: Colors.black,
                      child: Column(
                        children: <Widget>[
                          Text("Hotel name: ${user.getBookedHotelName(index)}",
                              style: TextStyle(
                                  color: kBeigeColor,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold)),
                          Text(
                              "Hotel price: ${user.getBookedHotelPrice(index)}",
                              style: TextStyle(
                                  color: kBeigeColor,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                FloatingActionButton(
                  onPressed: () => Navigator.pop(context),
                  child: Icon(
                    Icons.cancel,
                    color: kBeigeColor,
                  ),
                  backgroundColor: Colors.white,
                ),
              ],
            ),
          );
        },
      );
      notifyListeners();
    }
  }

  void addHotelCards(WebUser manager, Hotel h) {
    _cardHotels.add(HotelCard(hotel: h));
  }

  void Function()? managerSaveOnPressed(WebUser manager, BuildContext context,
      String name, String cap, String price) {
    Hotel h =
        Hotel(name: name, capacity: int.parse(cap), price: double.parse(price));
    manager.addHotels(h);
    addHotelCards(manager, h);

    notifyListeners();
    Navigator.pop(context);
  }

  void Function()? managerSaveEditOnPress(Hotel hotel, BuildContext context,
      String name, String cap, String price) {
    hotel.name = name;
    hotel.capacity = int.parse(cap);
    hotel.price = double.parse(price);
    notifyListeners();
    Navigator.pop(context);
  }
}
