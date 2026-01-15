import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'package:fluffychat/utils/platform_infos.dart';

class WindowTitleBar extends StatelessWidget {
  const WindowTitleBar({super.key});

  static const double _barHeight = 36;
  static const double _btnSize = 36;
  static const double _btnGap = 10;

  Future<void> _toggleMaximize() async {
    if (await windowManager.isMaximized()) {
      await windowManager.unmaximize();
    } else {
      await windowManager.maximize();
    }
  }

  Widget _btn({required Widget icon, required VoidCallback onPressed}) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(
        width: _btnSize,
        height: _barHeight,
      ),
      icon: icon,
      onPressed: onPressed,
      visualDensity: VisualDensity.compact,
      splashRadius: 18,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!PlatformInfos.isWindows) return const SizedBox.shrink();

    final cs = Theme.of(context).colorScheme;

    return Container(
      height: _barHeight,
      decoration: BoxDecoration(
        color: cs.surface,
        // ✅ 仅分割线：无阴影
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: cs.outlineVariant.withOpacity(0.2),
          ),
        ),
      ),
      child: DefaultTextStyle.merge(
        style: const TextStyle(
          decoration: TextDecoration.none,
          decorationThickness: 0,
        ),
        child: IconTheme.merge(
          data: IconThemeData(color: cs.onSurface),
          child: Row(
            children: [
              const SizedBox(width: 12),

              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onPanStart: (_) => windowManager.startDragging(),
                  onDoubleTap: _toggleMaximize,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'FluffyChat',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: cs.onSurface,
                        fontSize: 12,
                        fontWeight: FontWeight.w400, // ✅ 不加粗
                        height: 1.0,
                        decoration: TextDecoration.none,
                        decorationThickness: 0,
                      ),
                    ),
                  ),
                ),
              ),

              _btn(
                icon: Transform.translate(
                  offset: const Offset(0, -5),
                  child: const Icon(Icons.minimize, size: 16),
                ),
                onPressed: () => windowManager.minimize(),
              ),
              const SizedBox(width: _btnGap),

              _btn(
                icon: const Icon(Icons.crop_square, size: 16),
                onPressed: _toggleMaximize,
              ),
              const SizedBox(width: _btnGap),

              _btn(
                icon: const Icon(Icons.close, size: 16),
                onPressed: () => windowManager.close(),
              ),

              const SizedBox(width: 12),
            ],
          ),
        ),
      ),
    );
  }
}
