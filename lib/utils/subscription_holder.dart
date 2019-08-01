import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class SubscriptionHolder {
  final _subscriptions = <StreamSubscription>[];

  void add(StreamSubscription subscription) {
    _subscriptions.add(subscription);
  }

  ValueObservable<S> publishValueConnecting<T, S>(
    ValueObservable<T> observable,
    FutureOr<S> Function(T value) f,
  ) {
    final v = f(observable.value);
    final valueObservable = observable
        .asyncMap(f)
        .distinct()
        .publishValueSeeded(v is Future ? null : v as S);
    _subscriptions.add(valueObservable.connect());

    return valueObservable;
  }

  ValueListenable<S> consumeAsListenable<T, S>(
    ValueObservable<T> observable,
    FutureOr<S> Function(T value) f,
  ) {
    final v = f(observable.value);
    final notifier = ValueNotifier<S>(v is Future<S> ? null : v as S);
    _subscriptions.add(
        observable.distinct().listen((x) async => notifier.value = await f(x)));
    return notifier;
  }

  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
  }
}

mixin SubscriptionHolderMixin {
  @protected
  final SubscriptionHolder subscriptionHolder = SubscriptionHolder();

  @mustCallSuper
  void dispose() {
    subscriptionHolder.dispose();
  }
}
