import 'dart:collection';

import 'package:the_baetles_chord_play/data/repository/auth_repository.dart';
import 'package:the_baetles_chord_play/data/repository/video_repository.dart';

import '../model/video.dart';

class GetRecommendedVideo {
  final VideoRepository _videoRepository;
  final AuthRepository _authRepository;

  GetRecommendedVideo(this._videoRepository, this._authRepository);

  Future<UnmodifiableListView<Video>> call({
    int offset = 0,
    int limit = 20,
  }) async {
    String idToken = (await _authRepository.fetchIdToken())! as String;
    return await _videoRepository.fetchRecommendedVideos(offset: offset, limit: limit);
  }
}
