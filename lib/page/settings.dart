import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import "package:aks/model/dark_mode.dart";
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aks/page/login.dart';
import 'package:aks/page/relogin.dart';
import 'package:aks/page/edit_profile.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: Text("Pengaturan", style: TextStyle(fontSize: 18))
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Consumer<ThemeNotifier>(
                  builder: (context,notifier,child) => SwitchListTile(
                  title: Text("Mode Gelap", style: TextStyle(fontSize: 15)),
                    onChanged: (val){
                      notifier.toggleChangeTheme();
                      if(val == false) {
                        SystemChrome.setSystemUIOverlayStyle(
                          SystemUiOverlayStyle.light.copyWith(statusBarIconBrightness: Brightness.dark, statusBarColor: Colors.white, systemNavigationBarColor: Colors.white),
                        );
                      } else {
                        SystemChrome.setSystemUIOverlayStyle(
                          SystemUiOverlayStyle.dark.copyWith(statusBarIconBrightness: Brightness.light, statusBarColor: Colors.black, systemNavigationBarColor: Colors.black),
                        );
                      }
                    },
                    value: notifier.darkMode ,
                  ),
                ),
                Divider(),
                ListTile(
                  title: Text("Edit Profil", style: TextStyle(fontSize: 15)),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder:(context) {
                        return EditProfile();
                      }
                    ));
                  },
                ),
                Divider(),
                ListTile(
                  title: Text("Edit Keamanan", style: TextStyle(fontSize: 15)),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder:(context) {
                        return ReLogin();
                      }
                    ));
                  },
                ),
                Divider(),
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Keluar", style: TextStyle(fontSize: 15)),
                      Icon(Icons.logout),
                    ],
                  ),
                  onTap: () async {
                    final FirebaseAuth _auth = FirebaseAuth.instance;
                    await _auth.signOut();
                    return Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                      builder: (context) {
                        return Login();
                      }
                    ), (Route<dynamic> route) => false);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}