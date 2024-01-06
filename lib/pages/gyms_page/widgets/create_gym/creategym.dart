import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/firebase/widgets/profile_config/adaptivedivider.dart';
import 'package:gymapp/functions/random_string.dart';
import 'package:gymapp/functions/showprogressdialog.dart';
import 'package:gymapp/pages/gyms_page/widgets/create_gym/fields/controllerfield.dart';
import 'package:gymapp/pages/gyms_page/widgets/create_gym/fields/gympicpicker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateGym extends StatefulWidget {
  final GymData? editGym;
  const CreateGym({super.key, this.editGym});

  @override
  State<CreateGym> createState() => _CreateGymState();
}

class _CreateGymState extends State<CreateGym> {
  GymData? editGym;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? photoPath;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    editGym = widget.editGym;
    if (editGym != null) {
      nameController.text = editGym?.name ?? '';
      descriptionController.text = editGym?.description ?? '';
      photoPath ??= editGym?.photoURL;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ApplicationState applicationState =
        Provider.of<ApplicationState>(context);
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return WillPopScope(
      onWillPop: () async {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(appLocalizations.leavePrompt),
            content: Text(appLocalizations.leaveCrationDetails),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(appLocalizations.no),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text(appLocalizations.yes),
              ),
            ],
          ),
        );
        return true;
      },
      child: Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            title: Text(appLocalizations.createGym),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const AdaptiveDivider(),
                ControllerField(
                  icon: const Icon(Icons.edit),
                  title: appLocalizations.gymName,
                  controller: nameController,
                  maxLength: 100,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return appLocalizations.insertName;
                    } else {
                      return null;
                    }
                  },
                ),
                const AdaptiveDivider(),
                ControllerField(
                  controller: descriptionController,
                  title: appLocalizations.gymDescription,
                  maxLines: 6,
                  maxLength: 1500,
                  icon: const Icon(Icons.info),
                ),
                const AdaptiveDivider(),
                GymPicPicker(
                  photoPath: photoPath,
                  editGym: editGym,
                  deletePhoto: () {
                    setState(() {
                      photoPath = null;
                    });
                  },
                  pickPhoto: (xFile) {
                    setState(() {
                      photoPath = xFile.path;
                    });
                  },
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              showProgressDialog("Creating Gym...", context);
              try {
                if (editGym == null) {
                  String id = generateRandomString(28);
                  GymData startingData = GymData(
                    ownerId: applicationState.user!.uid,
                    name: nameController.text,
                    description: descriptionController.text,
                  );
                  if (photoPath != null) {
                    String photoURL =
                        (await applicationState.saveGymPic(id, photoPath!));
                    startingData.photoURL = photoURL;
                    startingData.photoName =
                        '$id.${photoPath!.split('.').last}';
                  }
                  DocumentReference gymReference =
                      await applicationState.createGym(startingData, id);
                  await applicationState.addInviteData(id);
                  await applicationState.joinGym(gymReference);
                } else {
                  String id = editGym!.id!;
                  GymData newData = GymData(
                    ownerId: applicationState.user!.uid,
                    name: nameController.text,
                    description: descriptionController.text,
                    photoURL: editGym!.photoURL,
                    photoName: editGym!.photoName,
                    id: id,
                  );
                  if (photoPath != null && photoPath != editGym?.photoURL) {
                    String photoURL =
                        (await applicationState.saveGymPic(id, photoPath!));
                    newData.photoURL = photoURL;
                  } else {
                    if (newData.photoName != null) {
                      await applicationState.deleteGymPic(newData.photoName!);
                      newData.photoURL = null;
                      newData.photoName = null;
                    }
                  }
                  await applicationState.updateGym(newData);
                }
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Gym saved successfully!"),
                    ),
                  );
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Error"),
                    ),
                  );
                }
              }
            },
            child: const Icon(Icons.check),
          ),
        ),
      ),
    );
  }
}
