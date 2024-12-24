import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:time_slider/Model/ringtones_class.dart';

class Ringtone {
  final String path;
  final LoopMode loop;
  const Ringtone({
    this.path = Ringtones.defaultRingtone,
    this.loop = LoopMode.one,
  });
}
