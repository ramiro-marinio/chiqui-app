import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:image_picker/image_picker.dart';

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
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.photo),
                  AutoSizeText(
                    'Gym Picture',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
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
                                title: const Text("Delete photo?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("No"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      deletePhoto();
                                      Navigator.pop(context);
                                    },
                                    child: const Text("yes"),
                                  ),
                                ],
                              ),
                            );
                          },
                    icon: const Icon(Icons.delete),
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
                            title: const Text("Choose a Source"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  imageSource = ImageSource.camera;
                                  Navigator.pop(context);
                                },
                                child: const Text("Camera"),
                              ),
                              TextButton(
                                onPressed: () {
                                  imageSource = ImageSource.gallery;
                                  Navigator.pop(context);
                                },
                                child: const Text("Gallery"),
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
                    icon: const Icon(Icons.add_a_photo),
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
