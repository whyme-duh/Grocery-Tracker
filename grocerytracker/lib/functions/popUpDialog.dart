import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocerytracker/database/dbFunctionality.dart';
import 'package:grocerytracker/screens/myexpenses.dart';
import 'package:grocerytracker/shared/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

final _formKey = GlobalKey<FormState>();

// THIS IS USED FOR THE JAR COUNTER
// JAR COUNTER
void priceChangeDialog(BuildContext context) {
  var collection = FirebaseFirestore.instance.collection('Jars');

  final _formKey = GlobalKey<FormState>();

  String price = '';
  var priceCatalog = AlertDialog(
    title: const Center(
        child: Text(
      "CHANGE PRICE",
      style: TextStyle(fontSize: 13, letterSpacing: 2),
    )),
    content: Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextFormField(
            validator: (val) {
              if (val!.isEmpty) {
                return "This should not be empty";
              }
            },
            onChanged: (val) {
              price = val;
            },
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                labelText: "Price",
                contentPadding: EdgeInsets.all(20),
                border: OutlineInputBorder()),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.lightBlue)),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      collection.doc('jars').update({'price': price});
                      Fluttertoast.showToast(msg: "Updated!");
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("CHANGE")),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "CANCEL",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          )
        ],
      ),
    ),
  );
  showDialog(context: context, builder: (context) => priceCatalog);
}

// USED FOR DELETING DATABASES
void deletePop(BuildContext context, String collectionName) {
  var collection = FirebaseFirestore.instance.collection(collectionName);
  var delete = AlertDialog(
    backgroundColor: popUpColor,
    title: const Text("Do you want to delete all data ?"),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
            onPressed: () async {
              if (collectionName == "Groceries" ||
                  collectionName == " Expenses" ||
                  collectionName == "WishList" ||
                  collectionName == "Myexpenses") {
                collection.get().then((snapshot) {
                  for (DocumentSnapshot ds in snapshot.docs) {
                    ds.reference.delete();
                  }
                });
              }
              if (collectionName == "Jars") {
                collection.doc('jars').update({'count': '0'});
              }
              Navigator.pop(context);
              Fluttertoast.showToast(msg: "Deleted Sucessfully");
            },
            child: const Text("DELETE")),
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "CANCEL",
              style: TextStyle(color: Colors.white),
            ))
      ],
    ),
  );
  showDialog(context: context, builder: (context) => delete);
}

// UPDATING GROCERIES
void updateGroceries(BuildContext context) {
  var size = MediaQuery.of(context).size;
  final _formKey = GlobalKey<FormState>();

  String itemName = "";
  String price = '';
  String quantity = '';

  var add = AlertDialog(
    backgroundColor: popUpColor,
    title: const Center(
        child: Text(
      "ADD ITEMS",
      style: TextStyle(fontSize: 13, letterSpacing: 2),
    )),
    content: Container(
      child: Form(
        key: _formKey,
        child: SizedBox(
          width: size.width * 0.5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextFormField(
                validator: (val) {
                  if (val!.isEmpty) {
                    return "This field cannot be empty";
                  }
                },
                onChanged: (val) {
                  itemName = val;
                },
                decoration: const InputDecoration(
                    labelText: 'Item Name', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: size.width * 0.30,
                    height: 50,
                    child: TextFormField(
                      onChanged: (val) {
                        price = val;
                      },
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          labelText: "Price",
                          contentPadding: EdgeInsets.all(20),
                          border: OutlineInputBorder()),
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.22,
                    height: 50,
                    child: TextFormField(
                      onChanged: (val) {
                        quantity = val;
                      },
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          labelText: "Quantity",
                          contentPadding: EdgeInsets.all(20),
                          border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.lightBlue)),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          update(itemName.toUpperCase(), price, quantity);
                          Fluttertoast.showToast(msg: "Item added succesfully");
                          Navigator.pop(context);
                        }
                      },
                      child: const Text("ADD")),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "CANCEL",
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    ),
  );
  showDialog(context: context, builder: (context) => add);
}

// FOR GROCERIES
void addGroceries(BuildContext context) {
  var size = MediaQuery.of(context).size;

  String itemName = "";
  String price = '';
  String quantity = '';

  var add = AlertDialog(
    backgroundColor: popUpColor,
    title: const Center(
        child: Text(
      "ADD ITEMS",
      style: TextStyle(fontSize: 13, letterSpacing: 2),
    )),
    content: Form(
      key: _formKey,
      child: SizedBox(
        width: size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              validator: (val) {
                if (val!.isEmpty) {
                  return "This field cannot be empty";
                }
              },
              onChanged: (val) {
                itemName = val;
              },
              decoration: const InputDecoration(
                  labelText: 'Item Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: size.width * 0.30,
                  height: 50,
                  child: TextFormField(
                    onChanged: (val) {
                      price = val;
                    },
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: "Price",
                        contentPadding: EdgeInsets.all(20),
                        border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(
                  width: size.width * 0.3,
                  height: 50,
                  child: TextFormField(
                    onChanged: (val) {
                      quantity = val;
                    },
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: "Quantity",
                        contentPadding: EdgeInsets.all(20),
                        border: OutlineInputBorder()),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.lightBlue)),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        takeDetail(itemName, price, quantity);
                        Fluttertoast.showToast(msg: "Item added succesfully");
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("ADD")),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "CANCEL",
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            )
          ],
        ),
      ),
    ),
  );
  showDialog(context: context, builder: (context) => add);
}

void addExpenses(BuildContext context) {
  final _formKeyExpense = GlobalKey<FormState>();
  var size = MediaQuery.of(context).size;

  String title = "";
  String amount = '';

  //passing time to the database whenever the model is created
  DateTime currentTime = DateTime.now();
  String time = (currentTime.year.toString() +
      "-" +
      currentTime.month.toString() +
      "-" +
      currentTime.day.toString());

  var add = AlertDialog(
    backgroundColor: popUpColor,
    title: const Center(
        child: Text(
      "ADD EXPENSES",
      style: TextStyle(fontSize: 13, letterSpacing: 2),
    )),
    content: Form(
      key: _formKeyExpense,
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextFormField(
              validator: (val) {
                if (val!.isEmpty) {
                  return "This field cannot be empty";
                }
              },
              onChanged: (val) {
                title = val;
              },
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                  labelText: 'Expense Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            TextFormField(
              onChanged: (val) {
                amount = val;
              },
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: "Price",
                  contentPadding: EdgeInsets.all(20),
                  border: OutlineInputBorder()),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.lightBlue)),
                    onPressed: () async {
                      if (_formKeyExpense.currentState!.validate()) {
                        expenses(title, amount, time);
                        Fluttertoast.showToast(
                            msg: "Home expense added succesfully");

                        Navigator.pop(context);
                      }
                    },
                    child: const Text("ADD")),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "CANCEL",
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            )
          ],
        ),
      ),
    ),
  );
  showDialog(context: context, builder: (context) => add);
}

void addMyExpenses(BuildContext context) {
  final _formKeyExpense = GlobalKey<FormState>();
  var size = MediaQuery.of(context).size;

  String title = "";
  String amount = '';

  //passing time to the database whenever the model is created
  DateTime currentTime = DateTime.now();
  String time = (currentTime.year.toString() +
      "-" +
      currentTime.month.toString() +
      "-" +
      currentTime.day.toString());

  var add = AlertDialog(
    backgroundColor: popUpColor,
    title: const Center(
        child: Text(
      "ADD EXPENSES",
      style: TextStyle(fontSize: 13, letterSpacing: 2),
    )),
    content: Form(
      key: _formKeyExpense,
      child: SizedBox(
        width: size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextFormField(
              validator: (val) {
                if (val!.isEmpty) {
                  return "This field cannot be empty";
                }
              },
              onChanged: (val) {
                title = val;
              },
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                  labelText: 'Expense Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            TextFormField(
              onChanged: (val) {
                amount = val;
              },
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: "Price",
                  contentPadding: EdgeInsets.all(20),
                  border: OutlineInputBorder()),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.lightBlue)),
                    onPressed: () async {
                      if (_formKeyExpense.currentState!.validate()) {
                        myExpenses(title, amount, time);
                        Fluttertoast.showToast(
                            msg: "Your expense added succesfully");

                        Navigator.pop(context);
                      }
                    },
                    child: const Text("ADD")),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "CANCEL",
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            )
          ],
        ),
      ),
    ),
  );
  showDialog(context: context, builder: (context) => add);
}

void addWishList(BuildContext context) {
  var size = MediaQuery.of(context).size;

  String item = "";
  String quantity = '';

  var add = AlertDialog(
    backgroundColor: popUpColor,
    title: const Center(
        child: Text(
      "ADD YOUR ITEMS",
      style: TextStyle(fontSize: 13, letterSpacing: 2),
    )),
    content: Form(
      key: _formKey,
      child: SizedBox(
        width: size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              validator: (val) {
                if (val!.isEmpty) {
                  return "This field cannot be empty";
                }
              },
              onChanged: (val) {
                item = val;
              },
              decoration: const InputDecoration(
                  labelText: 'Expense Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            TextFormField(
              onChanged: (val) {
                quantity = val;
              },
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: "Price",
                  contentPadding: EdgeInsets.all(20),
                  border: OutlineInputBorder()),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.lightBlue)),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        wishList(item, quantity);
                        Fluttertoast.showToast(
                            msg: "Expense added succesfully");

                        Navigator.pop(context);
                      }
                    },
                    child: const Text("ADD")),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "CANCEL",
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            )
          ],
        ),
      ),
    ),
  );
  showDialog(context: context, builder: (context) => add);
}
