import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// A reusable text field that adapts its height based on keyboard visibility
/// - Larger height when keyboard is not visible
/// - Reduced height when keyboard appears
/// - Shows purple border on focus
class AdaptiveTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLength;
  final int minLines;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSubmitted;
  final double defaultHeight;
  final double keyboardHeight;

  const AdaptiveTextField({
    super.key,
    required this.controller,
    this.hintText = '/ Describe your perfect hotspot',
    this.maxLength = 250,
    this.minLines = 5,
    this.maxLines = 10,
    this.onChanged,
    this.onSubmitted,
    this.defaultHeight = 180,
    this.keyboardHeight = 120,
  });

  @override
  State<AdaptiveTextField> createState() => _AdaptiveTextFieldState();
}

class _AdaptiveTextFieldState extends State<AdaptiveTextField> 
    with WidgetsBindingObserver {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didChangeMetrics() {
    // Force rebuild when keyboard appears/disappears
    if (mounted) {
      // Use multiple delays to catch keyboard animation
      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted) setState(() {});
      });
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) setState(() {});
      });
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) setState(() {});
      });
    }
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
      // Force rebuilds to catch keyboard state changes
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) setState(() {});
      });
      Future.delayed(const Duration(milliseconds: 250), () {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Wrap in MediaQuery to ensure we get fresh data
    // This helps when parent doesn't rebuild on MediaQuery changes
    return MediaQuery(
      data: MediaQuery.of(context),
      child: Builder(
        builder: (context) {
          // Read MediaQuery directly - this ensures we get the current state
          final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
          final isKeyboardVisible = keyboardHeight > 0;
          
          // Calculate height: larger when keyboard is hidden, smaller when visible
          final height = isKeyboardVisible 
              ? widget.keyboardHeight 
              : widget.defaultHeight;

          return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite2,
        borderRadius: BorderRadius.circular(12),
        border: _isFocused
            ? Border.all(
                color: AppColors.primaryAccent,
                width: 1,
              )
            : null,
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        maxLength: widget.maxLength,
        textInputAction: TextInputAction.done,
        cursorColor: AppColors.text1,
        style: const TextStyle(
          color: AppColors.text1,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: AppColors.text3,
            fontSize: 16,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          counterText: '',
        ),
        onChanged: widget.onChanged,
        onSubmitted: (_) {
          widget.onSubmitted?.call();
          // Dismiss keyboard when done is pressed
          FocusScope.of(context).unfocus();
        },
      ),
    );
        },
      ),
    );
  }
}

