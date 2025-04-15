import 'package:flutter/material.dart';

class CardScanScreen extends StatefulWidget {
  final Function(String location) onLocationDetected;

  const CardScanScreen({
    Key? key,
    required this.onLocationDetected,
  }) : super(key: key);

  @override
  State<CardScanScreen> createState() => _CardScanScreenState();
}

class _CardScanScreenState extends State<CardScanScreen>
    with SingleTickerProviderStateMixin {
  bool _isScanning = false;
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

    // Simulate card detection after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isScanning = true;
        });
        // Simulate location detection
        Future.delayed(const Duration(seconds: 1), () {
          widget.onLocationDetected('Main Entrance');
          Navigator.pop(context);
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          // Camera preview placeholder
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black87,
          ),
          // Scanning overlay
          Center(
            child: Container(
              width: 300,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: AnimatedBuilder(
                animation: _scanAnimation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: ScannerPainter(
                      progress: _scanAnimation.value,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  );
                },
              ),
            ),
          ),
          // Instructions and status
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _isScanning
                        ? 'Card detected!'
                        : 'Place your card in the frame',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isScanning
                        ? 'Detecting location...'
                        : 'Make sure the card is clearly visible',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                  if (_isScanning) ...[
                    const SizedBox(height: 16),
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ],
                ],
              ),
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

  ScannerPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final scanLineY = size.height * progress;
    canvas.drawLine(
      Offset(0, scanLineY),
      Offset(size.width, scanLineY),
      paint,
    );
  }

  @override
  bool shouldRepaint(ScannerPainter oldDelegate) =>
      progress != oldDelegate.progress;
}
