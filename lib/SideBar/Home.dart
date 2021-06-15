import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rainvow_mobile/Domain/FavoriteDomain.dart';

import 'package:rainvow_mobile/Screen/FavoriteScreen.dart';
import 'package:rainvow_mobile/Screen/MapScreen.dart';
import 'package:rainvow_mobile/Screen/WeatherScreen.dart';
import 'package:rainvow_mobile/Screen/SettingScreen.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 공유기능

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

/**
 * 스크린 타이틀 설정
 * */
class HomePage extends StatefulWidget {

  int index = 0;

  HomePage({required this.index});

  final drawerItems = [
    new DrawerItem("강우지도", Icons.umbrella),
    new DrawerItem("관심지역", Icons.star),
    new DrawerItem("설정", Icons.settings),
    new DrawerItem("강우지도", Icons.map),
  ];

  @override
  State<StatefulWidget> createState() {
    return new HomePageState(index: index);
  }
}

/**
 * 스크린 설정 
 * */
class HomePageState extends State<HomePage> {

  int index = 0;
  int _selectedDrawerIndex = 0;
  late SharedPreferences prefs;
  List <FavoriteDomain> favoriteArray = [];

  HomePageState({required this.index});

  @override
  initState(){
    super.initState();
    _loadFavoriteLocationData();

  }


  Future<List<FavoriteDomain>> _loadFavoriteLocationData() async{
    prefs = await SharedPreferences.getInstance();
    final getLocationPermission = prefs.getBool('locationPermission') ?? false;
    var getList = await prefs.getStringList('favoriteLocation') ?? [];

    if( getList.isNotEmpty) {
      setState(() {
        favoriteArray = getList.map((item) => FavoriteDomain.fromJson(jsonDecode(item))).toList();
      });
      return getList.map((item) => FavoriteDomain.fromJson(jsonDecode(item))).toList();
    }else
      return [];
  }


  _getDrawerFragment(int pos) {
    switch (pos) {
      case 0: // 강우지도
        return new WeatherScreen(idx: index,);
      case 1: // 관심지역
        return new FavoriteScreen();
      case 2: // 설정
        return new SettingScreen();
      case 3: // 맵
        return new MapScreen();
      default:
        return new Text("Error");
    }
  }
  //Let's update the selectedDrawerItemIndex the close the drawer
  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    //we close the drawer
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {

    print('index=>>> ${index}');
    List<Widget> drawerOptions = [];

    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(
          new ListTile(
            leading: new Icon(d.icon),
            title: new Text(d.title),
            selected: i == _selectedDrawerIndex,
            onTap: () => _onSelectItem(i),
          )
      );
    }

    drawerOptions.add(
        new ListTile(
          leading: new Icon(Icons.share),
          title: new Text('공유하기'),
          selected: 4 == _selectedDrawerIndex,
          onTap: () => {
            Share.share('내용 공유하기')
          },
        )
    );

    String setTitleStr = widget.drawerItems[_selectedDrawerIndex].title;
    // if (_selectedDrawerIndex == 0){
    //   if(favoriteArray.length != 0){
    //     setTitleStr = favoriteArray[index].address;
    //   }
    // }

    return new Scaffold(
      appBar: new AppBar(
        // We will dynamically display title of selected page
        title: new Text(setTitleStr),
        centerTitle: true, // 타이틀 중앙 정렬

      ),
      // Let's register our Drawer to the Scaffold
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[

            /**
             * 해더 로고
             * */
            DrawerHeader(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset("assets/images/rainvow_logo.png")
                ],
              ),
              decoration: BoxDecoration(
                  color: Colors.white
              ),
            ),

            new Column(children: drawerOptions)
          ],
        ),
      ),
      body: _getDrawerFragment(_selectedDrawerIndex),
    );
  }
}