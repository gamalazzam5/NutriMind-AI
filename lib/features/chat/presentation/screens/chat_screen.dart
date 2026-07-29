import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input_bar.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ChatCubit>(),
      child: const _ChatView(),
    );
  }
}

class _ChatView extends StatefulWidget {
  const _ChatView();

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: BlocConsumer<ChatCubit, ChatState>(
                listener: (context, state) =>
                    WidgetsBinding.instance.addPostFrameCallback(
                  (_) => _scrollToBottom(),
                ),
                builder: (context, state) => ListView.separated(
                  controller: _scrollController,
                  padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 16.h),
                  itemCount: state.messages.length,
                  separatorBuilder: (_, _) => SizedBox(height: 24.h),
                  itemBuilder: (context, index) =>
                      ChatBubble(message: state.messages[index]),
                ),
              ),
            ),
            ChatInputBar(
              onSend: (text) => context.read<ChatCubit>().sendMessage(text),
              onSendImage: (path, caption) =>
                  context.read<ChatCubit>().sendImage(path, caption: caption),
            ),
          ],
        ),
      ),
    );
  }
}
