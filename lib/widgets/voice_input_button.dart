import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/voice_service.dart';
import '../providers/app_state.dart';
import '../config/theme.dart';

class VoiceInputButton extends StatefulWidget {
  final Function(String) onTextRecognized;
  final Color? color;
  final double size;

  const VoiceInputButton({
    super.key,
    required this.onTextRecognized,
    this.color,
    this.size = 24.0,
  });

  @override
  State<VoiceInputButton> createState() => _VoiceInputButtonState();
}

class _VoiceInputButtonState extends State<VoiceInputButton> {
  @override
  void initState() {
    super.initState();
    VoiceService.instance.addListener(_onVoiceStateChanged);
  }

  @override
  void dispose() {
    VoiceService.instance.removeListener(_onVoiceStateChanged);
    super.dispose();
  }

  void _onVoiceStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _toggleListening() async {
    final voiceService = VoiceService.instance;
    final appState = context.read<AppState>();

    if (voiceService.isListening) {
      await voiceService.stopListening();
    } else {
      // Request permission
      var status = await Permission.microphone.status;
      if (!status.isGranted) {
        status = await Permission.microphone.request();
      }

      if (status.isGranted) {
        await voiceService.startListening(
          localeId: appState.currentLanguage,
          onResult: (text) {
            widget.onTextRecognized(text);
          },
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Microphone permission is required for voice input.'),
              backgroundColor: AppTheme.errorRed,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isListening = VoiceService.instance.isListening;
    final iconColor = widget.color ?? AppTheme.primaryGreen;

    Widget button = IconButton(
      icon: Icon(
        isListening ? Icons.mic : Icons.mic_none,
        color: isListening ? AppTheme.errorRed : iconColor,
        size: widget.size,
      ),
      onPressed: _toggleListening,
      tooltip: isListening ? 'Stop Listening' : 'Voice Input',
    );

    if (isListening) {
      return Pulse(
        infinite: true,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.errorRed.withValues(alpha: 0.1),
          ),
          child: button,
        ),
      );
    }

    return button;
  }
}
