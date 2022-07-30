import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocerytracker/database/dbFunctionality.dart';
import 'package:grocerytracker/functions/popUpDialog.dart';
import 'package:grocerytracker/functions/total.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grocerytracker/shared/constants.dart';
import 'package:grocerytracker/widgets/heading_widget.dart';

class JarCounter extends StatefulWidget {
  JarCounter({Key? key}) : super(key: key);

  @override
  _JarCounterState createState() => _JarCounterState();
}

class _JarCounterState extends State<JarCounter> {
  final Stream<QuerySnapshot<Map<String, dynamic>>> _jars =
      FirebaseFirestore.instance.collection('Jars').snapshots();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: BgColorSplashScreen,
          elevation: 0,
          centerTitle: true,
          title:
              Image.asset("assets/icons/appbar.png", height: 150, width: 150),
          iconTheme: const IconThemeData(color: Colors.black),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: InkWell(
                onTap: () {
                  deletePop(context, 'Jars');
                },
                child: const Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                ),
              ),
            )
          ],
        ),
        body: Stack(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: HeadingContainer(
                heading: "JAR COUNTER",
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Center(
              child: StreamBuilder(
                  stream: _jars,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const SpinKitCircle(
                        color: Colors.black,
                      );
                    }
                    var document = snapshot.data!.docs.single;
                    var time = document['time'];
                    var price = document['price'];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                          child: Text(
                            " Updated At: " + time,
                            style:
                                const TextStyle(fontSize: 12, letterSpacing: 2),
                          ),
                        ),
                        Container(
                          width: size.width * 0.9,
                          height: size.height * 0.1,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[100]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                " PRICE : " + price,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text(
                                    'Number of Jar : ' + document['count'],
                                    style: const TextStyle(
                                        fontSize: 12,
                                        letterSpacing: 3,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Price : " +
                                        jarPrice(document['count'], price),
                                    style: const TextStyle(
                                        fontSize: 12,
                                        letterSpacing: 3,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.red),
                              ),
                              child: const Text("REMOVE"),
                              onPressed: () async {
                                int count = int.parse(document['count']);
                                if (count > 0) {
                                  count--;
                                }
                                jar(count.toString(), price);
                              },
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.lightBlueAccent),
                              ),
                              child: const Text("CHANGE PRICE"),
                              onPressed: () {
                                priceChangeDialog(context);
                              },
                            ),
                            ElevatedButton(
                              child: const Text("ADD"),
                              onPressed: () async {
                                int count = int.parse(document['count']);
                                count++;
                                jar(count.toString(), price);
                              },
                            ),
                          ],
                        )),
                      ],
                    );
                  }),
            ),
          ],
        ));
  }
}
