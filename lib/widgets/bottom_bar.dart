import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Theme.of(context).primaryColor),
            title: new Text('Home')),
        BottomNavigationBarItem(
            icon: Icon(Icons.store, color: Color.fromARGB(255, 0, 0, 0)),
            title: new Text('Offline Store')),
        BottomNavigationBarItem(
            icon: Icon(Icons.computer, color: Color.fromARGB(255, 0, 0, 0)),
            title: new Text('Online Store')),
        BottomNavigationBarItem(
            icon:
                Icon(Icons.card_giftcard, color: Color.fromARGB(255, 0, 0, 0)),
            title: new Text('Gift Card')),
      ],
      onTap: (index) {},
    );
  }
}
