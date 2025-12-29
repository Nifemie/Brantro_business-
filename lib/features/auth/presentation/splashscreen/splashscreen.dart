import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for animation controllers
final splashAnimationProvider =
    StateNotifierProvider.autoDispose<
      SplashAnimationNotifier,
      SplashAnimationState
    >((ref) {
      return SplashAnimationNotifier(ref);
    });

class SplashAnimationState {
  final AnimationController? scaleController;
  final AnimationController? backgroundController;
  final AnimationController? textController;
  final bool isAnimating;

  SplashAnimationState({
    this.scaleController,
    this.backgroundController,
    this.textController,
    this.isAnimating = false,
  });

  SplashAnimationState copyWith({
    AnimationController? scaleController,
    AnimationController? backgroundController,
    AnimationController? textController,
    bool? isAnimating,
  }) {
    return SplashAnimationState(
      scaleController: scaleController ?? this.scaleController,
      backgroundController: backgroundController ?? this.backgroundController,
      textController: textController ?? this.textController,
      isAnimating: isAnimating ?? this.isAnimating,
    );
  }
}

class SplashAnimationNotifier extends StateNotifier<SplashAnimationState> {
  final Ref ref;

  SplashAnimationNotifier(this.ref) : super(SplashAnimationState());

  void initializeAnimations(TickerProvider tickerProvider) {
    final scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: tickerProvider,
    );
    final backgroundController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: tickerProvider,
    );
    final textController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: tickerProvider,
    );

    state = state.copyWith(
      scaleController: scaleController,
      backgroundController: backgroundController,
      textController: textController,
    );

    ref.onDispose(() {
      scaleController.dispose();
      backgroundController.dispose();
      textController.dispose();
    });
  }

  Future<void> startAnimationSequence() async {
    state = state.copyWith(isAnimating: true);
    await Future.delayed(const Duration(milliseconds: 500));
    await state.scaleController?.forward();
    await state.backgroundController?.forward();
    await state.textController?.forward();
    await Future.delayed(const Duration(milliseconds: 800));
    state = state.copyWith(isAnimating: false);
  }
}

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(splashAnimationProvider.notifier);
      notifier.initializeAnimations(this);
      _startSequence();
    });
  }

  Future<void> _startSequence() async {
    final notifier = ref.read(splashAnimationProvider.notifier);
    await notifier.startAnimationSequence();
    _checkSession();
  }

  Future<void> _checkSession() async {
    if (!mounted) return;
    // For now, navigate to intro screen
    context.pushReplacement('/intro');
  }

  @override
  Widget build(BuildContext context) {
    final animationState = ref.watch(splashAnimationProvider);
    final scaleController = animationState.scaleController;
    final backgroundController = animationState.backgroundController;
    final textController = animationState.textController;

    if (scaleController == null ||
        backgroundController == null ||
        textController == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final scaleAnimation = Tween<double>(begin: 60.0, end: 120.0).animate(
      CurvedAnimation(parent: scaleController, curve: Curves.elasticOut),
    );

    final borderRadiusAnimation = Tween<double>(begin: 12.0, end: 60.0).animate(
      CurvedAnimation(parent: scaleController, curve: Curves.elasticOut),
    );

    final backgroundAnimation =
        ColorTween(
          begin: const Color(0xFFFFFFFF),
          end: const Color(0xFFFFFFFF),
        ).animate(
          CurvedAnimation(
            parent: backgroundController,
            curve: Curves.easeInOut,
          ),
        );

    final textSlideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(parent: textController, curve: Curves.easeOut));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: AnimatedBuilder(
        animation: Listenable.merge([
          scaleController,
          backgroundController,
          textController,
        ]),
        builder: (context, child) {
          return Scaffold(
            backgroundColor: backgroundAnimation.value,
            body: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo animation with bounce
                  Container(
                    width: scaleAnimation.value,
                    height: scaleAnimation.value,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        borderRadiusAnimation.value,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          borderRadiusAnimation.value,
                        ),
                        child: Image.asset(
                          'assets/icons/launcher.png',
                          width: scaleAnimation.value * 0.8,
                          height: scaleAnimation.value * 0.8,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  // App name slide-in from right with fade
                  SlideTransition(
                    position: textSlideAnimation,
                    child: FadeTransition(
                      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: textController,
                          curve: Curves.easeOut,
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          'Brantro',
                          style: TextStyle(
                            color: Color(0xFFF06909),
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'SF Pro',
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
