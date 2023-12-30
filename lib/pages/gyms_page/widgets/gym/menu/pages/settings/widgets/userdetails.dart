import 'package:flutter/material.dart';
import 'package:gymapp/firebase/auth/userdata.dart';
import 'package:gymapp/functions/calcage.dart';

class UserDetails extends StatelessWidget {
  final UserData userData;
  const UserDetails({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  userData.displayName,
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${calculateAge(userData.birthDay)} years old',
                style: const TextStyle(fontSize: 35),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: userData.sex
                        ? const Icon(
                            Icons.female,
                            size: 30,
                          )
                        : const Icon(
                            Icons.male,
                            size: 30,
                          ),
                  ),
                  Text(
                    userData.sex ? 'Female' : 'Male',
                    style: const TextStyle(fontSize: 25),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Personal Information: \n${userData.info}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 240,
                height: 240,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(120),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(120),
                    splashColor: const Color.fromARGB(100, 255, 255, 255),
                    onTap: () {},
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(120),
                        image: DecorationImage(
                          image: userData.photoURL != null
                              ? NetworkImage(userData.photoURL!)
                              : const AssetImage('assets/no_image.jpg')
                                  as ImageProvider,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
