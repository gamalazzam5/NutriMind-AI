import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';

const _suggestedQuestionKeys = [
  'chat_suggestion_meal_plan',
  'chat_suggestion_snacks',
  'chat_suggestion_log_breakfast',
];

/// Fixed input bar above the bottom nav bar: suggested question chips,
/// text field with voice dictation, image attach, and send button.
class ChatInputBar extends StatefulWidget {
  const ChatInputBar({super.key, required this.onSend, required this.onSendImage});

  final ValueChanged<String> onSend;
  final ValueChanged<String> onSendImage;

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final _controller = TextEditingController();
  final _speech = SpeechToText();
  bool _isListening = false;

  @override
  void dispose() {
    _controller.dispose();
    if (_isListening) _speech.stop();
    super.dispose();
  }

  void _submit([String? suggestion]) {
    final text = suggestion ?? _controller.text;
    if (text.trim().isEmpty) return;
    widget.onSend(text);
    _controller.clear();
  }

  Future<void> _pickAndSendImage() async {
    final file = await getIt<ImagePicker>().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (file == null || !mounted) return;
    widget.onSendImage(file.path);
  }

  Future<void> _toggleListening(AppLocalizations l10n) async {
    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
      return;
    }

    final available = await _speech.initialize();
    if (!mounted) return;
    if (!available) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.t('chat_mic_permission_denied'))),
      );
      return;
    }

    setState(() => _isListening = true);
    await _speech.listen(
      onResult: (result) {
        if (!mounted) return;
        setState(() => _controller.text = result.recognizedWords);
        _controller.selection = TextSelection.collapsed(offset: _controller.text.length);
        if (result.finalResult) setState(() => _isListening = false);
      },
      listenOptions: SpeechListenOptions(
        localeId: l10n.isArabic ? 'ar_SA' : 'en_US',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 16.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            AppColors.background,
            AppColors.background.withValues(alpha: 0),
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 38.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _suggestedQuestionKeys.length,
              separatorBuilder: (_, _) => SizedBox(width: 8.w),
              itemBuilder: (context, index) {
                final label = l10n.t(_suggestedQuestionKeys[index]);
                return Material(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    side: const BorderSide(color: Color(0xFFBBCBBB)),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    onTap: () => _submit(label),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 9.h),
                      child: Text(
                        label,
                        style: AppTextStyles.bodySmall(
                          color: AppColors.textPrimary,
                          isArabic: l10n.isArabic,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            height: 64.h,
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryStart.withValues(alpha: 0.12),
                  blurRadius: 8.r,
                  offset: Offset(0, 8.h),
                ),
              ],
            ),
            child: Row(
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: _pickAndSendImage,
                    child: Padding(
                      padding: EdgeInsets.all(8.r),
                      child: Icon(
                        Icons.attach_file_rounded,
                        size: 20.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: AppTextStyles.bodyLarge(isArabic: l10n.isArabic),
                    textDirection: l10n.isArabic ? TextDirection.rtl : TextDirection.ltr,
                    onSubmitted: (_) => _submit(),
                    decoration: InputDecoration(
                      hintText: _isListening
                          ? l10n.t('chat_listening')
                          : l10n.t('chat_input_hint'),
                      hintStyle: AppTextStyles.bodyLarge(
                        color: AppColors.textSecondary,
                        isArabic: l10n.isArabic,
                      ),
                      border: InputBorder.none,
                      isCollapsed: true,
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => _toggleListening(l10n),
                    child: Padding(
                      padding: EdgeInsets.all(8.r),
                      child: Icon(
                        _isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
                        size: 20.sp,
                        color: _isListening ? AppColors.primaryStart : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => _submit(),
                    child: Container(
                      width: 40.r,
                      height: 40.r,
                      decoration: BoxDecoration(
                        gradient: AppColors.ctaGradient,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.send_rounded,
                        size: 18.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
