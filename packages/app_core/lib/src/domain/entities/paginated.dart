import 'package:equatable/equatable.dart';

/// One page of results.
///
/// Generic on purpose: never write a second pagination envelope for a second
/// entity.
class Paginated<T> extends Equatable {
  const Paginated({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
  });

  const Paginated.empty() : items = const [], total = 0, page = 1, limit = 20;

  final List<T> items;
  final int total;
  final int page;
  final int limit;

  bool get hasNextPage => page * limit < total;

  @override
  List<Object?> get props => [items, total, page, limit];
}
