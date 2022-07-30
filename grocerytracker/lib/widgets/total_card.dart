// this file is used to calculate the tital which is used by the file => homepage and expenses

import 'package:flutter/material.dart';

class TotalCardDisplay extends StatelessWidget {
  final int total;
  final size;
  const TotalCardDisplay({Key? key, required this.total, required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Container(
        height: size.height * 0.05,
        decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              "Total : ",
              style: TextStyle(
                  fontSize: 15, letterSpacing: 2, fontWeight: FontWeight.w500),
            ),
            Text(
              "Rs." + total.toString(),
              style: const TextStyle(
                  fontSize: 13, letterSpacing: 2, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
