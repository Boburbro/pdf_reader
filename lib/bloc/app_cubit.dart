import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_reader/data/local/sql_service.dart';
import 'package:pdf_reader/data/models/pdf_file_model.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  StreamSubscription? _intentSub;
  AppCubit() : super(const AppState(pdfFiles: [], locale: Locale('en'))) {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString('locale') ?? 'en';
    emit(state.copyWith(locale: Locale(localeCode)));
    
    await _loadLocalPdfFiles();
    await updateCacheSize();
    _handleInitialIntent();
    _listenIncoming();
  }

  Future<void> _loadLocalPdfFiles() async {
    final e = await SqlService.instance.getAllPdfFiles();
    emit(state.copyWith(pdfFiles: e));
  }

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

  Future<void> addPdfFile(String path, String name) async {
    final now = DateTime.now();

    for (final file in state.pdfFiles) {
      if (file.path == path) {
        final updatedFile = file.copyWith(lastOpenedAt: now);
        await SqlService.instance.updatePdfFile(updatedFile);
        await _loadLocalPdfFiles();
        emit(state.copyWith(
          selectedPdf: state.pdfFiles.firstWhere((e) => e.path == path),
        ));
        return;
      }
    }

    // Double check DB to strongly guarantee no duplicates
    final currentDbFiles = await SqlService.instance.getAllPdfFiles();
    try {
      final existingFile = currentDbFiles.firstWhere((e) => e.path == path);
      final updatedFile = existingFile.copyWith(lastOpenedAt: now);
      await SqlService.instance.updatePdfFile(updatedFile);
      await _loadLocalPdfFiles();
      emit(state.copyWith(
        selectedPdf: state.pdfFiles.firstWhere((e) => e.path == path),
      ));
      return;
    } catch (_) {}

    await SqlService.instance.createPdfFile({
      'path': path,
      'name': name,
      'last_opened_at': now.toIso8601String(),
    });
    await _loadLocalPdfFiles();

    emit(state.copyWith(
      selectedPdf: state.pdfFiles.firstWhere((element) => element.path == path),
    ));
  }

  void openedPath() {
    emit(state.clearSelected());
  }

  Future<void> setLocale(Locale loc) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', loc.languageCode);
    emit(state.copyWith(locale: loc));
  }

  Future<void> updateCacheSize() async {
    double totalSize = 0;

    try {
      final tempDir = await getTemporaryDirectory();
      totalSize += await _getDirSize(tempDir);

      final dbPath = await getDatabasesPath();
      final dbDir = Directory(dbPath);
      totalSize += await _getDirSize(dbDir);
    } catch (e) {
      debugPrint('Error calculating cache size: $e');
    }

    emit(state.copyWith(cacheSize: _formatBytes(totalSize)));
  }

  Future<double> _getDirSize(Directory dir) async {
    double size = 0;
    try {
      if (await dir.exists()) {
        await for (final file in dir.list(recursive: true, followLinks: false)) {
          if (file is File) {
            size += await file.length();
          }
        }
      }
    } catch (e) {
      debugPrint('Error getting directory size: $e');
    }
    return size;
  }

  String _formatBytes(double bytes) {
    if (bytes <= 0) return '0.00 KB';
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    int i = 0;
    while (bytes >= 1024 && i < suffixes.length - 1) {
      bytes /= 1024;
      i++;
    }
    return '${bytes.toStringAsFixed(2)} ${suffixes[i]}';
  }

  Future<void> clearCache() async {
    emit(state.copyWith(isClearingCache: true));

    try {
      // 1. Clear Database
      await SqlService.instance.deleteAll();

      // 2. Clear Temporary Directory
      final tempDir = await getTemporaryDirectory();
      if (await tempDir.exists()) {
        await for (final file in tempDir.list()) {
          await file.delete(recursive: true);
        }
      }

      // Small delay for animation feel
      await Future.delayed(const Duration(milliseconds: 800));
    } catch (e) {
      debugPrint('Error clearing cache: $e');
    }

    await _loadLocalPdfFiles();
    await updateCacheSize();
    emit(state.copyWith(isClearingCache: false));
  }

  @override
  Future<void> close() {
    _intentSub?.cancel();
    return super.close();
  }
}
