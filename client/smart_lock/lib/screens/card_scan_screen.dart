import 'package:flutter/material.dart';

class CardScanScreen extends StatefulWidget {
  const CardScanScreen({super.key});

  @override
  State<CardScanScreen> createState() => _CardScanScreenState();
}

class _CardScanScreenState extends State<CardScanScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scanAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scanAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _simulateCardScan() async {
    // Show scanning indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Simulate scanning delay
    await Future.delayed(const Duration(seconds: 2));

    // Hide scanning indicator
    Navigator.pop(context);

    // Show success dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Access Granted'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 64,
            ),
            SizedBox(height: 16),
            Text('Door will open in 5 seconds'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final scanAreaSize = size.width * 0.8;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Camera preview placeholder (black background)
          Container(
            color: Colors.black,
          ),

          // Scanning overlay
          Center(
            child: Container(
              width: scanAreaSize,
              height: scanAreaSize * 0.63, // Credit card aspect ratio
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.colorScheme.primary,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: AnimatedBuilder(
                animation: _scanAnimation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: ScannerPainter(
                      progress: _scanAnimation.value,
                      color: theme.colorScheme.primary,
                    ),
                  );
                },
              ),
            ),
          ),

          // Instructions
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  'Place your card within the frame',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _simulateCardScan,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Simulate Card Scan'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ScannerPainter extends CustomPainter {
  final double progress;
  final Color color;

  ScannerPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final scanLineY = size.height * progress;
    canvas.drawRect(
      Rect.fromLTWH(0, scanLineY - 2, size.width, 4),
      paint,
    );

    // Draw corner indicators
    final cornerPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    const cornerLength = 20.0;

    // Top-left corner
    canvas.drawLine(
      const Offset(0, 0),
      const Offset(cornerLength, 0),
      cornerPaint,
    );
    canvas.drawLine(
      const Offset(0, 0),
      const Offset(0, cornerLength),
      cornerPaint,
    );

    // Top-right corner
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width - cornerLength, 0),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width, cornerLength),
      cornerPaint,
    );

    // Bottom-left corner
    canvas.drawLine(
      Offset(0, size.height),
      Offset(cornerLength, size.height),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(0, size.height),
      Offset(0, size.height - cornerLength),
      cornerPaint,
    );

    // Bottom-right corner
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width - cornerLength, size.height),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width, size.height - cornerLength),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(ScannerPainter oldDelegate) =>
      progress != oldDelegate.progress;
}
