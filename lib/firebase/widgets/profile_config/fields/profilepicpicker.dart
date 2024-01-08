import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/widgets/zoomavatar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilePicPicker extends StatefulWidget {
  const ProfilePicPicker({super.key});

  @override
  State<ProfilePicPicker> createState() => _ProfilePicPickerState();
}

class _ProfilePicPickerState extends State<ProfilePicPicker> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, applicationState, child) {
        String? photoURL = applicationState.user?.photoURL;
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ZoomAvatar(photoURL: photoURL, radius: 80),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //DELETE PIC
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        onPressed: photoURL == null
                            ? null
                            : () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title:
                                        const Text("Delete profile picture?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("No"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          applicationState
                                              .changeUserImage(null);
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
                          XFile? xfile = await imagePicker.pickImage(
                            source: imageSource!,
                            imageQuality: 25,
                          );
                          if (xfile == null) {
                            return;
                          }
                          photoURL = null;
                          await applicationState.changeUserImage(xfile.path);
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
      },
    );
  }
}
