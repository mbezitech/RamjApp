import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/products/product_list_screen.dart';
import 'utils/constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RamjApp());
}

class RamjApp extends StatelessWidget {
  const RamjApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
        ),
        home: const AppInitializer(),
      ),
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _progressAnimation = Tween<double>(
      begin: -0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<AuthProvider>().init(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildSplashScreen();
        }

        final authProvider = context.read<AuthProvider>();
        if (authProvider.isAuthenticated) {
          return const ProductListScreen();
        }
        return const LoginScreen();
      },
    );
  }

  Widget _buildSplashScreen() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          _buildBackground(),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: _buildContent(),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        CustomPaint(
          painter: _GridPatternPainter(
            color: AppColors.primary.withOpacity(0.03),
          ),
          size: Size.infinite,
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Colors.transparent,
                    AppColors.background.withOpacity(0.85),
                  ],
                  radius: 0.8,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildLogo(),
        const SizedBox(height: 40),
        _buildTitle(),
        const SizedBox(height: 8),
        Text(
          'HIGH-PRECISION MEDICAL PROCUREMENT',
          style: AppTypography.labelBold.copyWith(
            fontSize: 11,
            color: AppColors.secondary,
            letterSpacing: 2.5,
          ),
        ),
        const SizedBox(height: 24),
        _buildSocialProof(),
      ],
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.15),
            blurRadius: 40,
            spreadRadius: -8,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: AppColors.outlineVariant.withOpacity(0.3),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          'assets/medfoot_app_icon.png',
          width: 96,
          height: 96,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return RichText(
      text: TextSpan(
        style: AppTypography.h1,
        children: [
          TextSpan(
            text: 'Med',
            style: TextStyle(color: AppColors.onSurface),
          ),
          TextSpan(
            text: 'Foot',
            style: TextStyle(color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialProof() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 64,
            height: 32,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  child: _buildAvatar(Icons.person, AppColors.surfaceVariant),
                ),
                Positioned(
                  left: 16,
                  child: _buildAvatar(Icons.medical_services, AppColors.surfaceVariant),
                ),
                Positioned(
                  left: 32,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '+',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text.rich(
            TextSpan(
              style: AppTypography.bodySm,
              children: [
                const TextSpan(text: 'Trusted by '),
                TextSpan(
                  text: '10,000+',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(text: ' Clinics'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(IconData icon, Color color) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Icon(icon, size: 16, color: AppColors.primary.withOpacity(0.5)),
    );
  }

  Widget _buildBottomSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 64),
          child: _buildProgressBar(),
        ),
        _buildFooter(),
      ],
    );
  }

  Widget _buildProgressBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        width: 128,
        height: 4,
        child: Stack(
          children: [
            Container(
              width: 128,
              height: 4,
              color: AppColors.surfaceContainer,
            ),
            AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_progressAnimation.value * 128, 0),
                  child: Container(
                    width: 48,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        border: Border(
          top: BorderSide(
            color: AppColors.outlineVariant.withOpacity(0.3),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'SECURE ENTERPRISE LOGIN',
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.05,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.arrow_forward,
            color: AppColors.primary,
            size: 18,
          ),
        ],
      ),
    );
  }
}

class _GridPatternPainter extends CustomPainter {
  final Color color;

  _GridPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    const spacing = 40.0;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPatternPainter oldDelegate) => false;
}
