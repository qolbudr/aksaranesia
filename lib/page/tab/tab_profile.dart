import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aks/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter_slidable/flutter_slidable.dart";
import "package:aks/function/get_profiledata.dart";
import "package:readmore/readmore.dart";
import "package:aks/page/view_writing.dart";

class TabProfile extends StatefulWidget {
	@override
	_TabProfileState createState() => _TabProfileState();
}

class _TabProfileState extends State<TabProfile> with SingleTickerProviderStateMixin {
	TabController _controller;
	UserData user;
	FirebaseAuth _auth = FirebaseAuth.instance;

	final List<dynamic> buku = [
		[
			"https://cdn.gramedia.com/uploads/items/9786230304750_REVENGE_CLUB_1_1-1__w150_hauto.jpg",
			"Akasha : Revenge Club 01",
			"ANAJIRO/AOISEI"
		],
		[
			"https://cdn.gramedia.com/uploads/items/9786024526986_Sebuah-Seni-Untuk-Bersikap-Bodo-Amat__w150_hauto.jpg",
			"Sebuah Seni untuk Bersikap Bodo Amat",
			"Mark Manson"
		],
		[
			"https://cdn.gramedia.com/uploads/items/selamat_tinggal__w150_hauto.jpg",
			"Selamat Tinggal",
			"Tere Liye"
		],
		[
			"https://cdn.gramedia.com/uploads/items/9786020645667__w150_hauto.jpeg",
			"Shine",
			"Jessica Jung"
		],
		[
			"https://cdn.gramedia.com/uploads/items/9786020451060_Love-in-Chaos__w150_hauto.jpg",
			"Love in Chaos",
			"Yenny Marissa"
		],
	];

	@override
  void initState() {
    super.initState();
    _controller = new TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


	@override
	Widget build(BuildContext context) {
		user = context.watch<UserNotifier>().user;
		return Column(
			children: [
				Container(
					width: double.infinity,
					padding: EdgeInsets.all(15),
					color: Theme.of(context).primaryColor,
					child: Row(
						mainAxisAlignment: MainAxisAlignment.spaceBetween,
						crossAxisAlignment: CrossAxisAlignment.start,
					  children: [
					    Expanded(
					      child: Row(
					      	crossAxisAlignment: CrossAxisAlignment.start,
					      	children: [
					      		CircleAvatar(
				              backgroundColor: Colors.grey,
				              radius: 30,
				              child: ClipOval(
				                child: _auth.currentUser.photoURL == null ? 
				                  FadeInImage(image: AssetImage('assets/images/user.png'), placeholder: AssetImage('assets/images/user.png'))
				                :
				                  FadeInImage(image: NetworkImage(_auth.currentUser.photoURL), placeholder: AssetImage('assets/images/user.png')),
				              ),
					          ),
					          SizedBox(width: 10),
					          Expanded(
					            child: Column(
					            	crossAxisAlignment: CrossAxisAlignment.start,
					            	children: [
					            		Text(_auth.currentUser.displayName, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
					            		SizedBox(height: 5),
					            		Text((user.bio == "" || user.bio == null) ? "-" : user.bio, style: TextStyle(color: Colors.white))
					            	]
					            ),
					          ),
					      	]
					      ),
					    ),
					    Column(
					    	children: [
					    		Text("${user.points} pts", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
					    		SizedBox(height: 5),
					    		Image.asset('assets/images/medal.png', height: 25),
					    	],
					    )
					  ],
					)
				),
				Container(
            color: Theme.of(context).appBarTheme.backgroundColor,
            child: TabBar(
            controller: _controller,
            tabs: [
               Tab(child: Text("Status")),
               Tab(child: Text("Bacaan")),
               Tab(child: Text("Tulisan")),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _controller,
              children: [
                Column(
                	children: [
                		StreamBuilder<QuerySnapshot>(
                		  stream: ProfileData.getStatus(),
                		  builder: (context, status) {
                		    if(status.data == null) {
                		    	return SizedBox(
                		    		width: double.infinity,
                						height: 2,
                						child: LinearProgressIndicator(minHeight: 2)
                					);
                		    } else {
                		    	var statuses = status.data.docs;
                		    	if(statuses.length <= 0) {
                		    		return Expanded(
                		    		  child: Center(
                		    		  	child: Column(
                		    		  		mainAxisAlignment: MainAxisAlignment.center,
                		    		  		children: [
                		    		  			Image.asset("assets/images/empty.png", width: 200),
                		    		  			Text("Wah belum ada status nih...")
                		    		  		]
                		    		  	)
                		    		  ),
                		    		);
                		    	} else {
                		    		return Expanded(
                		    		  child: ListView.builder(
																itemCount: statuses.length,
																padding: EdgeInsets.only(top: 15, left: 15, right: 15),
																itemBuilder: (context, index) {
																	DateTime date = statuses[index]['created'].toDate();
																	return Slidable(
																	  actionPane: SlidableDrawerActionPane(),
																	  actionExtentRatio: 0.25,
																	  child: Column(
		                                  children: [
		                                    Padding(
		                                      padding: const EdgeInsets.symmetric(horizontal: 5),
		                                      child: Row(
		                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
		                                        children: [
		                                          Row(
		                                            children: [
		                                              Container(
		                                                width: 40,
		                                                height: 40,
		                                                child: _auth.currentUser.photoURL == null ?
		                                                  FadeInImage(image: AssetImage('assets/images/user.png'), placeholder: AssetImage('assets/images/user.png'))
		                                                :
		                                                  FadeInImage(image: NetworkImage(_auth.currentUser.photoURL), placeholder: AssetImage('assets/images/user.png'))

		                                              ),
		                                              SizedBox(width: 10),
		                                              Text(_auth.currentUser.displayName)
		                                            ],
		                                          ),
		                                          Text("${date.day}/${date.month}/${date.year}"),
		                                        ],
		                                      ),
		                                    ),
		                                    SizedBox(height: 5),
		                                    Row(
		                                      children: [
		                                        Expanded(
		                                          child: Card(
		                                            elevation: 0,
		                                            child: Container(
		                                              padding: EdgeInsets.all(20),
		                                              child: ReadMoreText(
		                                              	"${statuses[index]['text']}",
		                                              	colorClickableText: Colors.blue.withOpacity(0.7),
																	                  trimMode: TrimMode.Line,
																	                  trimLines: 3,
																	                  trimCollapsedText: "...Lanjutkan Membaca",
																	                  trimExpandedText: "\n\nCiutkan",
																	                  delimiter: "",
																	                  style: TextStyle(fontSize: 13)
		                                              )
		                                            )
		                                          ),
		                                        ),
		                                      ],
		                                    ),
		                                    SizedBox(height: 20),
		                                  ],
		                                ),
																	  secondaryActions: <Widget>[
																	    new IconSlideAction(
																	      caption: 'Delete',
																	      color: Colors.red,
																	      icon: Icons.delete,
																	      onTap: () => ProfileData.deleteStatus(statuses[index].id),
																	    ),
																	  ],
																	);
																},
															),
                		    		);
                		    	}
                		    }
                		  }
                		)
                	],
                ),
                Column(
                	children: [
                		/* Expanded(
											child: Padding(
												padding: EdgeInsets.only(top:15, left:15, right: 15),
												child: ListView.separated(
													separatorBuilder: (context, index) => SizedBox(height: 5),
													itemCount: 5,
													itemBuilder: (context, index) {
														return Slidable(
														  actionPane: SlidableDrawerActionPane(),
														  actionExtentRatio: 0.25,
														  child: Container(
														  	width: double.infinity,
														  	height: 120,
														  	padding: EdgeInsets.all(15),
														    color: Theme.of(context).cardColor,
														    child: Row(
														    	crossAxisAlignment: CrossAxisAlignment.center,
														    	mainAxisAlignment: MainAxisAlignment.start,
														    	children: [
														    		Image.network(buku[index][0], height: 90),
														    		SizedBox(width: 15),
														    		Expanded(
														    		  child: Column(
														    		  	crossAxisAlignment: CrossAxisAlignment.start,
														    		  	children: [
														    		  		Text(buku[index][1], style: TextStyle(fontWeight: FontWeight.w600)),
														    		  		SizedBox(height: 5),
														    		  		Text(buku[index][2], style: TextStyle(fontWeight: FontWeight.w300))
														    		  	],
														    		  ),
														    		)
														    	],
														    ),
														  ),
														  secondaryActions: <Widget>[
														    new IconSlideAction(
														      caption: 'Delete',
														      color: Colors.red,
														      icon: Icons.delete,
														      onTap: () => null,
														    ),
														  ],
														);
													},
												)
											),
										) */
										Expanded(
							  			child: Column(
							  				mainAxisAlignment: MainAxisAlignment.center,
							  				crossAxisAlignment: CrossAxisAlignment.center,
							  				children: [
						  						Image.asset("assets/images/comingSoon.png", width: 200),
						  						Container(
						  							child: Padding(
						  							  padding: const EdgeInsets.symmetric(horizontal: 30),
						  							  child: Text("Kami sedang mempersiapkan fitur unik untuk kamu", textAlign: TextAlign.center),
						  							)
						  						)
						  					],
						  				)
						  			)
                	],
                ),
                Column(
                	children: [
                		StreamBuilder<QuerySnapshot>(
                			stream: ProfileData.getWriting(),
                			builder: (context, write) {
                				if(write.data == null) {
                					return SizedBox(
                						width: double.infinity,
                						height: 2,
                						child: LinearProgressIndicator(minHeight: 2)
                					);
            						} else {
              							var writes = write.data.docs;
              							if(writes.length <= 0) {
              								return Expanded(
              								  child: Center(
		                		    			child: Column(
		                		    				mainAxisAlignment: MainAxisAlignment.center,
		                		    				children: [
	                		    					Image.asset("assets/images/empty.png", width: 200),
	                		    					Text("Wah belum ada tulisan nih...")
	                		    				]
	                		    			)
                		    			),
              							);
          								} else {
          									return Expanded(
          									  child: ListView.separated(
          									  	separatorBuilder: (context, index) => SizedBox(height:5),
          									  	itemCount: writes.length,
          									  	padding: EdgeInsets.only(top: 15, left: 15, right: 15),
          									  	itemBuilder: (context, index) {
          									  		return Slidable(
          									  			actionPane: SlidableDrawerActionPane(),
																  actionExtentRatio: 0.25,
																  child: ListTile(
																  	onTap: () => Navigator.push(context, MaterialPageRoute(
          									  				builder: (context) => ViewWriting(id: writes[index].id)
          									  			)),
																  	tileColor: Theme.of(context).cardColor,
																  	leading: CircleAvatar(
															        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
															        child: Icon(Icons.book_outlined),
															        foregroundColor: Theme.of(context).primaryColor,
															      ),
															      title: Text(writes[index]["title"]),
															      subtitle: Text(_auth.currentUser.displayName),
																  ),
          									  			secondaryActions: <Widget>[
																    new IconSlideAction(
																      caption: 'Delete',
																      color: Colors.red,
																      icon: Icons.delete,
																      onTap: () {
																      	ProfileData.deleteWriting(writes[index].id, user.points).whenComplete(() {
																      		context.read<UserNotifier>().setUser(
										                        user.classCode,
										                        user.address,
										                        user.bio,
										                        user.points - 75,
										                        user.type
										                      );
																      	});
																      }
																    ),
																  ],
        									  		);
        									  	},
        									  ),
        									);
        								}
          						}
              			}
              		)
              	],
              ),
            ]
          ),
        )
			]
		);
	}
}
