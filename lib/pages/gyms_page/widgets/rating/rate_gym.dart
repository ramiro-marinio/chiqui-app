import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/functions/adaptive_color.dart';
import 'package:gymapp/functions/showprogressdialog.dart';
import 'package:provider/provider.dart';

class RateGym extends StatefulWidget {
  final GymData gymData;
  const RateGym({super.key, required this.gymData});

  @override
  State<RateGym> createState() => _RateGymState();
}

class _RateGymState extends State<RateGym> {
  final TextEditingController _controller = TextEditingController();
  double stars = 5;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rate Gym')),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: RatingBar.builder(
                  initialRating: 5,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: adaptiveColor(const Color.fromARGB(255, 100, 77, 0),
                        Colors.amber, context),
                  ),
                  onRatingUpdate: (rating) {
                    stars = rating;
                  },
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: TextField(
              maxLines: 6,
              maxLength: 1000,
              decoration: InputDecoration(
                hintText: 'Your Review',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              showProgressDialog('Saving...', context);
              await context
                  .read<ApplicationState>()
                  .sendReview(_controller.text, stars, widget.gymData.id!);
              if (context.mounted) {
                Navigator.pop(context);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Review sent successfully!')));
              }
            },
            icon: const Icon(Icons.check),
            label: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
