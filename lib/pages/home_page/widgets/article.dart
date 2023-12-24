import 'package:flutter/material.dart';
import 'package:gymapp/firebase/news/newsdata.dart';
import 'package:url_launcher/url_launcher.dart';

class Article extends StatefulWidget {
  final NewsData newsData;
  const Article({super.key, required this.newsData});

  @override
  State<Article> createState() => _ArticleState();
}

class _ArticleState extends State<Article> {
  late final ImageProvider image;
  @override
  void initState() {
    super.initState();
    image = widget.newsData.image != null
        ? NetworkImage(widget.newsData.image!)
        : const AssetImage('assets/no_thumbnail.jpg') as ImageProvider;
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          splashColor: const Color.fromARGB(57, 33, 149, 243),
          onTap: () async {
            if (!await launchUrl(Uri.parse(widget.newsData.url))) {
              throw Exception('Could not launch ${widget.newsData.url}');
            }
          },
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('Source:${widget.newsData.source}')],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: AspectRatio(
                      aspectRatio: 3 / 2,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              alignment: FractionalOffset.center,
                              image: image),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.newsData.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
