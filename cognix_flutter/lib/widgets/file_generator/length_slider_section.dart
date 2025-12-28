import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LengthSliderSection extends StatelessWidget {
  final double pageCount;
  final ValueChanged<double> onChanged;

  const LengthSliderSection({
    super.key,
    required this.pageCount,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "TARGET LENGTH",
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey[500],
                letterSpacing: 1.2,
              ),
            ),
            Text(
              "${pageCount.toInt()} Pages",
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.blue[600],
            inactiveTrackColor: Colors.blue[100],
            thumbColor: Colors.white,
            overlayColor: Colors.blue.withOpacity(0.1),
            thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 12, elevation: 4),
            trackHeight: 6,
          ),
          child: Slider(
            value: pageCount,
            min: 10,
            max: 15,
            divisions: 5,
            onChanged: onChanged,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("10 pgs",
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
              Text("15 pgs",
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }
}
