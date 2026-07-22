import 'package:flutter/material.dart';
import 'package:pro_loader/pro_loader.dart';
import 'package:pro_loader/src/enum/pro_loader_type.dart';

/// An [ElevatedButton] that automatically displays
/// a loading animation while an operation is running.
class ProLoadingButton extends StatelessWidget {
  /// Creates a loading button.
  const ProLoadingButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.child,
    this.loaderType = ProLoaderType.buttonLoader,
    this.loaderColor,
    this.loaderSize = 22,
  });

  /// Whether the loader should be displayed.
  final bool isLoading;

  /// Called when the button is pressed.
  final VoidCallback? onPressed;

  /// Button content displayed when not loading.
  final Widget child;

  /// Loader animation used while loading.
  final ProLoaderType loaderType;

  /// Color of the loader.
  final Color? loaderColor;

  /// Size of the loader.
  final double loaderSize;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        child: isLoading
            ? ProLoader(
                key: const ValueKey('loader'),
                type: loaderType,
                color: loaderColor,
                size: loaderSize,
              )
            : KeyedSubtree(key: const ValueKey('child'), child: child),
      ),
    );
  }
}
