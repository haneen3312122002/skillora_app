import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailsAsyncBlock<T> extends StatelessWidget {
  final AsyncValue<T> async;
  final Widget Function(T data) builder;
  final String loadingText;
  final String errorPrefix;

  const DetailsAsyncBlock({
    super.key,
    required this.async,
    required this.builder,
    this.loadingText = 'Loading...',
    this.errorPrefix = 'Error',
  });

  @override
  Widget build(BuildContext context) {
    return async.when(
      loading: () => Text(loadingText),
      error: (e, _) => Text('$errorPrefix: $e'),
      data: (data) => builder(data),
    );
  }
}
