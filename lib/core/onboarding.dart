import 'package:chest_flutter/chest_flutter.dart';

part 'onboarding.g.dart';

/// This chest contains information about the onboarding experience.
final onboarding = Chest<OnboardingState>(
  'onboarding',
  ifNew: () => OnboardingState(),
);

@tape({
  v0: {#swipeToPutInCart, #swipeToSmartCompose}
})
class OnboardingState {
  OnboardingState({
    this.swipeToPutInCart = const OnboardingCountdown(1),
    this.swipeToSmartCompose = const OnboardingCountdown(10),
  });

  final OnboardingCountdown swipeToPutInCart;
  final OnboardingCountdown swipeToSmartCompose;
}

// A class that counts down the number of times that an explanatory widget is
// still shown to the user.
@tape({
  v0: {#counter},
})
class OnboardingCountdown {
  const OnboardingCountdown(this.counter);

  final int counter;
}

extension FancyOnboardingCountdown on Reference<OnboardingCountdown> {
  bool get showExplanation => counter.value > 0;
  void used() {
    if (counter.value > 0) {
      counter.value--;
    }
  }
}
