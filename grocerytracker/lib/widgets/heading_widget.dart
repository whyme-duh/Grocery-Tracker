import 'package:flutter/material.dart';

class HeadingContainer extends StatelessWidget {
  final String heading;
  const HeadingContainer({Key? key, required this.heading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.9,
      height: size.height * 0.1,
      decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(blurRadius: 2, offset: Offset(0, 5), color: Colors.grey)
          ],
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFf9e5e5)),
      child: Center(
        child: Text(
          heading,
          style: const TextStyle(
              fontSize: 20, letterSpacing: 3, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
