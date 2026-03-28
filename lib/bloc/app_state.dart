part of 'app_cubit.dart';

class AppState extends Equatable {
  final List<PdfFileModel> pdfFiles;
  final PdfFileModel? selectedPdf;

  const AppState({required this.pdfFiles, this.selectedPdf});

  AppState copyWith({
    List<PdfFileModel>? pdfFiles,
    PdfFileModel? selectedPdf,
  }) => AppState(
    pdfFiles: pdfFiles ?? this.pdfFiles,
    selectedPdf: selectedPdf ?? this.selectedPdf,
  );

  @override
  List<Object?> get props => [pdfFiles, selectedPdf];
}
