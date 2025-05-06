import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LockControl extends StatefulWidget {
  final bool isLocked;
  final Function(bool) onLockStateChanged;

  const LockControl({
    Key? key,
    required this.isLocked,
    required this.onLockStateChanged,
  }) : super(key: key);

  @override
  State<LockControl> createState() => _LockControlState();
}

class _LockControlState extends State<LockControl> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    if (!widget.isLocked) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleLock() {
    setState(() {
      if (widget.isLocked) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
      widget.onLockStateChanged(!widget.isLocked);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.isLocked ? l10n.locked : l10n.unlocked,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _toggleLock,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.lerp(
                        Colors.red[100],
                        Colors.green[100],
                        _animation.value,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        widget.isLocked ? Icons.lock : Icons.lock_open,
                        size: 48,
                        color: Color.lerp(
                          Colors.red,
                          Colors.green,
                          _animation.value,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _toggleLock,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.isLocked ? Colors.green : Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                widget.isLocked ? l10n.unlock : l10n.lock,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 