import 'package:flutter/material.dart';
import 'package:flutter_web_project/Data/constants.dart';

import 'package:flutter_web_project/Data/hotel.dart';

import 'package:flutter_web_project/Data/user.dart';
import 'package:flutter_web_project/Providers/controller.dart';
import 'package:flutter_web_project/Widgets/custom_alert_box.dart';

import 'package:provider/provider.dart';

class HotelCard extends StatelessWidget {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _capController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  Hotel hotel = Hotel(name: "Unknown", capacity: 0, price: 0.0);

  HotelCard({required this.hotel});

  @override
  Widget build(BuildContext context) {
    return Consumer<Controller>(
      builder: (context, controller, child) {
        return Padding(
          padding: EdgeInsets.all(2.0),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            child: Container(
              width: 300.0,
              decoration: BoxDecoration(
                boxShadow: [kBoxShadow],
                color: Color(0xffecf8f8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.network(
                      "https://images.pexels.com/photos/258154/pexels-photo-258154.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
                  Text(
                    "${hotel.name}",
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text("${hotel.price} JOD per/day"),
                  SizedBox(
                    height: 25.0,
                  ),
                  Center(
                    child: FloatingActionButton(
                      heroTag: UniqueKey(),
                      onPressed: () => controller.user.isManager == true
                          ? showDialog(
                              context: context,
                              builder: (context) {
                                return Material(
                                  child: Container(
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
                                            labelStyle:
                                                TextStyle(color: Colors.white),
                                          ),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        TextField(
                                          controller: _capController,
                                          decoration: InputDecoration(
                                            labelText: "Capacity",
                                            labelStyle:
                                                TextStyle(color: Colors.white),
                                          ),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        TextField(
                                          controller: _priceController,
                                          decoration: InputDecoration(
                                            labelText: "Room price",
                                            labelStyle:
                                                TextStyle(color: Colors.white),
                                          ),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            FloatingActionButton(
                                              heroTag: UniqueKey(),
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
                                                  controller.updateManagerHotel(
                                                      hotel.name,
                                                      _nameController.text,
                                                      _capController.text,
                                                      _priceController.text);
                                                  controller
                                                      .managerSaveEditOnPress(
                                                    hotel,
                                                    context,
                                                    name,
                                                    cap,
                                                    price,
                                                  );

                                                  _nameController.clear();
                                                  _capController.clear();
                                                  _priceController.clear();
                                                }
                                              },
                                              child: Icon(
                                                Icons.save,
                                                color: kBeigeColor,
                                              ),
                                            ),
                                            SizedBox(width: 10.0),
                                            FloatingActionButton(
                                              heroTag: UniqueKey(),
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
                                  ),
                                );
                              })
                          : controller.customerAddToCartOnPressed(
                              hotel,
                              context,
                            ),
                      backgroundColor: kBeigeColor,
                      child: controller.user.isManager == true
                          ? Icon(Icons.edit)
                          : Icon(Icons.add_rounded),
                    ),
                  ),
                  SizedBox(
                    height: 3.0,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
