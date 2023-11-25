import 'dart:convert';

import 'package:assignment_1/dashboard/bloc/documents/document_event.dart';
import 'package:assignment_1/dashboard/bloc/documents/document_state.dart';
import 'package:assignment_1/dashboard/models/ModelDocuments.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DocumentBloc extends Bloc<DocumentsEvent, DocumentsState> {
  DocumentBloc()
      : super(
          DocumentsInitialState(),
        ) {
    on<DocumentsInitialFetchEvent>(
      documentsFetchEvent,
    );


    /// Event to load the transaction documents
    on<LoadTransactionDocumentsEvent>(
          (event, emit) {
            debugPrint('Transaction ID: ${event.transactionId}');
            debugPrint("Transaction Documents: ${DocumentsData.transactions[0].documents}");
        emit(
          ShowTransactionDocumentsState(
            transactionId: event.transactionId,
          ),
        );
      },
    );

    /// Event to hide the transaction documents
    on<HideTransactionDocumentsEvent>(
          (event, emit) {
        emit(
          HideTransactionDocumentsState(
            transactionId: event.transactionId,
          ),
        );
      },
    );

  }

  /// Fetching the documents data from the json file
  void documentsFetchEvent(
      DocumentsInitialFetchEvent event, Emitter<DocumentsState> emit) async {
    String jsonString =
        await rootBundle.loadString('assets/json/documents.json');

    /// Decoding the json string
    ModelDocuments documentsModel =
        ModelDocuments.fromJson(jsonDecode(jsonString));

    /// Access the data
    List<Value> values = documentsModel.value;

    /// Setting the data in the documents data class
    DocumentsData.setDocumentsData(
      transactions: values[0].transaction,
      team: values[0].team,
      tax: values[0].tax,
      joining: values[0].joining,
    );
    emit(DocumentsFetchedState());
    /*for (Value value in values) {
      // Access 'joining' data
      List<Joining> joining = value.joining;
      for (Joining joiningItem in joining) {
        debugPrint('Joining Title: ${joiningItem.title}');
        debugPrint('Joining Size: ${joiningItem.size}');
        debugPrint('Joining URL: ${joiningItem.url}');
      }

      // Access 'transaction' data
      List<Transaction> transactions = value.transaction;
      for (Transaction transaction in transactions) {
        debugPrint('Transaction Address: ${transaction.address}');
        debugPrint('Transaction ID: ${transaction.transactionId}');

        List<TransactionDocument> transactionDocuments = transaction.documents;
        for (TransactionDocument document in transactionDocuments) {
          debugPrint('Document Title: ${document.title}');
          debugPrint('Document CheckListName: ${document.checkListName}');
          // ... (other document properties)
        }
      }

      // Access 'team' data
      List<Joining> team = value.team;
      for (Joining teamItem in team) {
        debugPrint('Team Title: ${teamItem.title}');
        debugPrint('Team Size: ${teamItem.size}');
        debugPrint('Team URL: ${teamItem.url}');
      }

      // Access 'tax' data
      List<Joining> tax = value.tax;
      for (Joining taxItem in tax) {
        debugPrint('Tax Title: ${taxItem.title}');
        debugPrint('Tax Size: ${taxItem.size}');
        debugPrint('Tax URL: ${taxItem.url}');
      }
    }*/
  }
}
