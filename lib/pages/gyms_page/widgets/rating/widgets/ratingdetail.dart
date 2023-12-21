import 'package:flutter/material.dart';
import 'package:gymapp/functions/adaptive_color.dart';
import 'package:gymapp/pages/gyms_page/widgets/rating/data/ratingdata.dart';
import 'package:gymapp/widgets/crawl.dart';

class RatingDetail extends StatelessWidget {
  final RatingData ratingData;
  const RatingDetail({super.key, required this.ratingData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Crawl(
        child: Text('Rating Details of "${ratingData.title}"'),
      )),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              ratingData.title,
              style: const TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: adaptiveColor(const Color.fromARGB(100, 0, 0, 0),
                      const Color.fromARGB(100, 255, 255, 255), context),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  ratingData.review.isNotEmpty
                      ? ratingData.review
                      : "No review body",
                  style: const TextStyle(fontSize: 17),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
