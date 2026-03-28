import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_reader/data/local/sql_service.dart';
import 'package:pdf_reader/data/models/pdf_file_model.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  StreamSubscription? _intentSub;
  AppCubit() : super(const AppState(pdfFiles: [])) {
    _loadLocalPdfFiles();
    _handleInitialIntent();
    _listenIncoming();
  }

  void _loadLocalPdfFiles() => SqlService.instance.getAllPdfFiles().then(
    (e) => emit(state.copyWith(pdfFiles: e)),
  );

  void _handleInitialIntent() async {
    final files = await ReceiveSharingIntent.instance.getInitialMedia();

    if (files.isNotEmpty) {
      final file = files.first;

      addPdfFile(file.path, file.path.split('/').last);
    }
  }

  void _listenIncoming() {
    _intentSub = ReceiveSharingIntent.instance.getMediaStream().listen((files) {
      if (files.isNotEmpty) {
        final file = files.first;

        addPdfFile(file.path, file.path.split('/').last);
      }
    });
  }

  void addPdfFile(String path, String name) {
    for (final file in state.pdfFiles) {
      if (file.path == path) {
        emit(state.copyWith(selectedPdf: file));
        return;
      }
    }
    SqlService.instance
        .createPdfFile({'path': path, 'name': name})
        .then((_) => _loadLocalPdfFiles());
    emit(
      state.copyWith(
        selectedPdf: state.pdfFiles.firstWhere(
          (element) => element.path == path,
        ),
      ),
    );
  }

  void openedPath() {
    emit(state.clearSelected());
  }

  @override
  Future<void> close() {
    _intentSub?.cancel();
    return super.close();
  }
}
