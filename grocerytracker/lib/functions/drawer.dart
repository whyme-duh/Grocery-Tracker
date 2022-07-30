import 'package:flutter/material.dart';
import 'package:grocerytracker/screens/expenses.dart';
import 'package:grocerytracker/screens/jarcounter.dart';
import 'package:grocerytracker/screens/myexpenses.dart';
import 'package:grocerytracker/screens/wish_list.dart';
import 'package:grocerytracker/shared/constants.dart';

class DrawerFunction extends StatefulWidget {
  const DrawerFunction({Key? key}) : super(key: key);

  @override
  _DrawerFunctionState createState() => _DrawerFunctionState();
}

class _DrawerFunctionState extends State<DrawerFunction> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Drawer(
      backgroundColor: Colors.grey[200],
      child: ListView(
        children: [
          ClipRRect(child: Center(child: Image.asset('assets/icons/lgo.png'))),
          const SizedBox(height: 30),
          DrawerTile(
              title: "HOME EXPENSES",
              func: const Expenses(),
              icon: Icon(Icons.money_off)),
          DrawerTile(
              title: "MY EXPENSES",
              func: MyExpenses(),
              icon: Icon(Icons.money_outlined)),
          DrawerTile(
              title: "JAR COUNTER",
              func: JarCounter(),
              icon: Icon(Icons.water_sharp)),
          DrawerTile(
              title: "WISH LIST",
              func: const WishList(),
              icon: Icon(Icons.add_shopping_cart)),
        ],
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  String title;
  Widget func;
  Icon icon;
  DrawerTile({
    required this.title,
    required this.func,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: TextButton.icon(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => func));
            },
            icon: icon,
            label: Text(
              title,
              style: const TextStyle(
                  letterSpacing: 3, fontSize: 15, color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
