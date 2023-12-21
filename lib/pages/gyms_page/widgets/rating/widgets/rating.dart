import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gymapp/functions/adaptive_color.dart';
import 'package:gymapp/pages/gyms_page/widgets/rating/data/ratingdata.dart';
import 'package:gymapp/pages/gyms_page/widgets/rating/widgets/ratingdetail.dart';
import 'package:gymapp/widgets/crawltext.dart';

class RatingTile extends StatelessWidget {
  final RatingData ratingData;
  const RatingTile({super.key, required this.ratingData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: adaptiveColor(const Color.fromARGB(255, 219, 208, 109),
              const Color.fromARGB(255, 98, 93, 43), context),
          child: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RatingDetail(
                    ratingData: ratingData,
                  ),
                ),
              );
            },
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 36,
                    backgroundImage: AssetImage('assets/no_image.jpg'),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                              child: Crawl(
                            child: Text(
                              ratingData.title,
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          ratingData.review,
                          maxLines: 2,
                          style: const TextStyle(fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          RatingBarIndicator(
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: adaptiveColor(
                                  const Color.fromARGB(255, 173, 95, 0),
                                  const Color.fromARGB(255, 255, 255, 0),
                                  context),
                            ),
                            rating: ratingData.stars,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
