import 'package:flutter/material.dart';

class ViewImage extends StatelessWidget {
  final String? imageUrl;
  const ViewImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      movementDuration: const Duration(seconds: 1),
      resizeDuration: const Duration(milliseconds: 50),
      onDismissed: (_) => Navigator.pop(context),
      direction: DismissDirection.down,
      background: Container(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        body: InteractiveViewer(
          maxScale: 5,
          child: Center(
            child: Hero(
              tag: 'Pic',
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      alignment: FractionalOffset.center,
                      image: imageUrl != null
                          ? NetworkImage(
                              imageUrl!,
                            )
                          : const AssetImage('assets/no_image.jpg')
                              as ImageProvider,
                    ),
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
