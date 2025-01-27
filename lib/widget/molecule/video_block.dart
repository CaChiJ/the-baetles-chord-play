import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_baetles_chord_play/widget/atom/app_font_families.dart';
import 'package:the_baetles_chord_play/widget/molecule/duration_badge.dart';
import 'package:the_baetles_chord_play/widget/molecule/music_sheet_count.dart';
import 'package:the_baetles_chord_play/widget/molecule/play_count.dart';
import 'package:the_baetles_chord_play/widget/molecule/video_summary.dart';

import '../../domain/model/video.dart';
import '../atom/app_colors.dart';
import 'video_thumbnail.dart';

class VideoBlock extends StatelessWidget {
  final Video video;
  final Function(Video)? onClick;

  const VideoBlock({
    Key? key,
    required this.video,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onClick?.call(video);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        height: 100,
        color: Colors.white,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _videoThumbnail(context),
                Container(
                  width: 14,
                ),
                Expanded(
                  flex: 1,
                  child: VideoSummary(
                    video: video,
                    titleMaxLines: 2,
                    width: 10,
                    titleTextStyle: const TextStyle(
                      fontSize: 15,
                      fontFamily: AppFontFamilies.pretendard,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _videoThumbnail(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: VideoThumbnail(
        thumbnailPath: video.thumbnailPath,
        width: 80,
        height: 80,
      ),
    );
  }
}
