import 'package:flutter/material.dart';
import 'package:gymapp/widgets/viewimage.dart';

class ZoomAvatar extends StatelessWidget {
  final double radius;
  final String? photoURL;
  final String? tag;
  const ZoomAvatar(
      {super.key, required this.photoURL, required this.radius, this.tag});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag ?? 'Pic',
      transitionOnUserGestures: true,
      child: SizedBox(
        width: radius * 2,
        height: radius * 2,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Material(
            child: InkWell(
              borderRadius: BorderRadius.circular(radius),
              splashColor: const Color.fromARGB(100, 255, 255, 255),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewImage(
                      imageUrl: photoURL,
                      tag: tag ?? 'Pic',
                    ),
                  ),
                );
              },
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius),
                  image: DecorationImage(
                    image: photoURL != null
                        ? NetworkImage(photoURL!)
                        : const AssetImage('assets/no_image.jpg')
                            as ImageProvider,
                    fit: BoxFit.cover,
                    alignment: FractionalOffset.center,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
