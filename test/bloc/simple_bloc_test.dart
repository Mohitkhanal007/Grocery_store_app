import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Simple Counter Bloc for testing
abstract class CounterEvent {}

class IncrementEvent extends CounterEvent {}

class DecrementEvent extends CounterEvent {}

abstract class CounterState {
  final int count;
  const CounterState(this.count);
}

class CounterInitial extends CounterState {
  const CounterInitial() : super(0);
}

class CounterLoaded extends CounterState {
  const CounterLoaded(int count) : super(count);
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterInitial()) {
    on<IncrementEvent>(_onIncrement);
    on<DecrementEvent>(_onDecrement);
  }

  void _onIncrement(IncrementEvent event, Emitter<CounterState> emit) {
    emit(CounterLoaded(state.count + 1));
  }

  void _onDecrement(DecrementEvent event, Emitter<CounterState> emit) {
    emit(CounterLoaded(state.count - 1));
  }
}

void main() {
  group('CounterBloc Tests', () {
    late CounterBloc counterBloc;

    setUp(() {
      counterBloc = CounterBloc();
    });

    tearDown(() {
      counterBloc.close();
    });

    test('initial state should be CounterInitial with count 0', () {
      expect(counterBloc.state, isA<CounterInitial>());
      expect(counterBloc.state.count, equals(0));
    });

    test('should increment count when IncrementEvent is added', () async {
      counterBloc.add(IncrementEvent());
      await Future.delayed(const Duration(milliseconds: 10));
      expect(counterBloc.state, isA<CounterLoaded>());
      expect(counterBloc.state.count, equals(1));
    });

    test('should decrement count when DecrementEvent is added', () async {
      counterBloc.add(DecrementEvent());
      await Future.delayed(const Duration(milliseconds: 10));
      expect(counterBloc.state, isA<CounterLoaded>());
      expect(counterBloc.state.count, equals(-1));
    });

    test('should handle multiple increment events', () async {
      counterBloc.add(IncrementEvent());
      counterBloc.add(IncrementEvent());
      counterBloc.add(IncrementEvent());
      await Future.delayed(const Duration(milliseconds: 10));
      expect(counterBloc.state.count, equals(3));
    });

    test('should handle increment and decrement events', () async {
      counterBloc.add(IncrementEvent());
      counterBloc.add(IncrementEvent());
      counterBloc.add(DecrementEvent());
      await Future.delayed(const Duration(milliseconds: 10));
      expect(counterBloc.state.count, equals(1));
    });

    test('should handle negative count', () async {
      counterBloc.add(DecrementEvent());
      counterBloc.add(DecrementEvent());
      counterBloc.add(DecrementEvent());
      await Future.delayed(const Duration(milliseconds: 10));
      expect(counterBloc.state.count, equals(-3));
    });

    test('should maintain state between events', () async {
      counterBloc.add(IncrementEvent());
      await Future.delayed(const Duration(milliseconds: 10));
      expect(counterBloc.state.count, equals(1));

      counterBloc.add(IncrementEvent());
      await Future.delayed(const Duration(milliseconds: 10));
      expect(counterBloc.state.count, equals(2));

      counterBloc.add(DecrementEvent());
      await Future.delayed(const Duration(milliseconds: 10));
      expect(counterBloc.state.count, equals(1));
    });

    test('should handle edge cases', () {
      expect(counterBloc.state.count, equals(0));
      expect(counterBloc.state, isA<CounterInitial>());
    });
  });
}
