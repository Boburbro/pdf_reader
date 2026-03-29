part of 'app_cubit.dart';

class AppState extends Equatable {
  final List<PdfFileModel> pdfFiles;
  final PdfFileModel? selectedPdf;
  final Locale locale;
  final String cacheSize;
  final bool isClearingCache;

  const AppState({
    required this.pdfFiles,
    this.selectedPdf,
    this.locale = const Locale('en'),
    this.cacheSize = '0.00 KB',
    this.isClearingCache = false,
  });

  AppState copyWith({
    List<PdfFileModel>? pdfFiles,
    PdfFileModel? selectedPdf,
    Locale? locale,
    String? cacheSize,
    bool? isClearingCache,
  }) =>
      AppState(
        pdfFiles: pdfFiles ?? this.pdfFiles,
        selectedPdf: selectedPdf ?? this.selectedPdf,
        locale: locale ?? this.locale,
        cacheSize: cacheSize ?? this.cacheSize,
        isClearingCache: isClearingCache ?? this.isClearingCache,
      );

  AppState clearSelected() => AppState(
        pdfFiles: pdfFiles,
        selectedPdf: null,
        locale: locale,
        cacheSize: cacheSize,
        isClearingCache: isClearingCache,
      );

  @override
  List<Object?> get props => [
        pdfFiles,
        selectedPdf,
        locale,
        cacheSize,
        isClearingCache,
      ];
}
