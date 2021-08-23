import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aks/page/list_chat.dart';
import 'package:aks/function/get_userdata.dart';
import 'package:aks/model/user_model.dart';
import 'package:aks/page/tab/tab_home.dart';
import 'package:aks/page/tab/tab_search.dart';
import 'package:aks/page/tab/tab_borrow.dart';
import 'package:aks/page/tab/tab_class.dart';
import 'package:aks/page/tab/tab_profile.dart';
import 'package:aks/page/settings.dart';


class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  int _currentIndex = 0;
  InitData init = InitData();

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    var data = await init.getData();
    context.read<UserNotifier>().setUser(
      data['classCode'], 
      data['address'],
      data['bio'],
      data['points'],
      data['type']
    );
  }

  @override
  Widget build(BuildContext context) {

    List<PreferredSizeWidget> appBar = [
      AppBar(
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Aksaranesia.co", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                      return ListChat();
                    }));
                  },
                  child: Icon(Icons.message_outlined, size: 23)
                ),
              ],
            )
          ],
        )
      ),
      AppBar(elevation: 0, title: Text("", style: TextStyle(fontSize: 18))),
      AppBar(elevation: 0, title: Text("Buku Dipinjam", style: TextStyle(fontSize: 18))),
      AppBar(elevation: 0, title: Text("Kelas Saya", style: TextStyle(fontSize: 18))),
      AppBar(elevation: 0, title: 
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Profil", style: TextStyle(fontSize: 18)),
            InkWell(
              child: Icon(Icons.settings_outlined, size: 23),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                      return Settings();
                    }
                  )
                );
              }
            )
          ],
        )
      ),
    ];
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar[_currentIndex],
      body: IndexedStack(
        index: _currentIndex,
        children: [
          TabHome(),
          TabSearch(),
          TabBorrow(),
          TabClass(),
          TabProfile(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        currentIndex: _currentIndex,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        items: [
          BottomNavigationBarItem(
            icon: _currentIndex == 0 ? Image.asset("assets/images/icon/clicked_beranda.png", width: 20, color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor) : Image.asset("assets/images/icon/beranda.png", width: 20, color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor),
            label: "Beranda",
          ),
          BottomNavigationBarItem(
            icon: _currentIndex == 1 ? Image.asset("assets/images/icon/clicked_search.png", width: 20, color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor) : Image.asset("assets/images/icon/search.png", width: 20, color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor),
            label: "Cari",
          ),
          BottomNavigationBarItem(
            icon:  _currentIndex == 2 ? Image.asset("assets/images/icon/clicked_buku.png", width: 20, color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor) : Image.asset("assets/images/icon/buku.png", width: 20, color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor),
            label: "Buku",
          ),
          BottomNavigationBarItem(
            icon:  _currentIndex == 3 ? Image.asset("assets/images/icon/clicked_kelas.png", width: 20, color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor) : Image.asset("assets/images/icon/kelas.png", width: 20, color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor),
            label: "Kelas",
          ),
          BottomNavigationBarItem(
            icon:  _currentIndex == 4 ? Image.asset("assets/images/icon/clicked_akun.png", width: 20, color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor) : Image.asset("assets/images/icon/akun.png", width: 20, color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor),
            label: "Profil",
          ),
        ]
      ),
    );
  }
}