import 'package:flutter/material.dart';

import '../../../../../generated/assets.dart';

class ScoreStarView extends StatelessWidget {
  const ScoreStarView({super.key, required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _createStarsWidget(),
    );
  }

  List<Widget> _createStarsWidget() {
    var starCount = 0;

    if (score >= 5) {
      starCount = 5;
    } else if (score < 1) {
      starCount = 1;
    } else {
      starCount = score;
    }

    List<Widget> stars = [];

    List.generate(starCount, (index) {
      stars.add(const Image(image: AssetImage(Assets.imageStarLight)));
    });

    if (stars.length < 6) {
      List.generate(5 - starCount, (index) {
        stars.add(const Image(image: AssetImage(Assets.imageStarGrey)));
      });
    }

    return stars;
  }
}
