import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../atom/app_colors.dart';
import '../atom/app_font_families.dart';

class PlayCount extends StatelessWidget {

  final int count;
  final NumberFormat formatter;
  final bool presentPostfix;

  PlayCount({
    required this.count,
    required this.formatter,
    this.presentPostfix = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/icons/ic_play1.svg',
          width: 12,
          height: 9.6,
        ),
        const SizedBox(width: 4),
        Text(
          "${formatter.format(count)}${presentPostfix ? '회' : ''}",
          style: TextStyle(
            fontSize: 11,
            fontFamily: AppFontFamilies.pretendard,
            color: AppColors.gray80,
          ),
        ),
      ],
    );
  }
}
