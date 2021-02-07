// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding.dart';

// **************************************************************************
// TapeGenerator
// **************************************************************************

extension TaperForOnboardingState on TaperNamespace {
  _VersionedTapersForOnboardingState forOnboardingState() =>
      _VersionedTapersForOnboardingState();
}

class _VersionedTapersForOnboardingState {
  Taper<OnboardingState> get v0 => _TaperForV0OnboardingState();
}

class _TaperForV0OnboardingState extends MapTaper<OnboardingState> {
  @override
  Map<Object?, Object?> toMap(OnboardingState onboardingstate) {
    return {
      'swipeToPutInCart': onboardingstate.swipeToPutInCart,
      'swipeToSmartCompose': onboardingstate.swipeToSmartCompose,
    };
  }

  @override
  OnboardingState fromMap(Map<Object?, Object?> map) {
    return OnboardingState(
      swipeToPutInCart: map['swipeToPutInCart'] as OnboardingCountdown,
      swipeToSmartCompose: map['swipeToSmartCompose'] as OnboardingCountdown,
    );
  }
}

extension ReferenceToOnboardingState on Reference<OnboardingState> {
  Reference<OnboardingCountdown> get swipeToPutInCart =>
      child('swipeToPutInCart');
  Reference<OnboardingCountdown> get swipeToSmartCompose =>
      child('swipeToSmartCompose');
}

extension TaperForOnboardingCountdown on TaperNamespace {
  _VersionedTapersForOnboardingCountdown forOnboardingCountdown() =>
      _VersionedTapersForOnboardingCountdown();
}

class _VersionedTapersForOnboardingCountdown {
  Taper<OnboardingCountdown> get v0 => _TaperForV0OnboardingCountdown();
}

class _TaperForV0OnboardingCountdown extends MapTaper<OnboardingCountdown> {
  @override
  Map<Object?, Object?> toMap(OnboardingCountdown onboardingcountdown) {
    return {
      'counter': onboardingcountdown.counter,
    };
  }

  @override
  OnboardingCountdown fromMap(Map<Object?, Object?> map) {
    return OnboardingCountdown(
      map['counter'] as int,
    );
  }
}

extension ReferenceToOnboardingCountdown on Reference<OnboardingCountdown> {
  Reference<int> get counter => child('counter');
}
