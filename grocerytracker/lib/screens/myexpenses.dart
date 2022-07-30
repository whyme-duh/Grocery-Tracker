import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocerytracker/functions/drawer.dart';
import 'package:grocerytracker/functions/popUpDialog.dart';
import 'package:grocerytracker/shared/constants.dart';
import 'package:grocerytracker/widgets/barrel.dart';

class MyExpenses extends StatelessWidget {
  const MyExpenses({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BgColorSplashScreen,
        elevation: 0,
        centerTitle: true,
        title: Image.asset("assets/icons/appbar.png", height: 150, width: 150),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: InkWell(
              onTap: () {
                addMyExpenses(
                  context,
                );
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
                deletePop(context, "Myexpenses");
              },
              child: const Icon(
                Icons.delete_forever,
                color: Colors.red,
              ),
            ),
          )
        ],
      ),
      body: MyExpensesBody(),
    );
  }
}

class MyExpensesBody extends StatelessWidget {
  MyExpensesBody({Key? key}) : super(key: key);
  final Stream<QuerySnapshot> _myexpenseslist = FirebaseFirestore.instance
      .collection('Myexpenses')
      .orderBy('time')
      .snapshots();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        const HeadingContainer(heading: "YOUR EXPENSES"),
        const SizedBox(
          height: 20,
        ),
        StreamBuilder<QuerySnapshot>(
          stream: _myexpenseslist,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Text("LOADING");
            }
            int total = 0;
            // is used for calculating the total
            // here we decalred a total of 0 which will refresh every time when the widget is loaded
            // even if the item are deleted the total will be refresed
            for (var element in snapshot.data!.docs) {
              int price = int.parse(element['amount']);
              total = total + price.toInt();
            }
            return Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: ConstrainedBox(
                  constraints: BoxConstraints(),
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
                              FirebaseFirestore.instance.runTransaction(
                                  (Transaction transaction) async {
                                transaction.delete(document.reference);
                              });
                              Fluttertoast.showToast(
                                  msg: "Deleted Sucessfully!");
                            },
                            background: const Card(
                              color: Colors.red,
                              child: Icon(
                                Icons.delete_outline,
                                color: Colors.white,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Card(
                                elevation: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              document['title'],
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  letterSpacing: 2,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Text(
                                            "Rs. " + document['amount'],
                                            style: const TextStyle(
                                                fontSize: 12,
                                                letterSpacing: 2,
                                                fontWeight: FontWeight.w800),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        document['time'],
                                        style: const TextStyle(
                                            fontSize: 10,
                                            letterSpacing: 2,
                                            fontWeight: FontWeight.w300),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
