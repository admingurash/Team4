import 'package:flutter/material.dart';

class FaceRecognitionScreen extends StatefulWidget {
  final Function(String location) onLocationDetected;

  const FaceRecognitionScreen({
    Key? key,
    required this.onLocationDetected,
  }) : super(key: key);

  @override
  State<FaceRecognitionScreen> createState() => _FaceRecognitionScreenState();
}

class _FaceRecognitionScreenState extends State<FaceRecognitionScreen>
    with SingleTickerProviderStateMixin {
  bool _isFaceDetected = false;
  bool _isProcessing = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    // Simulate face detection after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isFaceDetected = true;
        });
        // Simulate processing
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() {
              _isProcessing = true;
            });
            // Simulate location detection
            Future.delayed(const Duration(seconds: 2), () {
              widget.onLocationDetected('Main Entrance');
              Navigator.pop(context);
            });
          }
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
          // Face detection overlay
          Center(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.6 + 0.4 * _animationController.value),
                      width: 2,
                    ),
                  ),
                  child: Stack(
                    children: [
                      if (_isFaceDetected)
                        Center(
                          child: Icon(
                            Icons.face,
                            size: 120,
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.7),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Status overlay
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
                    _getStatusText(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getInstructionText(),
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                  if (_isProcessing) ...[
                    const SizedBox(height: 16),
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ],
                ],
              ),
            ),
          ),
          // Guide lines
          CustomPaint(
            size: Size.infinite,
            painter: FaceGuidePainter(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText() {
    if (_isProcessing) {
      return 'Verifying identity...';
    }
    if (_isFaceDetected) {
      return 'Face detected!';
    }
    return 'Position your face in the circle';
  }

  String _getInstructionText() {
    if (_isProcessing) {
      return 'Please wait while we verify your identity';
    }
    if (_isFaceDetected) {
      return 'Processing your image';
    }
    return 'Make sure your face is well-lit and centered';
  }
}

class FaceGuidePainter extends CustomPainter {
  final Color color;

  FaceGuidePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw guide lines
    const spacing = 30.0;
    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        paint,
      );
    }
    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(FaceGuidePainter oldDelegate) => false;
}
