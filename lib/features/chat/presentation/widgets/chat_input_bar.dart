import 'dart:io';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_snackbar.dart';

const _suggestedQuestionKeys = [
  'chat_suggestion_meal_plan',
  'chat_suggestion_snacks',
  'chat_suggestion_log_breakfast',
];

/// Fixed input bar above the bottom nav bar: suggested question chips,
/// text field with voice dictation, image attach, and send button.
typedef SendImageCallback = void Function(String imagePath, String? caption);

class ChatInputBar extends StatefulWidget {
  const ChatInputBar({super.key, required this.onSend, required this.onSendImage});

  final ValueChanged<String> onSend;
  final SendImageCallback onSendImage;

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

    final caption = await showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CaptionSheet(imagePath: file.path),
    );
    if (!mounted) return;
    widget.onSendImage(file.path, caption);
  }

  Future<void> _toggleListening(bool isArabic) async {
    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
      return;
    }

    final available = await _speech.initialize();
    if (!mounted) return;
    if (!available) {
      AppSnackBar.error(context, 'chat_mic_permission_denied'.tr());
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
        localeId: isArabic ? 'ar_SA' : 'en_US',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
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
                final label = _suggestedQuestionKeys[index].tr();
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
                          isArabic: isArabic,
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
                    style: AppTextStyles.bodyLarge(isArabic: isArabic),
                    textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                    onSubmitted: (_) => _submit(),
                    decoration: InputDecoration(
                      hintText: _isListening
                          ? 'chat_listening'.tr()
                          : 'chat_input_hint'.tr(),
                      hintStyle: AppTextStyles.bodyLarge(
                        color: AppColors.textSecondary,
                        isArabic: isArabic,
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
                    onTap: () => _toggleListening(isArabic),
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

/// Bottom sheet prompting for an optional caption before sending a picked
/// image. Owns its own [TextEditingController] lifecycle so it's never
/// disposed while the sheet's dismiss animation or IME teardown still holds
/// a reference to it.
class _CaptionSheet extends StatefulWidget {
  const _CaptionSheet({required this.imagePath});

  final String imagePath;

  @override
  State<_CaptionSheet> createState() => _CaptionSheetState();
}

class _CaptionSheetState extends State<_CaptionSheet> {
  final _captionController = TextEditingController();

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 24.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppRadius.xl),
            topRight: Radius.circular(AppRadius.xl),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  child: Image.file(
                    File(widget.imagePath),
                    width: 56.r,
                    height: 56.r,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    'chat_add_caption_title'.tr(),
                    style: AppTextStyles.bodyMedium(isArabic: isArabic)
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _captionController,
              autofocus: true,
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              style: AppTextStyles.bodyLarge(isArabic: isArabic),
              decoration: InputDecoration(
                hintText: 'chat_add_caption_hint'.tr(),
                hintStyle: AppTextStyles.bodyLarge(
                  color: AppColors.textSecondary,
                  isArabic: isArabic,
                ),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              ),
              onSubmitted: (value) => Navigator.of(context).pop(value),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(null),
                    child: Text('chat_skip_caption'.tr()),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      onTap: () => Navigator.of(context).pop(_captionController.text),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        decoration: BoxDecoration(
                          gradient: AppColors.ctaGradient,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Center(
                          child: Text(
                            'chat_send_with_caption'.tr(),
                            style: AppTextStyles.button(isArabic: isArabic),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
