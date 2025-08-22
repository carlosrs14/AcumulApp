import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class StampContainer extends StatefulWidget {
  final List<bool> stamps;
  const StampContainer({super.key, required this.stamps});

  @override
  State<StampContainer> createState() => _StampContainerState();
}

class _StampContainerState extends State<StampContainer> {
  @override
  Widget build(BuildContext context) {
    const int rows = 3;
    const int columns = 4;
    const double itemSize = 40;
    const double spacing = 1;

    return SizedBox(
      height: (itemSize * columns) + (spacing * (columns - 1)),
      child: GridView.builder(
        scrollDirection: Axis.vertical,
        itemCount: widget.stamps.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          childAspectRatio: 1,
        ),
        itemBuilder: (_, index) {
          final cat = widget.stamps[index];

          return Container(
            width: itemSize,
            height: itemSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.transparent, width: 2),
            ),
            child: Center(
              child: Icon(
                cat ? MdiIcons.starCircle : MdiIcons.starCircleOutline,
                color: cat ? Colors.amber : Colors.grey,
                size: 39,
              ),
            ),
          );
        },
      ),
    );
  }
}
