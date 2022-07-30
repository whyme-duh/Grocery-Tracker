import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

CollectionReference groceries = _firestore.collection('Groceries');
CollectionReference jarCounter = _firestore.collection('Jars');
CollectionReference expenseDetail = _firestore.collection('Expenses');
CollectionReference total = _firestore.collection('Totals');
CollectionReference wish_list = _firestore.collection('WishList');
CollectionReference myExpensesList = _firestore.collection('Myexpenses');

// is used to take input of the groceries
Future<void> takeDetail(String name, String price, String quantity) {
  int totalPrice = int.parse(quantity) * int.parse(price);

  return groceries.add({
    'Name': name,
    'Price': totalPrice.toString(),
    "Quantity": quantity,
  });
}

// is used to count the jars
Future<void> jar(String count, String price) {
  DateTime currentTime = DateTime.now();
  String time = (currentTime.year.toString() +
      "-" +
      currentTime.month.toString() +
      "-" +
      currentTime.day.toString());
  return jarCounter
      .doc('jars')
      .update({'count': count, 'price': price, 'time': time});
}

// is used to take input of the expenses
Future<void> expenses(String title, String amount, String time) {
  return expenseDetail.add({'title': title, 'amount': amount, 'time': time});
}

// is for my expeneses
Future<void> myExpenses(String title, String amount, String time) {
  return myExpensesList.add({'title': title, 'amount': amount, 'time': time});
}
//is used to calculate the total expenses and groceres

// for updating the groceries
Future<void> update(String name, String price, String quantity) {
  int totalPrice = int.parse(quantity) * int.parse(price);
  return groceries.doc().update(
      {'Name': name, 'Price': totalPrice.toString(), "Quantity": quantity});
}

// for the wish list groceries

Future<void> wishList(String item, String quantity) {
  return wish_list.add({'item': item, 'quantity': quantity});
}
