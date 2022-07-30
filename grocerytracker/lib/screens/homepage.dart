import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocerytracker/database/dbFunctionality.dart';
import 'package:grocerytracker/functions/drawer.dart';
import 'package:grocerytracker/functions/popUpDialog.dart';
import 'package:grocerytracker/functions/total.dart';
import 'package:grocerytracker/shared/constants.dart';
import 'package:grocerytracker/widgets/barrel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const DrawerFunction(),
        appBar: AppBar(
          centerTitle: true,
          title:
              Image.asset("assets/icons/appbar.png", height: 150, width: 150),
          elevation: 0,
          backgroundColor: BgColorSplashScreen,
          leading: Builder(
            builder: (BuildContext context) {
              return InkWell(
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () => Scaffold.of(context).openDrawer(),
                child: Image.asset("assets/icons/icon.png"),
              );
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: InkWell(
                onTap: () {
                  addGroceries(context);
                },
                child: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.blue,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: InkWell(
                onTap: () {
                  deletePop(context, "Groceries");
                },
                child: const Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                ),
              ),
            )
          ],
        ),
        body: const GroceryList());
  }
}

class GroceryList extends StatefulWidget {
  const GroceryList({Key? key}) : super(key: key);

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final Stream<QuerySnapshot> _groceryList =
      FirebaseFirestore.instance.collection('Groceries').snapshots();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        const HeadingContainer(heading: "GROCERY LIST"),
        const SizedBox(
          height: 20,
        ),
        StreamBuilder<QuerySnapshot>(
          stream: _groceryList,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: Text("No Items! "));
            }
            // is used for calculating the total
            // here we decalred a total of 0 which will refresh every time when the widget is loaded
            // even if the item are deleted the total will be refresed
            int total = 0;
            for (var element in snapshot.data!.docs) {
              int price = int.parse(element['Price']);
              total = total + price.toInt();
            }
            return Expanded(
              child: Column(
                children: [
                  TotalCardDisplay(
                    total: total,
                    size: size,
                  ),
                  ListView(
                    shrinkWrap: true,
                    children: snapshot.data!.docs.map((document) {
                      return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) {
                          FirebaseFirestore.instance
                              .runTransaction((Transaction transaction) async {
                            transaction.delete(document.reference);
                          });
                          Fluttertoast.showToast(msg: "Deleted Sucessfully!");
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: InkWell(
                            onLongPress: () {
                              updateGroceries(context);
                            },
                            child: Card(
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      document['Name'] +
                                          ' (${document["Quantity"]})',
                                      style: const TextStyle(
                                          fontSize: 15,
                                          letterSpacing: 2,
                                          fontWeight: FontWeight.w500),
                                    ),

                                    Text(
                                      "Rs." + document['Price'],
                                      style: const TextStyle(
                                          fontSize: 15,
                                          letterSpacing: 2,
                                          fontWeight: FontWeight.w400),
                                    ),

                                    // Text(total.toString())

                                    // exactPrice(
                                    //         document['Price'], document[' Quantity'])
                                    //     .toString()),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        background: Container(
                          width: 20,
                          color: Colors.red,
                          child: const Icon(Icons.delete_outline),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          },
        ),
        // StreamBuilder<QuerySnapshot>(
        //     stream: FirebaseFirestore.instance.collection('Total').snapshots(),
        //     builder:
        //         (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        //       var document = snapshot.data!.docs.first;
        //       var countTotal = document['total'];
        //       return Padding(
        //         padding: const EdgeInsets.symmetric(horizontal: 20.0),
        //         child: Card(
        //             child: Padding(
        //           padding: const EdgeInsets.all(15.0),
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceAround,
        //             children: [
        //               const Text(
        //                 "TOTAL",
        //                 style: TextStyle(
        //                     letterSpacing: 2,
        //                     fontSize: 20,
        //                     fontWeight: FontWeight.bold),
        //               ),
        //               Text(countTotal)
        //             ],
        //           ),
        //         )),
        //       );
        //     })
      ],
    );
  }
}

class AddItem extends StatelessWidget {
  const AddItem({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: InkWell(
          onTap: () {
            addGroceries(context);
          },
          child: Container(
            height: 50,
            width: 120,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 4),
              )
            ], color: Colors.blue[200], borderRadius: BorderRadius.circular(5)),
            child: const Center(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "ADD ITEMS",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                    color: DefaultTextColor),
              ),
            )),
          ),
        ),
      ),
    );
  }
}
