import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:teamclock/core/utilities/ringtones_class.dart';

class Ringtone {

  final String path;
  final LoopMode loop;

  const Ringtone({
    this.path = Ringtones.defaultRingtone,
    this.loop = LoopMode.one,
  });

  // fromJson method to map JSON to Ringtone object
  factory Ringtone.fromJson(Map<String, dynamic> json) {
    return Ringtone(
      path: json['path'] ?? '',  // Default to empty string if path is null
      loop: json['loop'] == 1 ? LoopMode.one : LoopMode.off,  // Mapping loop value
    );
  }

  // toJson method to serialize Ringtone object to JSON
  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'loop': loop == LoopMode.one ? 1 : 0,  // Serialize loop to 1 or 0
    };
  }
}

