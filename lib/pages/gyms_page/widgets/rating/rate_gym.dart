import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/functions/adaptive_color.dart';
import 'package:gymapp/functions/showprogressdialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RateGym extends StatefulWidget {
  final GymData gymData;
  const RateGym({super.key, required this.gymData});

  @override
  State<RateGym> createState() => _RateGymState();
}

class _RateGymState extends State<RateGym> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _controller = TextEditingController();
  double stars = 5;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: formKey,
        child: Column(
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
                      color: adaptiveColor(
                          const Color.fromARGB(255, 100, 77, 0),
                          Colors.amber,
                          context),
                    ),
                    onRatingUpdate: (rating) {
                      stars = rating;
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                maxLines: 1,
                maxLength: 50,
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.title,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.missingValue;
                  }
                  return null;
                },
                maxLines: 6,
                maxLength: 1000,
                controller: _controller,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.body,
                  border: const OutlineInputBorder(
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
                await context.read<ApplicationState>().sendRating(
                    _titleController.text,
                    _controller.text,
                    stars,
                    widget.gymData.id!);
                if (context.mounted) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              },
              icon: const Icon(Icons.check),
              label: Text(AppLocalizations.of(context)!.send),
            ),
          ],
        ),
      ),
    );
  }
}
