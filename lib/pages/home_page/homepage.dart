import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/news/newsdata.dart';
import 'package:gymapp/navigation/widgets/navigationdrawer.dart';
import 'package:gymapp/pages/home_page/widgets/article.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(
        title: Text(appLocalizations.homePage),
      ),
      body: ListView(
        addAutomaticKeepAlives: false,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              appLocalizations.welcome,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          FutureBuilder(
            future: getNews,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<NewsData>? news = snapshot.data;
                if (news == null) {
                  return Text(appLocalizations.generalError);
                }
                return Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          appLocalizations.recentNews,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 25),
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
