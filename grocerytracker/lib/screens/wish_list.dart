import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocerytracker/functions/popUpDialog.dart';
import 'package:grocerytracker/shared/constants.dart';
import 'package:grocerytracker/widgets/barrel.dart';

class WishList extends StatelessWidget {
  const WishList({Key? key}) : super(key: key);

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
                addWishList(context);
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
                deletePop(context, "WishList");
              },
              child: const Icon(
                Icons.delete_forever,
                color: Colors.red,
              ),
            ),
          )
        ],
      ),
      body: const WishListBody(),
    );
  }
}

class WishListBody extends StatefulWidget {
  const WishListBody({
    Key? key,
  }) : super(key: key);

  @override
  State<WishListBody> createState() => _WishListBodyState();
}

class _WishListBodyState extends State<WishListBody> {
  bool value = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(
          child: HeadingContainer(
            heading: "WISH LIST",
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('WishList').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: Text("There is no any items. Add one"),
              );
            } else {
              return ListView(
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      checkColor: Colors.green,
                                      activeColor: Colors.white,
                                      value: this.value,
                                      onChanged: (_) {
                                        setState(() {
                                          this.value = !this.value;
                                        });
                                      },
                                    ),
                                    Text(
                                      document['item'],
                                      style: const TextStyle(
                                          fontSize: 15,
                                          letterSpacing: 2,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  child: Text(
                                    document['quantity'],
                                    style: const TextStyle(
                                        fontSize: 12,
                                        letterSpacing: 2,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }
          },
        )
      ],
    );
  }
}
