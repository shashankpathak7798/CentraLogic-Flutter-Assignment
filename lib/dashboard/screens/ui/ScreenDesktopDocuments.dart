import 'package:assignment_1/dashboard/models/ModelDocuments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../bloc/documents/document_bloc.dart';
import '../../bloc/documents/document_event.dart';
import '../../bloc/documents/document_state.dart';

class ScreenDesktopDocuments extends StatefulWidget {
  const ScreenDesktopDocuments({super.key});

  @override
  State<ScreenDesktopDocuments> createState() => _ScreenDesktopDocumentsState();
}

class _ScreenDesktopDocumentsState extends State<ScreenDesktopDocuments> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<DocumentBloc>(context).add(DocumentsInitialFetchEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          getActionButton(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 34,
          horizontal: 30,
        ),
        child: DefaultTabController(
          length: 04,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                child: Text(
                  "Documents",
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              /// Padding
              const SizedBox(
                height: 30,
              ),

              /// Building the tab bar
              buildTabBar(),

              /// Padding
              const SizedBox(
                height: 30,
              ),

              /// Building the tab bar view
              buildTabBarView(),
            ],
          ),
        ),
      ),
    );
  }

  /// Function to build the tab bar
  buildTabBar() => Container(
        width: 728,
        height: 50,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: const Color.fromRGBO(242, 242, 242, 1,),
    ),
        child: TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Colors.white,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromRGBO(
              21,
              58,
              131,
              1,
            ),
          ),
          dividerColor: Colors.transparent,
          tabs: const [
            Tab(
              text: "Joining Documents",
            ),
            Tab(
              text: "Transaction Documents",
            ),
            Tab(
              text: "Team Documents",
            ),
            Tab(
              text: "Tax Documents",
            ),
          ],
        ),
      );

  /// Function to build TabBarView
  buildTabBarView() {
    debugPrint("Joining: ${DocumentsData.joining.length}");
    debugPrint("Transactions: ${DocumentsData.transactions.length}");
    debugPrint("Team: ${DocumentsData.team.length}");
    debugPrint("Tax: ${DocumentsData.tax.length}");
    return Expanded(
      //width: 728,
      child: TabBarView(
        children: [
          /// Bloc builder to build the joining tab
          BlocBuilder<DocumentBloc, DocumentsState>(
            builder: (context, state) {
              if (state is DocumentsFetchedState) {
                return buildOtherTabs(
                  documents: DocumentsData.joining,
                );
              }
              return buildOtherTabs(documents: DocumentsData.joining,);
            },
          ),

          /// Bloc builder to build the transactions tab
          BlocBuilder<DocumentBloc, DocumentsState>(
            builder: (context, state) {
              if (state is DocumentsFetchedState) {
                return buildTransactionsTab(transactions: DocumentsData.transactions,);
              }
              return buildTransactionsTab(transactions: DocumentsData.transactions,);
            },
          ),

          /// Bloc builder to build the team tab
          BlocBuilder<DocumentBloc, DocumentsState>(
            builder: (context, state) {
              if (state is DocumentsFetchedState) {
                return buildOtherTabs(
                  documents: DocumentsData.team,
                );
              }
              return buildOtherTabs(documents: DocumentsData.team,);
            },
          ),

          /// Bloc builder to build the tax tab
          BlocBuilder<DocumentBloc, DocumentsState>(
            builder: (context, state) {
              if (state is DocumentsFetchedState) {
                return buildOtherTabs(
                  documents: DocumentsData.tax,
                );
              }
              return buildOtherTabs(documents: DocumentsData.tax,);
            },
          ),
        ],
      ),
    );
  }

  /// Function to build the transactions tab
  buildTransactionsTab({required List<Transaction> transactions}) => SizedBox(
        width: 728,
        child: ListView.separated(
          itemBuilder: (context, index) {
            /// Creating new Instance of the DocumentBloc for each item
            final documentBloc = DocumentBloc();

            return BlocProvider.value(
              value: documentBloc,
              child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// ListTile to display the Transaction document address and transaction ID
                ListTile(
                  titleAlignment: ListTileTitleAlignment.center,
                  shape: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(
                        48,
                        48,
                        48,
                        0.05,
                      ),
                      width: 1,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),

                  /// Document Title
                  title: getTitleText(transactions[index].address),

                  /// Document Transaction ID
                  subtitle: getSubtitleText(
                    "Transaction ID #${transactions[index].transactionId}",
                  ),

                  /// Trailing icon to preview the document
                  trailing: BlocBuilder<DocumentBloc, DocumentsState>(
                    builder: (context, state) {
                      if (state is ShowTransactionDocumentsState) {
                        return IconButton(
                          onPressed: () {
                            /// Dispatching the event to Hide the transaction documents
                            BlocProvider.of<DocumentBloc>(context).add(
                              HideTransactionDocumentsEvent(
                                transactionId: transactions[index].transactionId,
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.keyboard_arrow_up,
                            color: Colors.grey,
                          ),
                        );
                      }

                      /// returning the default icon if the state is not ShowTransactionDocumentsState
                      return IconButton(
                        onPressed: () {
                          /*debugPrint("Transaction ID: ${transactions[index].transactionId}");
                          debugPrint("Transactions: ${transactions[index].documents}");*/

                          /// Dispatching the event to load the transaction documents
                          BlocProvider.of<DocumentBloc>(context).add(
                            LoadTransactionDocumentsEvent(
                              transactionId: transactions[index].transactionId,
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.chevron_right,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),

                /// Padding
                const SizedBox(
                  height: 10,
                ),

                /// call to the function to build the list of documents
                BlocBuilder<DocumentBloc, DocumentsState>(
                  builder: (context, state) => state is ShowTransactionDocumentsState &&
                      state.transactionId == transactions[index].transactionId
                      ? buildDocumentsTable(
                    documents: transactions[index].documents,
                  )
                      : state is HideTransactionDocumentsState
                      ? const SizedBox()
                      : const SizedBox(),
                ),
              ],
                        ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(
            height: 10,
          ),
          itemCount: transactions.length,
        ),
      );

  /// Function to build the action button for the appbar
  getActionButton() => Container(
        width: 142,
        height: 42,
        padding: const EdgeInsets.symmetric(
          horizontal: 08,
          vertical: 06,
        ),
        margin: const EdgeInsets.only(
          right: 30,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromRGBO(
              1,
              48,
              48,
              48,
            ),
            width: 1,
          ),
        ),
        child: DropdownButton(
          onChanged: (value) {},
          underline: Container(),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Color.fromRGBO(
              48,
              48,
              48,
              1,
            ),
          ),
          items: [
            DropdownMenuItem(
              child: Row(
                children: [
                  Image.asset("assets/avatars.png"),
                  const SizedBox(
                    width: 08,
                  ),
                  const Text(
                    "Charles",
                    style: TextStyle(
                      fontSize: 17.0,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(
                        48,
                        48,
                        48,
                        1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  /// Function to build the list of documents in table format
  buildDocumentsTable({required List<TransactionDocument> documents}) {
    debugPrint("Documents Length: ${documents.length}");
    debugPrint("Documents: $documents");
    return SizedBox(
      width: double.infinity,
      child: Table(
        border: TableBorder.all(
          color: const Color.fromRGBO(
            48,
            48,
            48,
            0.05,
          ),
          width: 1,
        ),
        children: [
           TableRow(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(
                48,
                48,
                48,
                0.05,
              ),
            ),
            children: [
              getHeadTableCell(text: "Document Name",),
              getHeadTableCell(text: "Checklist Name",),
              getHeadTableCell(text: "Date & Time",),
              getHeadTableCell(text: "Status",),
              getHeadTableCell(text: "Action",),
            ],
          ),
          ...documents
              .map(
                (e) => TableRow(
                  children: [
                    getBodyTableCell(text: e.title,),
                    getBodyTableCell(text: e.checkListName,),
                    getBodyTableCell(text: e.date,),
                    TableCell(
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 15,
                        ),
                        child: Text(
                          e.status,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w400,
                            backgroundColor: e.status == "Unapproved"
                                ? const Color.fromRGBO(
                              255,
                              0,
                              0,
                              0.5,
                            )
                                : const Color.fromRGBO(
                              213,
                              244,
                              220,
                              1,
                            ),
                            color: e.status == "Unapproved"
                                ? const Color.fromRGBO(
                                    255,
                                    0,
                                    0,
                                    1,
                                  )
                                : const Color.fromRGBO(
                                    32,
                                    135,
                                    56,
                                    1,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: IconButton(
                        onPressed: () async {
                          /// Opening the document
                          try {
                            if (await canLaunchUrl(Uri.parse(e.url))) {
                              await launchUrl(Uri.parse(e.url), mode: LaunchMode.externalApplication,);
                            }
                          } catch (e) {
                            debugPrint("Cannot launch url");
                          }
                        },
                        icon: const Icon(
                          Icons.remove_red_eye_outlined,
                          color: Color.fromRGBO(
                            35,
                            97,
                            219,
                            1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ],
      ),
    );
  }



  /// Function to build the Heading Table Cell of the Table
  getHeadTableCell({required String text}) => TableCell(
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        child: Row(
        children: [
          Text(text, style: const TextStyle(
            fontSize: 16,
            fontFamily: "Roboto",
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(48, 48, 48, 1,),
          ),),
          const SizedBox(
            width: 10,
          ),
          const Icon(Icons.arrow_drop_down, color: Colors.grey,),
        ],
      ),
    ),
  );


  /// function to build the body table cell of the table
  getBodyTableCell({required String text}) => TableCell(
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        child: Text(text, style: const TextStyle(
        fontSize: 16,
        fontFamily: "Roboto",
        fontWeight: FontWeight.w400,
        color: Color.fromRGBO(94, 94, 94, 1,),
      ),),
    ),
  );


}
/// This functions are declared with global scope as they are used at both places i.e in the ScreenDesktopDocuments and ScreenMobileDocuments screens, this is done to avoid re-write of the code
/// Function to build the other tabs i.e the team, tax and joining tabs
buildOtherTabs({required List<Joining> documents}) => SizedBox(
  width: double.infinity,
  height: double.infinity,
  child: ListView.separated(
    itemBuilder: (context, index) => ListTile(
      titleAlignment: ListTileTitleAlignment.center,
      shape: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromRGBO(
            48,
            48,
            48,
            0.05,
          ),
          width: 1,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),

      /// Container to display the PDF icon
      leading: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(05),
          color: const Color.fromRGBO(
            252,
            227,
            205,
            1,
          ),
        ),
        padding: const EdgeInsets.all(07),
        child: Image.asset("assets/file_pdf.png"),
      ),

      /// Title of the document
      title: getTitleText(documents[index].title),

      /// Subtitle of the document
      subtitle: getSubtitleText(documents[index].size),

      /// Trailing icon to preview the document
      trailing: IconButton(
        onPressed: () async {
          /// Opening the document
          try {
            if (await canLaunchUrl(Uri.parse(documents[index].url))) {
              await launchUrl(Uri.parse(documents[index].url), mode: LaunchMode.externalApplication,);
            }
          } catch (e) {
            debugPrint("Cannot launch url");
          }
        },
        icon: const Icon(
          Icons.remove_red_eye_outlined,
          color: Color.fromRGBO(
            35,
            97,
            219,
            1,
          ),
        ),
      ),
    ),
    separatorBuilder: (context, index) => const SizedBox(
      height: 10,
    ),
    itemCount: documents.length,
  ),
);


/// Function to get the Title Text Widget
getTitleText(String text) => Text(
  text,
  style: const TextStyle(
    fontSize: 14,
    fontFamily: "Roboto",
    fontWeight: FontWeight.w400,
    color: Color.fromRGBO(
      48,
      48,
      48,
      1,
    ),
  ),
);

/// Function to get the Subtitle Text Widget
getSubtitleText(String text) => Text(
  text,
  style: const TextStyle(
    fontSize: 12,
    fontFamily: "Roboto",
    fontWeight: FontWeight.w400,
    color: Color.fromRGBO(
      128,
      128,
      128,
      1,
    ),
  ),
);