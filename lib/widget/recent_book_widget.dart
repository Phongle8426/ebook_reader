import 'package:ebook_reader/widget/pages/preview_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/book_model.dart';

class RecentBook extends StatelessWidget {
  final List<PreviewBook> bookList;
  const RecentBook(this.bookList);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Truyện đã đọc',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 5,
            ),
            height: MediaQuery.of(context).size.height * 0.3,
            child: ListView.builder(
              itemBuilder: (ctx, i) => GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    PreviewPage.routeName,
                    arguments: bookList[i].idBook
                  );
                },
                child: Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            top: 10,
                            left: 5,
                          ),
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Stack(
                            children: [
                              Container(
                                width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.4),
                                      blurRadius: 5,
                                      offset: Offset(8, 8),
                                      spreadRadius: 1,
                                    )
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    bookList[i].coverImage,
                                    loadingBuilder: (context, child, loadingProgress) => loadingProgress == null
                                    ? child
                                    : Container(
                                      child: Center(child: CircularProgressIndicator(),),
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height * 0.2,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: new LinearGradient(
                                    colors: [
                                      Colors.black.withOpacity(0.4),
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.4),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          bookList[i].name,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 30,
                    ),
                  ],
                ),
              ),
              itemCount: bookList.length,
              scrollDirection: Axis.horizontal,
            ),
          )
        ],
      ),
    );
  }
}