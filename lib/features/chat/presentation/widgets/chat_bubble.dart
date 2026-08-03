import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/chat_message_entity.dart';


class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message, this.avatarAsset});

  final ChatMessageEntity message;
  final String? avatarAsset;

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final avatar = _Avatar(isUser: isUser, imageAsset: avatarAsset);
    final bubble = _Bubble(message: message);

    return Row(
      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: isUser
          ? [Flexible(child: bubble), SizedBox(width: 16.w), avatar]
          : [avatar, SizedBox(width: 16.w), Flexible(child: bubble)],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.isUser, this.imageAsset});

  final bool isUser;
  final String? imageAsset;

  @override
  Widget build(BuildContext context) {
    if (isUser) {
      return CircleAvatar(
        radius: 20.r,
        backgroundColor: AppColors.background,
        backgroundImage: imageAsset == null ? null : AssetImage(imageAsset!),
        child: imageAsset == null
            ? Icon(Icons.person_rounded, size: 20.sp, color: AppColors.textSecondary)
            : null,
      );
    }
    return Container(
      width: 40.r,
      height: 40.r,
      decoration: const BoxDecoration(
        color: AppColors.lavender,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.smart_toy_rounded, size: 20.sp, color: Colors.white),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message});

  final ChatMessageEntity message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final isArabic = context.locale.languageCode == 'ar';
    final hasImage = message.imagePath != null;
    return Container(
      constraints: BoxConstraints(maxWidth: 331.5.w),
      padding: hasImage ? EdgeInsets.all(6.r) : EdgeInsets.all(17.r),
      decoration: BoxDecoration(
        gradient: isUser && !hasImage ? AppColors.ctaGradient : null,
        color: isUser && !hasImage ? null : Colors.white,
        border: isUser
            ? null
            : Border.all(color: AppColors.lavender.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isUser ? AppRadius.md : 0),
          topRight: Radius.circular(isUser ? 0 : AppRadius.md),
          bottomLeft: Radius.circular(AppRadius.md),
          bottomRight: Radius.circular(AppRadius.md),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryStart.withValues(alpha: isUser ? 0.12 : 0.08),
            blurRadius: 8.r,
            offset: Offset(0, isUser ? 8.h : 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasImage)
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: Image.file(
                File(message.imagePath!),
                width: 220.w,
                height: 220.w,
                fit: BoxFit.cover,
              ),
            ),
          if (message.text.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: hasImage ? 8.h : 0),
              child: _RichBoldText(
                text: message.text,
                baseStyle: AppTextStyles.bodyLarge(
                  color: isUser && !hasImage ? Colors.white : AppColors.textPrimary,
                  isArabic: isArabic,
                ),
              ),
            ),
          if (message.note != null) ...[
            SizedBox(height: 12.h),
            Text(
              message.note!,
              style: AppTextStyles.bodyMedium(
                color: AppColors.textSecondary,
                isArabic: isArabic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RichBoldText extends StatelessWidget {
  const _RichBoldText({required this.text, required this.baseStyle});

  final String text;
  final TextStyle baseStyle;

  @override
  Widget build(BuildContext context) {
    final parts = text.split('**');
    return Text.rich(
      TextSpan(
        children: [
          for (var i = 0; i < parts.length; i++)
            TextSpan(
              text: parts[i],
              style: i.isOdd
                  ? baseStyle.copyWith(fontWeight: FontWeight.w700)
                  : baseStyle,
            ),
        ],
      ),
    );
  }
}
