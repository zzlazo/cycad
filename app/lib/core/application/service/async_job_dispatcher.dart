import "dart:async";
import "dart:collection";

import "../../error/app_error.dart";
import "../../model/core_model.dart";

abstract class IASyncJobDispatcher {
  Stream<AsyncJobStatus> get statusStream;
  Future<AsyncJobResult<T>> trackJob<T>(AsyncJobQueue<T> queue);
}

class _QueuedJob<T> {
  final AsyncJobQueue<T> queue;
  final Completer<AsyncJobResult<T>> completer;
  _QueuedJob(this.queue, this.completer);
}

class AsyncJobDispatcher implements IASyncJobDispatcher {
  final ListQueue<_QueuedJob<dynamic>> _jobQueue = ListQueue();
  final Map<String, AsyncJobQueue> _activeJobs = {};
  final _statusController = StreamController<AsyncJobStatus>.broadcast();

  bool _isProcessing = false;
  Object? latestError;

  @override
  Stream<AsyncJobStatus> get statusStream => _statusController.stream;

  @override
  Future<AsyncJobResult<T>> trackJob<T>(AsyncJobQueue<T> queue) async {
    final completer = Completer<AsyncJobResult<T>>();
    _jobQueue.add(_QueuedJob<T>(queue, completer));

    _processQueue<T>();

    return completer.future;
  }

  Future<void> _processQueue<T>() async {
    if (_isProcessing || _jobQueue.isEmpty) return;

    _isProcessing = true;

    while (_jobQueue.isNotEmpty) {
      final item = _jobQueue.removeFirst();
      final queue = item.queue;

      _activeJobs[queue.id] = queue;
      _emitAggregateStatus();

      try {
        final result = await queue.job();
        item.completer.complete(AsyncJobSuccess<T>(result));
      } catch (e) {
        latestError = e;
        item.completer.complete(AsyncJobFailure<T>(e));
      } finally {
        _activeJobs.remove(queue.id);
        _emitAggregateStatus();
      }
    }

    _isProcessing = false;
  }

  void _emitAggregateStatus() {
    if (latestError != null) {
      _statusController.add(
        AsyncJobStatus(
          isLoading: false,
          hasError: true,
          errorMessage: latestError is AppException
              ? (latestError as AppException).message
              : "Unknown error occurred",
        ),
      );
      latestError = null;
      return;
    }

    if (_activeJobs.isEmpty) {
      _statusController.add(const AsyncJobStatus(isLoading: false));
      return;
    }

    _statusController.add(
      AsyncJobStatus(
        isLoading: true,
        showLoading: _activeJobs.values.any(
          (job) => job.showLoading ?? job.type == AsyncJobType.modify,
        ),
      ),
    );
  }
}
