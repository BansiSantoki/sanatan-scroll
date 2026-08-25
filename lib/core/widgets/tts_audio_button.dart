import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../app/theme/app_colors.dart';

class TtsAudioButton extends StatefulWidget {
  const TtsAudioButton({
    super.key,
    required this.text,
    this.size = 20,
  });

  final String text;
  final double size;

  @override
  State<TtsAudioButton> createState() => _TtsAudioButtonState();
}

class _TtsAudioButtonState extends State<TtsAudioButton> {
  late final FlutterTts _tts;
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _tts = FlutterTts();
    _tts.setCompletionHandler(() {
      if (mounted) setState(() => _isSpeaking = false);
    });
    _tts.setErrorHandler((_) {
      if (mounted) setState(() => _isSpeaking = false);
    });
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Future<void> _toggleAudio() async {
    if (_isSpeaking) {
      await _tts.stop();
      if (mounted) setState(() => _isSpeaking = false);
      return;
    }

    final text = widget.text.trim();
    if (text.isEmpty) return;
    await _tts.stop();
    await _tts.setLanguage('en-IN');
    await _tts.setSpeechRate(0.43);
    await _tts.speak(text);
    if (mounted) setState(() => _isSpeaking = true);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: _isSpeaking ? 'Stop audio' : 'Read this aloud',
      icon: Icon(
        _isSpeaking ? Icons.stop_circle_outlined : Icons.volume_up_outlined,
        size: widget.size,
      ),
      color: AppColors.secondaryText,
      onPressed: _toggleAudio,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }
}
