import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/news/newsdata.dart';
import 'package:gymapp/navigation/widgets/navigationdrawer.dart';
import 'package:gymapp/pages/home_page/widgets/article.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

late Future<String?> currentLocale;

class _HomePageState extends State<HomePage> {
  Future<List<NewsData>?>? getNews;
  @override
  void initState() {
    super.initState();
    ApplicationState applicationState = context.read<ApplicationState>();
    currentLocale = Devicelocale.currentLocale;
    currentLocale.then((value) {
      setState(() {
        getNews = applicationState.getNews(value?.substring(0, 2) ?? 'en');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: ListView(
        addAutomaticKeepAlives: false,
        children: [
          const SizedBox(
            width: double.infinity,
            child: Text(
              'Welcome to BetterTraining',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25),
            ),
          ),
          FutureBuilder(
            future: getNews,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<NewsData>? news = snapshot.data;
                if (news == null) {
                  return const Text("error");
                }
                return Column(
                  children: [
                    const SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Recent News',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ),
                    ...List.generate(
                      news.length,
                      (index) => Article(newsData: news[index]),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
