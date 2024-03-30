import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/NewsHeadlinesModel.dart';
import 'package:news_app/screens/categoryscreen.dart';
import 'package:news_app/view_models/new_view_models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList { thetimesofindia, thehindu, Google_News }

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  FilterList? selectedMenu;
  String name = 'the-times-of-india'; // Default news source
  late Future<NewsHeadlinesModel> _newsModelFuture;
  final format = DateFormat('MMMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    _newsModelFuture = newsViewModel
        .fetchNewsChannelHeadLinesApi(name); // Fetch news with default source
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CategoryScreen()));
          },
          icon: Image.asset(
            'images/iconn.png',
            height: 30,color: Colors.red,
          ),
        ),
        title: Row(children: [
          Text(
            'News',
            style: GoogleFonts.poppins( fontSize: 28,
              fontWeight: FontWeight.w600,),
          ),
          Text(
            ' Time',
            style:
          TextStyle(
            color: Colors.red,fontSize: 18,fontWeight: FontWeight.w500,backgroundColor: Colors.black38,letterSpacing: 5
          )
          )
        ],
        ),
        actions: [
          PopupMenuButton(color: Colors.red.shade300,iconColor: Colors.red,
            initialValue: selectedMenu,
            onSelected: (FilterList item) {
              if (item == FilterList.thetimesofindia) {
                name = 'the-times-of-india';
              } else if (item == FilterList.thehindu) {
                name = 'the-hindu';
              } else if (item == FilterList.Google_News) {
                name = 'google-news-in';
              }
              setState(() {
                selectedMenu = item;
                _newsModelFuture = newsViewModel.fetchNewsChannelHeadLinesApi(
                    name); // Fetch news with selected source
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<FilterList>>[
              const PopupMenuItem<FilterList>(
                value: FilterList.thehindu,
                child: Text('The Hindu'),
              ),
              const PopupMenuItem<FilterList>(
                value: FilterList.thetimesofindia,
                child: Text('The Times of India'),
              ),
              const PopupMenuItem<FilterList>(
                value: FilterList.Google_News,
                child: Text('Google_News'),
              )
            ],
          )
        ],
      ),
      body: FutureBuilder<NewsHeadlinesModel>(
        future: _newsModelFuture,
        builder:
            (BuildContext context, AsyncSnapshot<NewsHeadlinesModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SpinKitCircle(
                size: 50,
                color: Colors.red,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final articles = snapshot.data!.articles!;
            return SizedBox(
              height: height * 0.55,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  final article = articles[index];
                  final dateTime =
                      DateTime.parse(article.publishedAt.toString());
                  return Container(
                    width: width * 0.7,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 3,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                article.urlToImage ?? '', // Load image URL
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(
                                    child: SpinKitFadingCircle(
                                      color: Colors.red,
                                      size: 30,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.asset('images/not.png'),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    article.title ?? '', // Display headline
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        article.source?.name ?? '',
                                        // Display source
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        format.format(dateTime), // Display date
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
