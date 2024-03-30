import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/catgory_news_model.dart';
import '../view_models/new_view_models.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  String category = 'General'; // Default news source
  final format = DateFormat('MMMM dd, yyyy');

  List<String> CategoriesList = [
    'General',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Technology'
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery
        .of(context)
        .size
        .width;
    final height = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: CategoriesList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        category = CategoriesList[index];
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Container(
                            decoration: BoxDecoration(
                                color: category == CategoriesList[index]
                                    ? Colors.red.shade400
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 12),
                              child: Center(
                                  child: Text(
                                    CategoriesList[index].toString(),
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Colors.white,
                                    ),
                                  )),
                            )),
                      ),
                    );
                  }),
            ),
            Expanded(
              child: FutureBuilder<category_news_model>(
                  future: newsViewModel.fetchcategorynewsApi(category),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: SpinKitCircle(
                          size: 50,
                          color: Colors.red,
                        ),
                      );
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data!.articles!.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            DateTime dateTime = DateTime.parse(snapshot
                                .data!.articles![index].publishedAt
                                .toString());
                            return Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot
                                        .data!.articles![index].urlToImage ?? '',
                                    fit: BoxFit.cover,
                                    height: height * 18,
                                    width: width*.3,
                                    placeholder: (context, url) =>
                                        Container(
                                            child: Center(
                                              child: SpinKitCircle(
                                                size: 50,
                                                color: Colors.red,
                                              ),)
                                        ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset('images/not.png'),
                                  ),
                                )
                              ],
                            );
                          });
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
