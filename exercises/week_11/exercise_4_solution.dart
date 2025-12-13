// Week 11, Exercise 4: Counter with Bloc Pattern
// Difficulty: Intermediate-Advanced
// Solution

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

void main() {
  runApp(MyApp());
}

// CounterEvent abstract class
abstract class CounterEvent {}

// Concrete event classes
class IncrementPressed extends CounterEvent {}

class DecrementPressed extends CounterEvent {}

class ResetPressed extends CounterEvent {}

// CounterState class
class CounterState extends Equatable {
  final int count;

  const CounterState(this.count);

  @override
  List<Object> get props => [count];
}

// CounterBloc
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterState(0)) {
    on<IncrementPressed>(_onIncrement);
    on<DecrementPressed>(_onDecrement);
    on<ResetPressed>(_onReset);
  }

  void _onIncrement(IncrementPressed event, Emitter<CounterState> emit) {
    emit(CounterState(state.count + 1));
  }

  void _onDecrement(DecrementPressed event, Emitter<CounterState> emit) {
    emit(CounterState(state.count - 1));
  }

  void _onReset(ResetPressed event, Emitter<CounterState> emit) {
    emit(const CounterState(0));
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bloc Counter',
      home: BlocProvider(
        create: (context) => CounterBloc(),
        child: CounterScreen(),
      ),
    );
  }
}

class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bloc Counter')),
      body: BlocListener<CounterBloc, CounterState>(
        listener: (context, state) {
          if (state.count == 10) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('You reached 10!'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state.count == -10) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('You reached -10!'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Counter Value:',
                style: TextStyle(fontSize: 20),
              ),
              BlocBuilder<CounterBloc, CounterState>(
                builder: (context, state) {
                  return Text(
                    '${state.count}',
                    style: TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                      color: state.count >= 0 ? Colors.blue : Colors.red,
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.read<CounterBloc>().add(DecrementPressed());
                    },
                    child: Icon(Icons.remove),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CounterBloc>().add(ResetPressed());
                    },
                    child: Text('Reset'),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CounterBloc>().add(IncrementPressed());
                    },
                    child: Icon(Icons.add),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
