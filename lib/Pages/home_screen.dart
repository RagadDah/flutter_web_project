import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_project/Data/constants.dart';

import "package:flutter_web_project/Data/hotel.dart";
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter_web_project/Data/user.dart';
import 'package:flutter_web_project/Providers/controller.dart';
import 'package:flutter_web_project/Widgets/hotel_card.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    var controller = Provider.of<Controller>(context, listen: false);
    controller.getCustomerHotels();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Controller>(
      builder: (context, controller, child) {
        //controller.buildHotelCards();
        return Material(
          child: SafeArea(
            child: Column(
              // Main column to format the page.
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(width: 10.0),
                    Text(
                      // Upper text for the site name.

                      "Hotel booking",
                      style: TextStyle(
                        shadows: [kBoxShadow],
                        color: kBeigeColor,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Icon(
                      shadows: [kBoxShadow],
                      Icons.hotel,
                      color: kBeigeColor,
                    ),
                    SizedBox(width: 30.0),
                    AnimSearchBar(
                      searchIconColor: Colors.white,
                      textFieldIconColor: Colors.white,
                      color: kBeigeColor,
                      width: 300.0,
                      textController: _searchController,
                      onSuffixTap: () =>
                          controller.customerSearchList(_searchController.text),
                      onSubmitted: (value) =>
                          controller.customerSearchList(_searchController.text),
                    ),
                    SizedBox(
                      width: 400,
                    ),
                    FloatingActionButton(
                      onPressed: () =>
                          controller.customerCartViewOnPress(context),
                      child: Icon(
                        Icons.shopping_cart_checkout_outlined,
                        color: Colors.white,
                      ),
                      backgroundColor: kBeigeColor,
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        controller.clearAllLists();
                      },
                      child: Icon(
                        Icons.logout_outlined,
                        color: Colors.white,
                      ),
                      backgroundColor: kBeigeColor,
                    )
                  ],
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        kBoxShadow,
                      ],
                      color: kBeigeColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: SingleChildScrollView(
                          child: Wrap(
                            children: controller.getCardHotels(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
