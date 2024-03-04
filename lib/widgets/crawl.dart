import 'package:flutter/material.dart';

class Crawl extends StatefulWidget {
  final Widget child;
  final MainAxisAlignment? mainAxisAlignment;
  const Crawl({required this.child, super.key, this.mainAxisAlignment});

  @override
  State<Crawl> createState() => _CrawlState();
}

class _CrawlState extends State<Crawl> {
  bool noScrollMode = false;
  final _controller = ScrollController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (_controller.position.maxScrollExtent > 0) {
        if (_controller.positions.isNotEmpty) {
          double maxExtent = _controller.position.maxScrollExtent;
          double minExtent = _controller.position.minScrollExtent;
          autoSlide(maxExtent, minExtent, maxExtent);
        }
      } else {
        setState(() {
          noScrollMode = true;
        });
      }
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
    return !noScrollMode
        ? SingleChildScrollView(
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: widget.child,
          )
        : Row(
            mainAxisAlignment:
                widget.mainAxisAlignment ?? MainAxisAlignment.start,
            children: [widget.child],
          );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
