import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_reader/bloc/app_cubit.dart';
import 'package:pdf_reader/presentation/router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Reader')),
      body: BlocConsumer<AppCubit, AppState>(
        listener: (context, state) {
          if (state.selectedPdf != null) {
            Navigator.pushNamed(
              context,
              RouteNames.pdfViewRoute,
              arguments: state.selectedPdf!.path,
            );
          }
        },
        builder: (context, state) {
          return ListView.builder(
            itemCount: state.pdfFiles.length,
            itemBuilder: (context, index) {
              final file = state.pdfFiles[index];
              return ListTile(
                title: Text(file.name),
                onTap: () => Navigator.pushNamed(
                  context,
                  RouteNames.pdfViewRoute,
                  arguments: state.selectedPdf!.path,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
