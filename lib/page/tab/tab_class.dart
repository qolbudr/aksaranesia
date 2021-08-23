import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import "package:aks/model/user_model.dart";
import "package:provider/provider.dart";
import 'package:aks/function/get_classdata.dart';
import "package:aks/page/view_profile.dart";


class TabClass extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		UserData user = context.watch<UserNotifier>().user;
		return Column(
			children: [
				Container(
					width: double.infinity,
					height: 200,
					color: Theme.of(context).primaryColor.withOpacity(0.2),
					padding: EdgeInsets.all(15),
					child: Row(
						children: [
							Image.asset("assets/images/classUI.png"),
							SizedBox(width: 15),
							Expanded(
								child: Column(
									mainAxisAlignment: MainAxisAlignment.center,
									children: [
										Container(
											width: double.infinity,
											decoration: BoxDecoration(
												color: Theme.of(context).primaryColor,
												borderRadius: BorderRadius.circular(15),
											),
											padding: EdgeInsets.symmetric(horizontal: 10, vertical:5),
											child: Center(child: Text(user.classCode ?? '', style: TextStyle(color: Colors.white)))
										),
										SizedBox(height: 5),
										Container(
											width: double.infinity,
											decoration: BoxDecoration(
												color: Color(0xffF9AD23),
												borderRadius: BorderRadius.circular(15),
											),
											padding: EdgeInsets.symmetric(horizontal: 10, vertical:5),
											child: Center(child: StreamBuilder<QuerySnapshot>(
											  stream: ClassData.getTeacher(user.classCode),
											  builder: (context, teacher) {
											  	if(teacher.data == null || teacher.data.docs.length <= 0) {
											  		return Text("-", style: TextStyle(color: Colors.white));
											  	} else {
											  		var teachers = teacher.data.docs;
											  		return Text(teachers[0]['displayName'], style: TextStyle(color: Colors.white));
											  	}
											  }
											))
										),
									]
								)
							),
						]
					)
				),
				Expanded(
					child: StreamBuilder<QuerySnapshot>(
					  stream: ClassData.getClassMate(user.classCode),
					  builder: (context, classmate) {
					  	if(classmate.data == null || classmate.data.docs.length <= 0) {
					  		return Container();
					  	} else {
					  		var classmates = classmate.data.docs;
					  		return ListView.separated(
					  			separatorBuilder: (context, index) => Divider(),
					  			itemCount: classmates.length,
					  			itemBuilder: (context, index) {
					  				return ListTile(
					  					onTap: () => Navigator.push(context, MaterialPageRoute(
					  						builder: (context) {
					  							return ViewProfile(
					  								classmates[index].id,
					  								classmates[index]['photoURL'],
					  								classmates[index]['points'],
					  								classmates[index]['bio'],
					  								classmates[index]['displayName'],
					  							);
					  						}
					  					)),
					  					contentPadding: EdgeInsets.symmetric(horizontal:15, vertical: 0),
					  					leading: CircleAvatar(
					              backgroundColor: Colors.grey,
					              radius: 20,
					              child: ClipOval(
					                child: classmates[index]['photoURL'] == '' ? 
					                  FadeInImage(image: AssetImage('assets/images/user.png'), placeholder: AssetImage('assets/images/user.png'))
					                :
					                  FadeInImage(image: NetworkImage(classmates[index]['photoURL']), placeholder: AssetImage('assets/images/user.png')),
					              ),
					            ),
					            title: Text(classmates[index]['displayName']),
					            subtitle: Text(classmates[index]['type'] == 0 ? 'Murid' : 'Guru'),
					            trailing: user.type == 1 ? Container(
					              child: Wrap(
					              	crossAxisAlignment: WrapCrossAlignment.center,
					              	spacing: 10,
					              	children: [
					              		Image.asset('assets/images/medal.png', height: 20),
					              		Text("${classmates[index]['points']} pts", style: TextStyle(fontSize: 15)),
					              	],
					              ),
					            ) :
					            SizedBox(),
					  				);
					  			},
						    );
					  	}
					  }
					),
				)
			],
		);
	}
}