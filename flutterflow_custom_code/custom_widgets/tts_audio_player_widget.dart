// Automatic FlutterFlow Custom Widget
// Name: TtsAudioPlayerWidget
// Description: Text-to-Speech Player widget wrapping flutter_tts for Sanskrit/Gujarati/English verse audio recitation.

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsAudioPlayerWidget extends StatefulWidget {
  const TtsAudioPlayerWidget({
    super.key,
    required this.width,
    required this.height,
    required this.textToSpeak,
    required this.languageCode,
  });

  final double width;
  final double height;
  final String textToSpeak;
  final String languageCode;

  @override
  State<TtsAudioPlayerWidget> createState() => _TtsAudioPlayerWidgetState();
}

class _TtsAudioPlayerWidgetState extends State<TtsAudioPlayerWidget> {
  late FlutterTts _flutterTts;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    _flutterTts = FlutterTts();

    _flutterTts.setStartHandler(() {
      if (mounted) setState(() => _isPlaying = true);
    });

    _flutterTts.setCompletionHandler(() {
      if (mounted) setState(() => _isPlaying = false);
    });

    _flutterTts.setErrorHandler((msg) {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  Future<void> _togglePlay() async {
    if (_isPlaying) {
      await _flutterTts.stop();
      if (mounted) setState(() => _isPlaying = false);
    } else {
      final lang = switch (widget.languageCode) {
        'gu' => 'gu-IN',
        'hi' => 'hi-IN',
        _ => 'en-US',
      };
      await _flutterTts.setLanguage(lang);
      await _flutterTts.setSpeechRate(0.45);
      await _flutterTts.setPitch(1.0);

      await _flutterTts.speak(widget.textToSpeak);
    }
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24.0),
          onTap: _togglePlay,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: const Color(0xFF6B1F2A).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(24.0),
              border: Border.all(
                color: const Color(0xFF6B1F2A).withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                  color: const Color(0xFF6B1F2A),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  _isPlaying ? 'Pause Audio' : 'Listen Audio',
                  style: const TextStyle(
                    color: Color(0xFF6B1F2A),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
