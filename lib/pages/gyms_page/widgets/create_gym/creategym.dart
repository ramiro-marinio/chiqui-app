import 'package:flutter/material.dart';
import 'package:gymapp/firebase/widgets/profile_config/adaptivedivider.dart';
import 'package:gymapp/pages/gyms_page/widgets/create_gym/fields/controllerfield.dart';

class CreateGym extends StatefulWidget {
  const CreateGym({super.key});

  @override
  State<CreateGym> createState() => _CreateGymState();
}

class _CreateGymState extends State<CreateGym> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create a Gym"),
      ),
      body: Column(
        children: [
          const Text(
            "Create your Gym",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
          ControllerField(
            icon: const Icon(Icons.edit),
            title: "Gym Name",
            controller: TextEditingController(),
          ),
          const AdaptiveDivider(),
          ControllerField(
            controller: TextEditingController(),
            title: "Gym Description",
            maxLines: 6,
            icon: const Icon(Icons.info),
          ),
          const AdaptiveDivider()
        ],
      ),
    );
  }
}
