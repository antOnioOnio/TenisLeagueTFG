import 'package:flutter/material.dart';
import 'package:tenisleague100/application/League/MainLeague.dart';
import 'package:tenisleague100/application/Messages/chats_list.dart';
import 'package:tenisleague100/application/Settings/settings.dart';
import 'package:tenisleague100/application/Users/MainUsers.dart';
import 'package:tenisleague100/constants/GlobalValues.dart';

import 'Forum/MainForum.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    Forum(),
    MainUsers(),
    MainLeague(),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
    SettingsPage(),
    Chats()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Foro',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle),
            label: 'usuarios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Ligas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(GlobalValues.mainGreen),
        unselectedItemColor: Colors.grey[300],
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
