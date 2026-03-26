import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_spacing.dart';

// Mock ses oynatıcı — audioUrl null olunca 3 sn sonra tamamlanmış davranır
class AudioPlayerWidget extends StatefulWidget {
  const AudioPlayerWidget({super.key, this.audioUrl, this.label = 'Dinle'});

  final String? audioUrl;
  final String label;

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  bool _isPlaying = false;
  Timer? _timer;

  void _togglePlay() {
    if (_isPlaying) {
      _timer?.cancel();
      setState(() => _isPlaying = false);
      return;
    }
    setState(() => _isPlaying = true);
    // Mock: 3 saniye sonra dur
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Play/Pause butonu
        GestureDetector(
          onTap: _togglePlay,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm + 2,
            ),
            decoration: BoxDecoration(
              color: _isPlaying ? AppColors.primary : AppColors.primaryBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  color: _isPlaying ? AppColors.white : AppColors.primary,
                  size: 22,
                ),
                const SizedBox(width: 6),
                Text(
                  _isPlaying ? 'Oynatılıyor...' : widget.label,
                  style: AppTextStyles.labelLarge.copyWith(
                    color:
                        _isPlaying ? AppColors.white : AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: AppSpacing.sm),

        // Animasyonlu dalga çubukları (sadece oynarken)
        if (_isPlaying)
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(
              5,
              (i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: _WaveBar(delay: i * 80),
              ),
            ),
          ),
      ],
    );
  }
}

class _WaveBar extends StatelessWidget {
  const _WaveBar({required this.delay});

  final int delay;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3,
      height: 16,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(2),
      ),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .scaleY(
          delay: Duration(milliseconds: delay),
          duration: 400.ms,
          begin: 0.3,
          end: 1.0,
          curve: Curves.easeInOut,
        );
  }
}
