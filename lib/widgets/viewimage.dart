import 'package:flutter/material.dart';

class ViewImage extends StatelessWidget {
  final String? imageUrl;
  const ViewImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: imageUrl != null
                ? Image.network(imageUrl!)
                : Image.asset('no_image.jpg'),
          ),
        ],
      ),
    );
  }
}
