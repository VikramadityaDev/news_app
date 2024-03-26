import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/NewsHeadlinesModel.dart';
import 'package:news_app/view_models/new_view_models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery
        .sizeOf(context)
        .width * 1;
    final height = MediaQuery
        .sizeOf(context)
        .height * 1;
    NewsViewModel newsViewModel = NewsViewModel();
    final format = DateFormat('MMMM dd, yyyy');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Image.asset('images/iconn.png', height: 30,),
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 100, right: 100),
          child: Text('News', style: GoogleFonts.poppins(),),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: height * .55,
            child: FutureBuilder<NewsHeadlinesModel>(
              future: newsViewModel.fetchNewsChannelHeadLinesApi(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitCircle(
                      size: 50,
                      color: Colors.red,
                    ),
                  );
                } else {
                  return ListView.builder(
                      itemCount:snapshot.data!.articles!.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                        return SizedBox(

                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                height: height * 0.5,
                                child: Padding(
                                  padding:  EdgeInsets.symmetric(horizontal: height * 0.5,),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                      fit: BoxFit.cover,
                                      placeholder: (context, url)=> Container(child: Spinkit2),
                                      errorWidget: (context, url, error) => const Icon(Icons.error_outline,color: Colors.red,),
                                    ),
                                  ),
                                ),
                                                            ),
                              Positioned(
                                bottom: 20,
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Container(
                                    alignment: Alignment.bottomCenter,
                                    padding: EdgeInsets.all(25),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: width*0.7,
                                          child: Text(
                                            snapshot.data!.articles![index].title.toString(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(fontSize: 17,fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                          const Spacer(),
                                        SizedBox(
                                          width: width*0.7,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                snapshot.data!.articles![index].source!.name.toString(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(fontSize: 13,fontWeight: FontWeight.w600),
                                              ),
                                              Text(
                                                format.format(dateTime),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(fontSize: 12,fontWeight: FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                        ]
                          ),
                        );
                  });
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
const Spinkit2 = SpinKitFadingCircle(
color: Colors.red,
size: 50,
);