import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GymPicPicker extends StatelessWidget {
  final String? photoPath;
  final GymData? editGym;
  final VoidCallback deletePhoto;
  final Function(XFile xFile) pickPhoto;
  const GymPicPicker({
    super.key,
    this.photoPath,
    required this.deletePhoto,
    required this.pickPhoto,
    this.editGym,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    ImageProvider imageProvider = const AssetImage('assets/no_image_gym.jpg');
    if (photoPath != null) {
      if (photoPath == editGym?.photoURL) {
        imageProvider = NetworkImage(photoPath!);
      } else {
        imageProvider = FileImage(File(photoPath!));
      }
    }
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(CupertinoIcons.photo),
                  ),
                  AutoSizeText(
                    appLocalizations.gymPicture,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
            CircleAvatar(
              radius: 80,
              backgroundImage: imageProvider,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //DELETE PIC
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: photoPath == null
                        ? null
                        : () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(appLocalizations.deletePPPrompt),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(appLocalizations.no),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      deletePhoto();
                                      Navigator.pop(context);
                                    },
                                    child: Text(appLocalizations.yes),
                                  ),
                                ],
                              ),
                            );
                          },
                    icon: const Icon(CupertinoIcons.delete),
                  ),
                ),
                //CREATE PIC
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: () async {
                      ImagePicker imagePicker = ImagePicker();
                      ImageSource? imageSource;
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(appLocalizations.chooseSource),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  imageSource = ImageSource.camera;
                                  Navigator.pop(context);
                                },
                                child: Text(appLocalizations.camera),
                              ),
                              TextButton(
                                onPressed: () {
                                  imageSource = ImageSource.gallery;
                                  Navigator.pop(context);
                                },
                                child: Text(appLocalizations.gallery),
                              ),
                            ],
                          );
                        },
                      );
                      if (imageSource == null) {
                        return;
                      }
                      XFile? xFile = await imagePicker.pickImage(
                        source: imageSource!,
                        imageQuality: 20,
                      );
                      if (xFile == null) {
                        return;
                      }
                      pickPhoto(xFile);
                    },
                    icon: const Icon(CupertinoIcons.camera),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
