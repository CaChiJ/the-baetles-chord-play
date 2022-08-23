import 'package:flutter/foundation.dart';
import 'package:the_baetles_chord_play/domain/model/triad_type.dart';

import 'note.dart';

class Chord {
  final Note root;
  final TriadType triadType;

  Chord(this.root, this.triadType);

  String get chordName {
    return '${root.rootName}${triadType.notation}';
  }

  factory Chord.fromString(String chord) {
    List<String> splitString = chord.split(":");
    Note root = Note.fromNoteName(splitString[0]);
    TriadType triadType = TriadType.values.singleWhere(
            (triad) => triad.notation == splitString[1]
    );

    return Chord(root, triadType);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Chord &&
          runtimeType == other.runtimeType &&
          root == other.root &&
          triadType == other.triadType;

  @override
  int get hashCode => root.hashCode ^ triadType.hashCode;

  List<Note> getNotes() {
    switch(this.triadType) {
      case TriadType.major:
        return [root, Note(root.noteNumber + 4), Note(root.noteNumber + 3)];
      case TriadType.minor:
        return [root, Note(root.noteNumber + 3), Note(root.noteNumber + 4)];
      default:
        if (kDebugMode) {
          print("warning! undefined triadType for method 'getNotes'");
        }
        return [root];
    }
  }
}