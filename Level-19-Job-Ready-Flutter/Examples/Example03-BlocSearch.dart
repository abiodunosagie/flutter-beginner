// Example 03: A Bloc with events, an event transformer, and pagination.
//
// Shows: past tense event names, a single state class with a status enum,
// restartable() so old searches are cancelled, droppable() so fast scrolling
// does not fire ten page requests, and BlocConsumer.
//
// pubspec.yaml:
//   dependencies:
//     flutter_bloc: ^9.1.1
//     bloc_concurrency: ^0.3.0
//     equatable: ^2.1.0

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(const SearchApp());

// ---------------------------------------------------------------------------
// Repository
// ---------------------------------------------------------------------------

class ProductRepository {
  static const _all = <String>[
    'Running shoes', 'Leather shoes', 'Canvas shoes', 'Trail shoes',
    'Wool socks', 'Cotton socks', 'Sports cap', 'Rain jacket',
    'Denim jacket', 'Fleece jacket', 'Trail backpack', 'Laptop backpack',
  ];

  static const pageSize = 4;

  Future<List<String>> search(String query, {int page = 1}) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    final matches = _all
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();

    final start = (page - 1) * pageSize;
    if (start >= matches.length) return const [];
    return matches.sublist(start, (start + pageSize).clamp(0, matches.length));
  }
}

// ---------------------------------------------------------------------------
// Events: past tense, named after what the USER did.
// ---------------------------------------------------------------------------

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => const [];
}

final class SearchQueryChanged extends SearchEvent {
  const SearchQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

final class SearchCleared extends SearchEvent {
  const SearchCleared();
}

final class SearchNextPageRequested extends SearchEvent {
  const SearchNextPageRequested();
}

// ---------------------------------------------------------------------------
// State: one class with a status, because results must survive "load more".
// ---------------------------------------------------------------------------

enum SearchStatus { initial, loading, success, failure }

final class SearchState extends Equatable {
  const SearchState({
    this.status = SearchStatus.initial,
    this.query = '',
    this.results = const [],
    this.page = 1,
    this.hasMore = true,
    this.errorMessage,
  });

  final SearchStatus status;
  final String query;
  final List<String> results;
  final int page;
  final bool hasMore;
  final String? errorMessage;

  bool get isEmptyResult =>
      status == SearchStatus.success && results.isEmpty && query.isNotEmpty;

  SearchState copyWith({
    SearchStatus? status,
    String? query,
    List<String>? results,
    int? page,
    bool? hasMore,
    String? errorMessage,
  }) {
    return SearchState(
      status: status ?? this.status,
      query: query ?? this.query,
      results: results ?? this.results,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, query, results, page, hasMore, errorMessage];
}

// ---------------------------------------------------------------------------
// Bloc
// ---------------------------------------------------------------------------

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(this._repository) : super(const SearchState()) {
    // restartable: a new keystroke cancels the in-flight search, so an old
    // slow response can never overwrite a newer one.
    on<SearchQueryChanged>(_onQueryChanged, transformer: restartable());

    // droppable: while a page is loading, extra scroll events are ignored.
    on<SearchNextPageRequested>(_onNextPage, transformer: droppable());

    on<SearchCleared>((event, emit) => emit(const SearchState()));
  }

  final ProductRepository _repository;

  Future<void> _onQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(const SearchState());
      return;
    }

    emit(state.copyWith(
      status: SearchStatus.loading,
      query: event.query,
      page: 1,
    ));

    try {
      final results = await _repository.search(event.query);
      emit(state.copyWith(
        status: SearchStatus.success,
        results: results,
        hasMore: results.length == ProductRepository.pageSize,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: SearchStatus.failure,
        errorMessage: 'Search failed. Check your connection.',
      ));
    }
  }

  Future<void> _onNextPage(
    SearchNextPageRequested event,
    Emitter<SearchState> emit,
  ) async {
    if (!state.hasMore || state.status != SearchStatus.success) return;

    final nextPage = state.page + 1;
    try {
      final more = await _repository.search(state.query, page: nextPage);
      emit(state.copyWith(
        results: [...state.results, ...more],
        page: nextPage,
        hasMore: more.length == ProductRepository.pageSize,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: SearchStatus.failure,
        errorMessage: 'Could not load more results.',
      ));
    }
  }
}

// ---------------------------------------------------------------------------
// UI
// ---------------------------------------------------------------------------

class SearchApp extends StatelessWidget {
  const SearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bloc Search',
      theme: ThemeData(useMaterial3: true),
      home: BlocProvider(
        create: (_) => SearchBloc(ProductRepository()),
        child: const SearchPage(),
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      context.read<SearchBloc>().add(const SearchNextPageRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              key: const Key('search_field'),
              decoration: const InputDecoration(
                hintText: 'Try "shoes" or "jacket"',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) =>
                  context.read<SearchBloc>().add(SearchQueryChanged(value)),
            ),
          ),
          Expanded(
            child: BlocConsumer<SearchBloc, SearchState>(
              listenWhen: (previous, current) =>
                  current.status == SearchStatus.failure &&
                  previous.errorMessage != current.errorMessage,
              listener: (context, state) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage ?? 'Error')),
                );
              },
              builder: (context, state) {
                if (state.status == SearchStatus.initial) {
                  return const Center(child: Text('Start typing to search'));
                }
                if (state.status == SearchStatus.loading &&
                    state.results.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.isEmptyResult) {
                  return Center(child: Text('Nothing matched "${state.query}"'));
                }

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: state.results.length + (state.hasMore ? 1 : 0),
                  itemBuilder: (context, i) {
                    if (i >= state.results.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    return ListTile(
                      key: ValueKey(state.results[i]),
                      leading: const Icon(Icons.shopping_bag_outlined),
                      title: Text(state.results[i]),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
