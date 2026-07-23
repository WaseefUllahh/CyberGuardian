import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/routing/app_routes.dart';
import '../models/onboarding_page_model.dart';
import '../services/onboarding_service.dart';
import '../widgets/burst_painter.dart';
import '../widgets/cyber_particles_painter.dart';
import '../widgets/onboarding_dot_indicators.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Brand colours (duplicated locally so this screen is self-contained)
// ─────────────────────────────────────────────────────────────────────────────
const _kGreenDark = Color(0xFF2E7D32);
const _kGreenBright = Color(0xFF4CAF50);

// Dark-mode background gradient stops
const _kBgDarkTop = Color(0xFF0A1A0F);
const _kBgDarkBottom = Color(0xFF121212);

// ─────────────────────────────────────────────────────────────────────────────
// Slide content
// ─────────────────────────────────────────────────────────────────────────────
final List<OnboardingPageModel> _kPages = [
  OnboardingPageModel(
    title: 'Welcome to CyberGuardian',
    description:
        'Your all-in-one cybersecurity companion — protecting you from digital threats, keeping you informed, and helping you stay secure online.',
    icon: PhosphorIcons.shieldCheck(),
  ),
  OnboardingPageModel(
    title: 'Scan for Threats',
    description:
        'Instantly scan URLs, emails, SMS messages, and files to detect malware, phishing attempts, and suspicious content before they harm you.',
    icon: PhosphorIcons.magnifyingGlass(),
  ),
  OnboardingPageModel(
    title: 'Stay Informed',
    description:
        'Read the latest cybersecurity news, threat alerts, and data-breach reports curated in real time so you are always one step ahead.',
    icon: PhosphorIcons.newspaper(),
  ),
  OnboardingPageModel(
    title: 'Learn & Grow',
    description:
        'Access interactive cybersecurity lessons, quizzes, and tips that turn complex security concepts into easy, actionable knowledge.',
    icon: PhosphorIcons.graduationCap(),
  ),
  OnboardingPageModel(
    title: 'Report Incidents',
    description:
        'Spotted something suspicious? Report cyber incidents quickly, track your submissions, and contribute to a safer digital community.',
    icon: PhosphorIcons.flag(),
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// OnboardingScreen
// ─────────────────────────────────────────────────────────────────────────────

/// Full-screen first-launch tutorial with:
///   • Animated floating cyber-particle field
///   • Per-slide neon glow rings + floating icon
///   • Glassmorphism bottom card
///   • Word-by-word title reveal
///   • Animated pill dot indicators
///   • Auto swipe-hint after 3 s of inactivity on slide 1
///   • Particle-burst "Get Started" CTA
///   • Cinematic fade-to-black on Skip
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  // ── Animation controllers ──────────────────────────────────────────────────
  late final AnimationController _particleCtrl; // infinite – particle drift
  late final AnimationController _pulseCtrl;    // infinite – glow rings
  late final AnimationController _floatCtrl;    // infinite – icon float
  late final AnimationController _contentCtrl;  // one-shot – page entrance
  late final AnimationController _hintCtrl;     // repeating – swipe hint arrow
  late final AnimationController _burstCtrl;    // one-shot – Get Started burst
  late final AnimationController _skipFadeCtrl; // one-shot – Skip fade to black

  // ── Page state ─────────────────────────────────────────────────────────────
  late final PageController _pageCtrl;
  int _currentPage = 0;
  double _pageProgress = 0.0; // fractional page pos for parallax & dot anim

  // ── Interaction flags ──────────────────────────────────────────────────────
  bool _hasInteracted = false;
  bool _showBurst = false;
  Timer? _hintTimer;

  // ── Particles (generated once with fixed seed) ─────────────────────────────
  late final List<CyberParticle> _particles;

  // ── Cached derived animations (avoid rebuilding on every tick) ─────────────
  late Animation<double> _iconScaleAnim;
  late Animation<Offset> _cardSlideAnim;
  late Animation<double> _cardFadeAnim;
  late Animation<double> _descFadeAnim;

  @override
  void initState() {
    super.initState();
    _particles = generateCyberParticles(42);
    _initControllers();
    _cacheAnimations();
    _startHintTimer();
  }

  // ── Initialisation ─────────────────────────────────────────────────────────

  void _initControllers() {
    _particleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);

    _contentCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..forward();

    _hintCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _burstCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _skipFadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );

    _pageCtrl = PageController()
      ..addListener(() {
        final page = _pageCtrl.page ?? 0.0;
        if (mounted) setState(() => _pageProgress = page);
      });
  }

  void _cacheAnimations() {
    _iconScaleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentCtrl,
        curve: const Interval(0.0, 0.55, curve: Curves.elasticOut),
      ),
    );
    _cardSlideAnim = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _contentCtrl,
        curve: const Interval(0.15, 0.75, curve: Curves.easeOutCubic),
      ),
    );
    _cardFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentCtrl,
        curve: const Interval(0.15, 0.65),
      ),
    );
    _descFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentCtrl,
        curve: const Interval(0.65, 1.0),
      ),
    );
  }

  // ── Timer / interaction ────────────────────────────────────────────────────

  void _startHintTimer() {
    _hintTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && !_hasInteracted && _currentPage == 0) {
        _hintCtrl.repeat(reverse: true);
      }
    });
  }

  void _markInteracted() {
    if (!_hasInteracted) {
      _hasInteracted = true;
      _hintTimer?.cancel();
      if (_hintCtrl.isAnimating) {
        _hintCtrl.stop();
        _hintCtrl.reset();
      }
    }
  }

  // ── Navigation actions ─────────────────────────────────────────────────────

  Future<void> _nextPage() async {
    HapticFeedback.lightImpact();
    _markInteracted();
    if (_currentPage < _kPages.length - 1) {
      _contentCtrl.reset();
      await _pageCtrl.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 520),
        curve: Curves.easeInOutCubic,
      );
      if (mounted) _contentCtrl.forward();
    }
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
    _markInteracted();
    _contentCtrl
      ..reset()
      ..forward();
  }

  Future<void> _skipOnboarding() async {
    HapticFeedback.lightImpact();
    _markInteracted();
    await _skipFadeCtrl.forward();
    await OnboardingService().markOnboardingSeen();
    if (mounted) Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  Future<void> _getStarted() async {
    HapticFeedback.mediumImpact();
    _markInteracted();
    if (mounted) setState(() => _showBurst = true);
    await _burstCtrl.forward();
    await OnboardingService().markOnboardingSeen();
    if (mounted) Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  // ── Theme helpers ──────────────────────────────────────────────────────────

  Color _accent(bool isDark) => isDark ? _kGreenBright : _kGreenDark;
  Color _cardBg(bool isDark) =>
      isDark ? const Color(0xFF1E3A2F).withValues(alpha: 0.88) : Colors.white.withValues(alpha: 0.88);
  Color _titleColor(bool isDark) => isDark ? Colors.white : const Color(0xFF1A1A1A);
  Color _descColor(bool isDark) => isDark ? const Color(0xFFAAAAAA) : const Color(0xFF757575);

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _particleCtrl,
          _pulseCtrl,
          _floatCtrl,
          _contentCtrl,
          _hintCtrl,
          _burstCtrl,
          _skipFadeCtrl,
        ]),
        builder: (context, _) {
          return Stack(
            children: [
              // ── 1. Background gradient ──────────────────────────────────────
              _buildBackground(isDark),

              // ── 2. Floating cyber-particle field ───────────────────────────
              Positioned.fill(
                child: CustomPaint(
                  painter: CyberParticlesPainter(
                    animationValue: _particleCtrl.value,
                    pageProgress: _pageProgress,
                    particles: _particles,
                    color: _accent(isDark),
                  ),
                ),
              ),

              // ── 3. Icon page view ───────────────────────────────────────────
              _buildIconPageView(isDark),

              // ── 4. Glassmorphism card (static, content changes per page) ───
              Align(
                alignment: Alignment.bottomCenter,
                child: _buildGlassCard(isDark),
              ),

              // ── 5. Skip button ──────────────────────────────────────────────
              if (_currentPage < _kPages.length - 1) _buildSkipButton(isDark),

              // ── 6. Get Started burst overlay ────────────────────────────────
              if (_showBurst)
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: BurstPainter(
                        progress: _burstCtrl.value,
                        color: _accent(isDark),
                      ),
                    ),
                  ),
                ),

              // ── 7. Skip cinematic fade-to-black overlay ─────────────────────
              if (_skipFadeCtrl.value > 0)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: _skipFadeCtrl.value,
                      child: const ColoredBox(color: Colors.black),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  // ── Background ─────────────────────────────────────────────────────────────

  Widget _buildBackground(bool isDark) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [_kBgDarkTop, _kBgDarkBottom]
                : [const Color(0xFFF5F7FA), const Color(0xFFE8F5E9)],
          ),
        ),
      ),
    );
  }

  // ── Icon PageView ──────────────────────────────────────────────────────────

  Widget _buildIconPageView(bool isDark) {
    return Positioned.fill(
      bottom: _cardHeight(context),
      child: PageView.builder(
        controller: _pageCtrl,
        onPageChanged: _onPageChanged,
        itemCount: _kPages.length,
        itemBuilder: (_, i) => _buildIconSlide(_kPages[i], isDark),
      ),
    );
  }

  Widget _buildIconSlide(OnboardingPageModel page, bool isDark) {
    // Smooth sinusoidal float: -10 to +10 px
    final floatY = sin(_floatCtrl.value * pi) * 10.0;
    final accent = _accent(isDark);

    return Stack(
      alignment: Alignment.center,
      children: [
        // ── Neon glow rings (3 staggered pulses) ───────────────────────────
        ..._buildPulseRings(accent),

        // ── Central icon ───────────────────────────────────────────────────
        ScaleTransition(
          scale: _iconScaleAnim,
          child: Transform.translate(
            offset: Offset(0, floatY),
            child: Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accent.withValues(alpha: 0.12),
                border: Border.all(
                  color: accent.withValues(alpha: 0.45),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.3),
                    blurRadius: 32,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Icon(page.icon, size: 64, color: accent),
            ),
          ),
        ),

        // ── Swipe hint arrow (slide 1 only, after 3 s idle) ────────────────
        if (_currentPage == 0 && !_hasInteracted)
          Positioned(
            bottom: 28,
            child: _buildSwipeHint(accent),
          ),
      ],
    );
  }

  List<Widget> _buildPulseRings(Color accent) {
    return List.generate(3, (i) {
      final phase = i / 3.0;
      final progress = (_pulseCtrl.value + phase) % 1.0;
      final scale = 0.75 + progress * 0.9;           // 0.75 → 1.65
      final opacity = (1.0 - progress) * 0.32;

      return Transform.scale(
        scale: scale,
        child: Container(
          width: 168,
          height: 168,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: accent.withValues(alpha: opacity),
              width: 1.5,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildSwipeHint(Color accent) {
    final opacity = 0.35 + _hintCtrl.value * 0.65;
    final shift = _hintCtrl.value * 10.0;
    return Opacity(
      opacity: opacity,
      child: Transform.translate(
        offset: Offset(shift, 0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Swipe',
              style: TextStyle(color: accent, fontSize: 13, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 4),
            Icon(Icons.arrow_forward_rounded, size: 16, color: accent),
          ],
        ),
      ),
    );
  }

  // ── Glass card ─────────────────────────────────────────────────────────────

  double _cardHeight(BuildContext ctx) {
    final mq = MediaQuery.of(ctx);
    return mq.size.height * 0.42 + mq.padding.bottom;
  }

  Widget _buildGlassCard(bool isDark) {
    final accent = _accent(isDark);
    final mq = MediaQuery.of(context);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: SlideTransition(
          position: _cardSlideAnim,
          child: FadeTransition(
            opacity: _cardFadeAnim,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                28, 28, 28, 28 + mq.padding.bottom,
              ),
              decoration: BoxDecoration(
                color: _cardBg(isDark),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
                border: Border.all(
                  color: accent.withValues(alpha: 0.22),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Drag handle ─────────────────────────────────────────
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Dot indicators ──────────────────────────────────────
                  OnboardingDotIndicators(
                    count: _kPages.length,
                    currentIndex: _currentPage,
                    pageProgress: _pageProgress,
                    color: accent,
                  ),
                  const SizedBox(height: 22),

                  // ── Animated title ──────────────────────────────────────
                  _buildAnimatedTitle(_kPages[_currentPage].title, isDark),
                  const SizedBox(height: 12),

                  // ── Description ─────────────────────────────────────────
                  FadeTransition(
                    opacity: _descFadeAnim,
                    child: Text(
                      _kPages[_currentPage].description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.5,
                        color: _descColor(isDark),
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── CTA button ──────────────────────────────────────────
                  _buildActionButton(isDark),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Word-by-word title reveal ──────────────────────────────────────────────

  Widget _buildAnimatedTitle(String title, bool isDark) {
    final words = title.split(' ');
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 5,
      runSpacing: 2,
      children: words.asMap().entries.map((entry) {
        final i = entry.key;
        final word = entry.value;

        // Each word starts entering 0.06 into the controller range after the last
        final start = (0.30 + i * 0.07).clamp(0.0, 0.95);
        final end = (start + 0.18).clamp(0.0, 1.0);

        return AnimatedBuilder(
          animation: _contentCtrl,
          builder: (_, child) {
            final raw = (_contentCtrl.value - start) / (end - start);
            final t = raw.clamp(0.0, 1.0);
            // Apply ease-out curve manually
            final eased = 1.0 - pow(1.0 - t, 3).toDouble();
            return Opacity(
              opacity: eased,
              child: Transform.translate(
                offset: Offset(0, (1.0 - eased) * 18),
                child: child,
              ),
            );
          },
          child: Text(
            word,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _titleColor(isDark),
              height: 1.2,
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Action button (Next / Get Started) ────────────────────────────────────

  Widget _buildActionButton(bool isDark) {
    final isLast = _currentPage == _kPages.length - 1;
    final accent = _accent(isDark);

    return GestureDetector(
      onTap: isLast ? _getStarted : _nextPage,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
        height: 54,
        width: isLast ? double.infinity : 54,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_kGreenDark, _kGreenBright],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(27),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.45),
              blurRadius: 18,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: isLast
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Get Started',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.4,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                ],
              )
            : const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 22),
      ),
    );
  }

  // ── Skip button ────────────────────────────────────────────────────────────

  Widget _buildSkipButton(bool isDark) {
    final accent = _accent(isDark);
    final topPadding = MediaQuery.of(context).padding.top;

    return Positioned(
      top: topPadding + 14,
      right: 20,
      child: GestureDetector(
        onTap: _skipOnboarding,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.13),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: accent.withValues(alpha: 0.28), width: 1),
          ),
          child: Text(
            'Skip',
            style: TextStyle(
              color: accent,
              fontWeight: FontWeight.w600,
              fontSize: 13.5,
            ),
          ),
        ),
      ),
    );
  }

  // ── Dispose ────────────────────────────────────────────────────────────────

  @override
  void dispose() {
    _particleCtrl.dispose();
    _pulseCtrl.dispose();
    _floatCtrl.dispose();
    _contentCtrl.dispose();
    _hintCtrl.dispose();
    _burstCtrl.dispose();
    _skipFadeCtrl.dispose();
    _pageCtrl.dispose();
    _hintTimer?.cancel();
    super.dispose();
  }
}
