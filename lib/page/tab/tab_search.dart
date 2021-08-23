import "package:flutter/material.dart";
import "package:aks/ui/elements.dart";
import "package:aks/page/view_web.dart";

class TabSearch extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return Padding(
			padding: EdgeInsets.all(15),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.center,
				children: [
					Image.asset('assets/images/searchUI.png', width: 200),
					SizedBox(height: 10),
					Input(
						icon: Icons.search,
						hintText: "Cari Buku",
					),
					SizedBox(height: 10),
					Expanded(
					  child: ListView(
					    children: [
					      GridView.count(
					      	shrinkWrap: true,
					      	physics: NeverScrollableScrollPhysics(),
					      	crossAxisCount: 2,
					      	crossAxisSpacing: 3,
					      	mainAxisSpacing: 3,
					      	childAspectRatio: 1,
					      	children: [
					      		Container(
					      			decoration: BoxDecoration(
					      				border: Border.all(
					      					color: Theme.of(context).bottomNavigationBarTheme.selectedLabelStyle.color.withOpacity(0.1),
					      				),
					      				borderRadius: BorderRadius.all(Radius.circular(15))
					      			),
					      		  child: InkWell(
					      		  	onTap: () => Navigator.push(context, MaterialPageRoute(
					      		  		builder: (context) => ViewWeb(url: "https://sinta.ristekbrin.go.id/")
					      		  	)),
					      		    child: Center(
					      		    	child: Column(
					      		    		mainAxisAlignment: MainAxisAlignment.center,
					      		    		crossAxisAlignment: CrossAxisAlignment.center,
					      		    		children: [
					      		    			Image.asset("assets/images/sinta_logo.png", width: 100),
					      		    			// Text("Jurnal Sinta")
					      		    		],
					      		    	)
					      		    ),
					      		  ),
					      		),
					      		Container(
					      			decoration: BoxDecoration(
					      				border: Border.all(
					      					color: Theme.of(context).bottomNavigationBarTheme.selectedLabelStyle.color.withOpacity(0.1),
					      				),
					      				borderRadius: BorderRadius.all(Radius.circular(15))
					      			),
					      		  child: InkWell(
					      		  	borderRadius: BorderRadius.all(Radius.circular(15)),
					      		  	onTap: () => Navigator.push(context, MaterialPageRoute(
					      		  		builder: (context) => ViewWeb(url: "https://www.gutenberg.org/")
					      		  	)),
					      		    child: Center(
					      		    	child: Column(
					      		    		mainAxisAlignment: MainAxisAlignment.center,
					      		    		crossAxisAlignment: CrossAxisAlignment.center,
					      		    		children: [
					      		    			Image.asset("assets/images/pg-logo.png", width: 80),
					      		    			// Text("Gutenberg")
					      		    		],
					      		    	)
					      		    ),
					      		  ),
					      		),
					      		Container(
					      			decoration: BoxDecoration(
					      				border: Border.all(
					      					color: Theme.of(context).bottomNavigationBarTheme.selectedLabelStyle.color.withOpacity(0.1),
					      				),
					      				borderRadius: BorderRadius.all(Radius.circular(15))
					      			),
					      		  child: InkWell(
					      		  	borderRadius: BorderRadius.all(Radius.circular(15)),
					      		  	onTap: () => Navigator.push(context, MaterialPageRoute(
					      		  		builder: (context) => ViewWeb(url: "http://www.bookyards.com/mobile/authors.php")
					      		  	)),
					      		    child: Center(
					      		    	child: Column(
					      		    		mainAxisAlignment: MainAxisAlignment.center,
					      		    		crossAxisAlignment: CrossAxisAlignment.center,
					      		    		children: [
					      		    			Image.asset("assets/images/bookyards.png", width: 80),
					      		    			// Text("Bookyards")
					      		    		],
					      		    	)
					      		    ),
					      		  ),
					      		),
					      		Container(
					      			decoration: BoxDecoration(
					      				border: Border.all(
					      					color: Theme.of(context).bottomNavigationBarTheme.selectedLabelStyle.color.withOpacity(0.1),
					      				),
					      				borderRadius: BorderRadius.all(Radius.circular(15))
					      			),
					      		  child: InkWell(
					      		  	borderRadius: BorderRadius.all(Radius.circular(15)),
					      		  	onTap: () => Navigator.push(context, MaterialPageRoute(
					      		  		builder: (context) => ViewWeb(url: "https://manybooks.net/")
					      		  	)),
					      		    child: Center(
					      		    	child: Column(
					      		    		mainAxisAlignment: MainAxisAlignment.center,
					      		    		crossAxisAlignment: CrossAxisAlignment.center,
					      		    		children: [
					      		    			Image.asset("assets/images/manybooks.jpg", height: 80),
					      		    			// Text("Manybooks")
					      		    		],
					      		    	)
					      		    ),
					      		  ),
					      		),
					      		// CategoryContainer(color: Color(0xff386071), text: "Misteri"),
					      		// CategoryContainer(color: Color(0xffF9AD23), text: "Romantis"),
					      		// CategoryContainer(color: Color(0xff64B5F6), text: "Fantasi"),
					      		// CategoryContainer(color: Color(0xff818181), text: "Pengetahuan"),
					      		// CategoryContainer(color: Color(0xffF9AD23), text: "Sosial"),
					      		// CategoryContainer(color: Color(0xff386071), text: "Sejarah"),
					      		// CategoryContainer(color: Color(0xff818181), text: "Ekonomi"),
					      		// CategoryContainer(color: Color(0xff64B5F6), text: "Self Improvement"),

					      	],
					      ),
					    ],
					  ),
					)
				],
			)
		);
	}
}

class CategoryContainer extends StatelessWidget {
	CategoryContainer({this.color, this.text});
	final Color color;
	final String text;

	@override
	Widget build(BuildContext context) {
		return Card(
			elevation: 0,
			color: color,
			child: Center(
				child: Text(text, style: TextStyle(color: Colors.white)),
			)
		);
	}
}


