import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_project/Data/constants.dart';

import "package:flutter_web_project/Data/hotel.dart";
import 'package:anim_search_bar/anim_search_bar.dart';

import 'package:flutter_web_project/Data/user.dart';
import 'package:flutter_web_project/Providers/controller.dart';
import 'package:flutter_web_project/Widgets/custom_alert_box.dart';

import 'package:flutter_web_project/Widgets/hotel_card.dart';
import 'package:provider/provider.dart';

class ManagerScreen extends StatefulWidget {
  @override
  State<ManagerScreen> createState() => _ManagerScreenState();
}

class _ManagerScreenState extends State<ManagerScreen> {
  //final Manager _manager = Manager();
  TextEditingController _nameController = TextEditingController();

  TextEditingController _capController = TextEditingController();

  TextEditingController _priceController = TextEditingController();

  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    var controller = Provider.of<Controller>(context, listen: false);
    controller.getManagerHotels();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Controller>(
      builder: (context, controller, child) {
        return Scaffold(
          body: SafeArea(
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
                          controller.managerSearchList(_searchController.text),
                      onSubmitted: (value) {
                        return controller
                            .managerSearchList(_searchController.text);
                      },
                    ),
                    SizedBox(
                      width: 400,
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: SingleChildScrollView(
                                child: Wrap(
                                  children: controller.getCardHotels(),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            FloatingActionButton(
                              onPressed: () => showBottomSheet(
                                  context: context,
                                  builder: (context) => Container(
                                        decoration: BoxDecoration(
                                          color: kBeigeColor,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20.0),
                                            topRight: Radius.circular(20.0),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            TextField(
                                              controller: _nameController,
                                              decoration: InputDecoration(
                                                labelText: "Hotel name",
                                                labelStyle: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            TextField(
                                              controller: _capController,
                                              decoration: InputDecoration(
                                                labelText: "Capacity",
                                                labelStyle: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            TextField(
                                              controller: _priceController,
                                              decoration: InputDecoration(
                                                labelText: "Room price",
                                                labelStyle: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            SizedBox(
                                              height: 20.0,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                FloatingActionButton(
                                                  backgroundColor: Colors.white,
                                                  onPressed: () {
                                                    if (_nameController
                                                            .text.isEmpty ||
                                                        _capController
                                                            .text.isEmpty ||
                                                        _priceController
                                                            .text.isEmpty) {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return CustomAlertBox(
                                                            "Please fill all of the fields.",
                                                          );
                                                        },
                                                      );
                                                    } else {
                                                      String name =
                                                          _nameController.text;
                                                      String cap =
                                                          _capController.text;
                                                      String price =
                                                          _priceController.text;
                                                      controller
                                                          .managerSaveOnPressed(
                                                              controller.user,
                                                              context,
                                                              name,
                                                              cap,
                                                              price);
                                                    }

                                                    controller.createHotel(
                                                        _nameController.text,
                                                        _capController.text,
                                                        _priceController.text);

                                                    _nameController.clear();
                                                    _capController.clear();
                                                    _priceController.clear();
                                                  },
                                                  child: Icon(
                                                    Icons.save,
                                                    color: kBeigeColor,
                                                  ),
                                                ),
                                                SizedBox(width: 10.0),
                                                FloatingActionButton(
                                                  backgroundColor: Colors.white,
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Icon(
                                                    Icons.cancel_presentation,
                                                    color: kBeigeColor,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )),
                              child: Icon(
                                Icons.add,
                                color: kBeigeColor,
                              ),
                              backgroundColor: Colors.white,
                            )
                          ],
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
