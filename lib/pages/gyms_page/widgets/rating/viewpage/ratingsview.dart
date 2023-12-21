import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/pages/gyms_page/widgets/rating/data/ratingdata.dart';
import 'package:gymapp/pages/gyms_page/widgets/rating/widgets/rating.dart';
import 'package:provider/provider.dart';

class RatingsView extends StatefulWidget {
  final GymData gymData;
  final int page;
  const RatingsView({super.key, required this.gymData, required this.page});

  @override
  State<RatingsView> createState() => _RatingsViewState();
}

class _RatingsViewState extends State<RatingsView> {
  late ApplicationState applicationState;
  late Future<List<RatingData>> getRatingData;
  @override
  void initState() {
    super.initState();
    applicationState = context.read<ApplicationState>();
    getRatingData =
        applicationState.getRatings(widget.gymData.id!, widget.page);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getRatingData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final List<RatingData> data = snapshot.data!;
          if (data.length > 30) {
            data.removeRange(0, ((widget.page - 1) * 30) - 1);
          }
          return ListView(
            children: List.generate(
              data.length,
              (index) => RatingTile(
                ratingData: data[index],
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
      },
    );
  }
}
