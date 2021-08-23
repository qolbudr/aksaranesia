import "package:flutter/material.dart";
import "package:aks/ui/elements.dart";
import "package:flutter_slidable/flutter_slidable.dart";

class TabBorrow extends StatelessWidget {
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
	Widget build(BuildContext context) {
		return Padding(
			padding: const EdgeInsets.all(10),
			child: Column(
				children: [
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
		  		]
		  	),
		);
		// return Column(
		// 	children: [
		// 		Padding(
		// 		  padding: EdgeInsets.only(top:15, left: 15, right: 15),
		// 		  child: Column(
		// 		    children: [
		// 		      Input(hintText: "Cari Buku Anda", icon: Icons.search),
		// 		      SizedBox(height: 15),
		// 		      Row(
		// 		      	children: [
		// 		      		Expanded(
		// 		      		  child: Card(
		// 		      		  	elevation: 0,
		// 		      		  	color: Color(0xff106A8D),
		// 		      		  	shape: RoundedRectangleBorder(
		// 		      		  		borderRadius: BorderRadius.circular(20),
		// 		      		  	),
		// 		      		  	child: Padding(
		// 		      		  	  padding: EdgeInsets.symmetric(vertical:10),
		// 		      		  	  child: Center(
		// 		      		  	  	child: Text("Sedang Dibaca", style: TextStyle(fontSize: 10, color: Colors.white)),
		// 		      		  	  ),
		// 		      		  	)
		// 		      		  ),
		// 		      		),
		// 		      		Expanded(
		// 		      		  child: Card(
		// 		      		  	elevation: 0,
		// 		      		  	color: Color(0xff106A8D).withOpacity(0.3),
		// 		      		  	shape: RoundedRectangleBorder(
		// 		      		  		borderRadius: BorderRadius.circular(20),
		// 		      		  	),
		// 		      		  	child: Padding(
		// 		      		  	  padding: EdgeInsets.symmetric(vertical:10),
		// 		      		  	  child: Center(
		// 		      		  	  	child: Text("Selesai Dibaca", style: TextStyle(fontSize: 10)),
		// 		      		  	  ),
		// 		      		  	)
		// 		      		  ),
		// 		      		),
		// 		      		Expanded(
		// 		      		  child: Card(
		// 		      		  	elevation: 0,
		// 		      		  	color: Color(0xff106A8D).withOpacity(0.3),
		// 		      		  	shape: RoundedRectangleBorder(
		// 		      		  		borderRadius: BorderRadius.circular(20),
		// 		      		  	),
		// 		      		  	child: Padding(
		// 		      		  	  padding: EdgeInsets.symmetric(vertical:10),
		// 		      		  	  child: Center(
		// 		      		  	  	child: Text("Ingin Dibaca", style: TextStyle(fontSize: 10)),
		// 		      		  	  ),
		// 		      		  	)
		// 		      		  ),
		// 		      		),
		// 		      	]
		// 		      ),
		// 		    ],
		// 		  ),
		// 		),
		// 		Expanded(
		// 			child: Padding(
		// 				padding: EdgeInsets.only(top:15, left:15, right: 15),
		// 				child: ListView.separated(
		// 					separatorBuilder: (context, index) => SizedBox(height: 5),
		// 					itemCount: 5,
		// 					itemBuilder: (context, index) {
		// 						return Slidable(
		// 						  actionPane: SlidableDrawerActionPane(),
		// 						  actionExtentRatio: 0.25,
		// 						  child: Container(
		// 						  	width: double.infinity,
		// 						  	height: 120,
		// 						  	padding: EdgeInsets.all(15),
		// 						    color: Theme.of(context).cardColor,
		// 						    child: Row(
		// 						    	crossAxisAlignment: CrossAxisAlignment.center,
		// 						    	mainAxisAlignment: MainAxisAlignment.start,
		// 						    	children: [
		// 						    		Image.network(buku[index][0], height: 90),
		// 						    		SizedBox(width: 15),
		// 						    		Expanded(
		// 						    		  child: Column(
		// 						    		  	crossAxisAlignment: CrossAxisAlignment.start,
		// 						    		  	children: [
		// 						    		  		Text(buku[index][1], style: TextStyle(fontWeight: FontWeight.w600)),
		// 						    		  		SizedBox(height: 5),
		// 						    		  		Text(buku[index][2], style: TextStyle(fontWeight: FontWeight.w300))
		// 						    		  	],
		// 						    		  ),
		// 						    		)
		// 						    	],
		// 						    ),
		// 						  ),
		// 						  secondaryActions: <Widget>[
		// 						    new IconSlideAction(
		// 						      caption: 'Delete',
		// 						      color: Colors.red,
		// 						      icon: Icons.delete,
		// 						      onTap: () => null,
		// 						    ),
		// 						  ],
		// 						);
		// 					},
		// 				)
		// 			),
		// 		),
		// 	]
		// );
	}
}