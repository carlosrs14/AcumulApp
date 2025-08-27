import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingSelector extends StatefulWidget {
  final Function(double) onRatingChanged;

  const RatingSelector({super.key, required this.onRatingChanged});

  @override
  State<RatingSelector> createState() => _RatingSelectorState();
}

class _RatingSelectorState extends State<RatingSelector> {
  double _rating = 0;

  @override
  Widget build(BuildContext context) {
    return RatingBar(
      initialRating: _rating,
      itemCount: 5,
      ratingWidget: RatingWidget(
        full: Icon(Icons.star, color: Theme.of(context).colorScheme.primary),
        half: Icon(
          Icons.star_half,
          color: Theme.of(context).colorScheme.primary,
        ),
        empty: Icon(
          Icons.star_border,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      onRatingUpdate: (value) {
        setState(() => _rating = value);
        widget.onRatingChanged(value);
      },
    );
  }
}
