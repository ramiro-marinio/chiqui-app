import 'package:flutter/material.dart';

class Crawl extends StatefulWidget {
  final Widget child;
  const Crawl({required this.child, super.key});

  @override
  State<Crawl> createState() => _CrawlState();
}

class _CrawlState extends State<Crawl> {
  final _controller = ScrollController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      double maxExtent = _controller.position.maxScrollExtent;
      double minExtent = _controller.position.minScrollExtent;
      autoSlide(maxExtent, minExtent, maxExtent);
    });
  }

  void autoSlide(double max, double min, double direction) {
    double distance = max - min;
    _controller
        .animateTo(
      direction,
      duration: Duration(milliseconds: distance.toInt() * 50),
      curve: Curves.linear,
    )
        .then((_) {
      if (direction == max) {
        direction = 0;
      } else {
        direction = max;
      }
      Future.delayed(
        const Duration(seconds: 3),
        () {
          autoSlide(max, min, direction);
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return SingleChildScrollView(
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: widget.child);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
