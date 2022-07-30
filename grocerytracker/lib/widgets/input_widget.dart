import 'package:flutter/material.dart';

class InputCard extends StatelessWidget {
  const InputCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.7,
      width: size.width,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(
        children: <Widget>[
          TextFormField(
            validator: (val) {
              if (val!.isEmpty) {
                return "This field cannot be empty";
              }
            },
            onChanged: (val) {},
            decoration: const InputDecoration(
                labelText: 'Expense Name', border: OutlineInputBorder()),
          ),
        ],
      ),
    );
  }
}
