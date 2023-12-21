import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/pages/gyms_page/widgets/rating/rate_gym.dart';
import 'package:gymapp/pages/gyms_page/widgets/rating/viewpage/ratingsview.dart';
import 'package:gymapp/widgets/crawl.dart';
import 'package:provider/provider.dart';

class ViewRatingPage extends StatefulWidget {
  final GymData gymData;
  const ViewRatingPage({super.key, required this.gymData});

  @override
  State<ViewRatingPage> createState() => _ViewRatingPageState();
}

class _ViewRatingPageState extends State<ViewRatingPage> {
  late ApplicationState applicationState;
  late Future<int> getRatingCount;
  @override
  void initState() {
    applicationState = context.read<ApplicationState>();
    super.initState();
    getRatingCount = applicationState.getRatingCount(widget.gymData.id!);
  }

  @override
  Widget build(BuildContext context) {
    final GymData gymData = widget.gymData;
    return Scaffold(
      appBar: AppBar(
        title: Crawl(child: Text("${gymData.name} ratings")),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RateGym(
                    gymData: widget.gymData,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: FutureBuilder(
          future: getRatingCount,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              int page = 0;
              final PageController pageController =
                  PageController(initialPage: page);
              int reviews = snapshot.data!;
              int pages = (reviews / 30).ceil();
              if (pages == 0) {
                pages = 1;
              }
              return Column(children: [
                Expanded(
                  child: PageView.builder(
                    controller: pageController,
                    onPageChanged: (value) {
                      setState(() {
                        page = value;
                      });
                    },
                    itemBuilder: (context, index) =>
                        RatingsView(gymData: gymData, page: index + 1),
                    itemCount: pages,
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        onPressed: page != 0
                            ? () {
                                pageController.previousPage(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.decelerate);
                              }
                            : null,
                        icon: const Icon(Icons.arrow_back_ios),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        onPressed: (page + 1 != pages)
                            ? () {
                                pageController.nextPage(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.decelerate,
                                );
                              }
                            : null,
                        icon: const Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                    Text("${page + 1}/$pages"),
                  ],
                ),
              ]);
            } else {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
          }),
    );
  }
}
