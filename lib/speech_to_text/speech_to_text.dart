import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechToTextFlutter extends StatefulWidget {
  const SpeechToTextFlutter({super.key});

  @override
  State<SpeechToTextFlutter> createState() => _SpeechToTextFlutterState();
}

class _SpeechToTextFlutterState extends State<SpeechToTextFlutter> {
  stt.SpeechToText? _speech;
  bool _isListening = false;
  String _text = "press the button and start speaking";
  double _confidence = 1.0;
  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Confidence:${(_confidence * 100.0).toStringAsFixed(1)}%"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        endRadius: 100.0,
        glowColor: Colors.red,
        duration: const Duration(seconds: 5),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        animate: _isListening,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: const EdgeInsets.fromLTRB(30, 30, 30, 50),
        child: SelectableText(
          _text,
          style: const TextStyle(
              fontSize: 32, color: Colors.black, fontWeight: FontWeight.w400),
        ),
      )),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech!.initialize(
          onStatus: (status) => print("onStatus: $status"),
          onError: (val) => print("onError: $val"),
          finalTimeout: const Duration(seconds: 5));
      if (available) {
        setState(() => _isListening = true);
        _speech!.listen(onResult: (val) {
          setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          });
        });
      }
    } else {
      setState(() {
        _isListening = false;
      });
      _speech!.stop();
    }
  }
}
