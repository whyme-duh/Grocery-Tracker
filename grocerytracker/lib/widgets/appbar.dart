import 'package:flutter/material.dart';
import 'package:grocerytracker/functions/popUpDialog.dart';

class Appbar extends StatelessWidget implements PreferredSize {
  final Function delete;
  final Function add;
  final AppBar appBar;
  const Appbar({
    Key? key,
    required this.delete,
    required this.appBar,
    required this.add,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
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
              add();
            },
            child: const Icon(
              Icons.add_circle_outline,
              color: Colors.black,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
          child: InkWell(
            onTap: () {
              delete();
            },
            child: const Icon(
              Icons.delete_forever,
              color: Colors.black,
            ),
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);

  @override
  // TODO: implement child
  Widget get child => throw UnimplementedError();
}
