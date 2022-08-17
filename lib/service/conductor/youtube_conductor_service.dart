import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mutex/mutex.dart';

import 'package:the_baetles_chord_play/domain/model/loop.dart';
import 'package:the_baetles_chord_play/service/conductor/conductor_interface.dart';
import 'package:the_baetles_chord_play/service/conductor/performer_interface.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../domain/model/play_state.dart';

class YoutubeConductorService implements ConductorInterface {
  static const Duration syncPeriod = Duration(milliseconds: 30);

  final List<PerformerInterface> performers = [];
  YoutubePlayerController? _youtubeController;

  final Mutex lock = Mutex();

  late PlayState _playState;
  final ValueNotifier<int> _currentPosition = ValueNotifier(0); // ms
  final List<Function(PlayState)> _onPositionChangeCallbacks = [];
  Timer? _timer;

  YoutubeConductorService({required final PlayState initialPlayState}) {
    _playState = initialPlayState;

    syncPlayState();
  }

  Future<void> setYoutubeController(
    final YoutubePlayerController controller,
  ) async {
    _youtubeController = controller;
    await syncPlayState();
  }

  @override
  Future<void> addPerformer(PerformerInterface performer) async {
    performers.add(performer);
    performer.onAttachConductor(this);
    await syncPlayState();
  }

  @override
  Future<bool> syncPlayState({
    bool? isPlaying,
    int? currentPosition,
    double? tempo,
    double? defaultBpm,
    Loop? loop,
    int? capo,
  }) async {
    await lock.acquire();

    if (_youtubeController == null) {
      return false;
    }

    try {
      PlayState newPlayState = _playState.copy(
        isPlaying: isPlaying,
        currentPosition: currentPosition ?? (_currentPosition.value),
        tempo: tempo,
        defaultBpm: defaultBpm,
        loop: loop,
        capo: capo,
      );

      _syncPlayStateWithPerformers(performers, newPlayState);

      _syncPlayStateWithYoutubeController(_youtubeController!, newPlayState);

      _playState = newPlayState;
    } on Exception {
      if (kDebugMode) {
        print("Youtube conductor service: error");
      }
    } finally {
      lock.release();
    }

    return true;
  }

  @override
  void addCurrentPositionListener(Function(PlayState) callBack) {
    _onPositionChangeCallbacks.add(callBack);

    if (_onPositionChangeCallbacks.length == 1) {
      // 주기적으로 currentPosition과 youtubeController.position 동기화
      _timer = Timer.periodic(syncPeriod, (timer) {
        if (!lock.isLocked && _youtubeController != null) {
          _currentPosition.value =
              _youtubeController!.value.position.inMilliseconds;

          _playState.setCurrentPosition(_currentPosition.value);

          for (Function callback in _onPositionChangeCallbacks) {
            callback(_playState);
          }
        }
      });
    }
  }

  @override
  void removeCurrentPositionListener(Function(PlayState) callBack) {
    bool isRemoved = _onPositionChangeCallbacks.remove(callBack);

    if (isRemoved && _onPositionChangeCallbacks.isEmpty) {
      _timer?.cancel();
    }
  }

  Future<bool> _syncPlayStateWithPerformers(List<PerformerInterface> performers, PlayState playState) async {
    final List<Future<bool>> syncTasks = [];

    // play state 전파
    for (PerformerInterface performer in performers) {
      syncTasks.add(performer.syncPlayStateAndReady(playState));
    }

    // performer 적용 완료 대기
    for (int taskIdx = 0; taskIdx < syncTasks.length; ++taskIdx) {
      bool isReadySuccessful = await syncTasks[taskIdx];

      if (!isReadySuccessful) {
        // TODO : 대기 상태 취소
        return false;
      }
    }

    return true;
  }

  Future<void> _syncPlayStateWithYoutubeController(YoutubePlayerController controller, PlayState playState) async {
    // youtube controller play state 적용
    if (!(_youtubeController!.value.isReady)) {
      _youtubeController!.reload();
    }

    _youtubeController!.setPlaybackRate(playState.tempo);

    if (playState.isPlaying) {
      _youtubeController!.load(
        _youtubeController!.initialVideoId,
        startAt: playState.currentPosition ~/ 1000,
      );
    } else {
      _youtubeController!.seekTo(
        Duration(milliseconds: playState.currentPosition),
      );
      _youtubeController!.pause();
    }
  }
}