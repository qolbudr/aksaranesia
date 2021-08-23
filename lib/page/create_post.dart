import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aks/model/user_model.dart';
import 'package:aks/function/create_post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aks/function/validate_form.dart';

class CreatePost extends StatefulWidget {
  @override
  _CreatePost createState() => _CreatePost();
}

class _CreatePost extends State<CreatePost> {
  int _tipe = 0;
  final storyController = TextEditingController();
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  UserData userData;


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    storyController.dispose();
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    userData = context.watch<UserNotifier>().user;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Buat Tulisan", style: TextStyle(fontSize: 18, color: Theme.of(context).scaffoldBackgroundColor)),
            InkWell(
              onTap: () {
                switch(_tipe) {
                  case 0:
                    String validatorError = validateStory(storyController.value.text);
                    if(validatorError == null) {
                      Post.createStory(userData.classCode, _auth.currentUser.uid, storyController.value.text);
                      Navigator.pop(context);
                    } else {
                      final snackBar = SnackBar(
                        content: Text(validatorError),
                        action: SnackBarAction(
                          label: 'Okay',
                          onPressed: () {
                          },
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  break;

                  default:
                    String validatorError = validateWriting(contentController.value.text);
                    if(validatorError == null) {
                      Post.createWriting(userData.classCode, _auth.currentUser.uid, titleController.value.text, contentController.value.text);
                      Post.addWritingPoints(userData.points, _auth.currentUser.uid);
                      context.read<UserNotifier>().setUser(
                        userData.classCode,
                        userData.address,
                        userData.bio,
                        userData.points + 75,
                        userData.type
                      );
                      Navigator.pop(context);
                    } else {
                      final snackBar = SnackBar(
                        content: Text(validatorError),
                        action: SnackBarAction(
                          label: 'Okay',
                          onPressed: () {
                          },
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  break;
                }
              },
              child: Text("Simpan", style: TextStyle(color: Colors.blue, fontSize: 14))
            )    
          ],
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          GestureDetector(
            onHorizontalDragEnd: (details) => {
              if (details.primaryVelocity < 0) {
                Navigator.pop(context)
              }
            },
            child: _tipe == 0 ? TextArea(
              controller: storyController,
              expands: true, 
              hintText: "Apa yang anda pikirkan ?", 
              maxLines: null, 
              hintSize: 16, 
              contentPadding: EdgeInsets.only(left: 80, top: 20, right: 15, bottom: 15), 
              transparency: 0
            ) : Column(
              children: [
                TextArea(
                  controller: titleController,
                  hintText: "Judul tulisan", 
                  maxLines: 1, 
                  hintSize: 16, 
                  contentPadding: EdgeInsets.only(left: 80, top: 20, right: 15, bottom: 0), 
                  transparency: 0
                ),
                Expanded(
                  child: TextArea(
                    controller: contentController,
                    expands: true, 
                    hintText: "Ceritakan tulisan anda", 
                    maxLines: null, 
                    hintSize: 16, 
                    contentPadding: EdgeInsets.only(left: 80, top: 20, right: 15, bottom: 15), 
                    transparency: 0
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 15,
            left: 15,
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 25,
              child: ClipOval(
                child: _auth.currentUser.photoURL == null ? 
                  FadeInImage(image: AssetImage('assets/images/user.png'), placeholder: AssetImage('assets/images/user.png'))
                :
                  FadeInImage(image: NetworkImage(_auth.currentUser.photoURL), placeholder: AssetImage('assets/images/user.png')),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            left: 5,
            child: Column(
              children: [
                InkWell(
                  onTap: () => setState(() => _tipe = 0),
                  child: Row(
                    children: [
                      _tipe == 0 ? Icon(Icons.fiber_manual_record, size: 9, color: Theme.of(context).primaryColor) : SizedBox(width: 9),
                      SizedBox(width: 10),
                      Icon(Icons.featured_play_list_outlined),
                    ],
                  )
                ),
                SizedBox(height: 30),
                InkWell(
                  onTap: () => setState(() => _tipe = 1),
                  child: Row(
                    children: [
                      _tipe == 1 ? Icon(Icons.fiber_manual_record, size: 9, color: Theme.of(context).primaryColor) : SizedBox(width: 9),
                      SizedBox(width: 10),
                      Icon(Icons.edit_outlined),
                    ],
                  )
                ),
              ],
            )
          ),
        ],
      )
    );
  }
}

class TextArea extends StatelessWidget {
  TextArea({
    this.expands = false,
    this.controller, 
    this.hintSize = 14, 
    this.hintText, 
    this.contentPadding = const EdgeInsets.symmetric(vertical: 15, horizontal: 25),  
    this.transparency = 0.1, this.maxLines = 6, 
    this.icon, this.secure = false, 
    this.maxLength = 20000,
    this.minLength = 1
  });
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final bool secure, expands;
  final int maxLength, maxLines, minLength;
  final double transparency, hintSize;
  final EdgeInsetsGeometry contentPadding;
  Widget build(BuildContext context) {
    return TextFormField(
      expands: expands,
      maxLines: maxLines,
      maxLength: maxLength,
      controller: controller,
      obscureText: secure,
      style: TextStyle(fontSize: 14),
      decoration: InputDecoration(
        counterText: "",
        filled: true,
        fillColor: Colors.lightBlue.withOpacity(transparency),
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: hintSize,
          color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor.withOpacity(0.5),
        ),
        contentPadding: contentPadding,
        disabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(5), 
          borderSide: BorderSide(color: Colors.transparent)
        ),
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(5), 
          borderSide: BorderSide(color: Colors.transparent)
        ), 
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(5), 
          borderSide: BorderSide(color: Colors.transparent)
        ),
        errorBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(5), 
          borderSide: BorderSide(color: Colors.transparent)
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(5), 
          borderSide: BorderSide(color: Colors.transparent)
        )
      ),
    );
  }
}