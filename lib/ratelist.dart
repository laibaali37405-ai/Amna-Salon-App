import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RateListPage extends StatefulWidget {
  final String branchName;
  const RateListPage({super.key, required this.branchName});

  @override
  State<RateListPage> createState() => _RateListPageState();
}

class _RateListPageState extends State<RateListPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool get isAdmin => widget.branchName == "ADMIN_MODE";

  // --- Admin Dialog for Sections & Items ---
  void _showRateDialog({String? docId, Map<String, dynamic>? data}) {
    TextEditingController sectionTitleController = TextEditingController(
      text: data?['sectionTitle'] ?? "",
    );

    // Multiple items ke liye list (Name aur Price)
    List<Map<String, dynamic>> items = data?['items'] != null
        ? List<Map<String, dynamic>>.from(data!['items'])
        : [
            {"name": "", "price": ""},
          ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Color(0xFFD4AF37)),
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            docId == null ? "ADD RATE SECTION" : "EDIT RATE SECTION",
            style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 18),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildPopupField(
                    sectionTitleController,
                    "Section (e.g. HAIR CUTTING)",
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Items & Prices",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const Divider(color: Color(0xFFD4AF37)),
                  ...items.asMap().entries.map((entry) {
                    int idx = entry.key;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: _buildSmallField(
                              onChanged: (v) => items[idx]['name'] = v,
                              hint: "Item Name",
                              initialValue: items[idx]['name'],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 1,
                            child: _buildSmallField(
                              onChanged: (v) => items[idx]['price'] = v,
                              hint: "Price",
                              initialValue: items[idx]['price'],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.remove_circle,
                              color: Colors.redAccent,
                              size: 22,
                            ),
                            onPressed: () {
                              if (items.length > 1) {
                                setDialogState(() => items.removeAt(idx));
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  TextButton.icon(
                    onPressed: () => setDialogState(
                      () => items.add({"name": "", "price": ""}),
                    ),
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: Color(0xFFD4AF37),
                    ),
                    label: const Text(
                      "ADD MORE ITEMS",
                      style: TextStyle(color: Color(0xFFD4AF37)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "CANCEL",
                style: TextStyle(color: Colors.white54),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
              ),
              onPressed: () async {
                Map<String, dynamic> rateData = {
                  "sectionTitle": sectionTitleController.text.toUpperCase(),
                  "items": items,
                  "timestamp": FieldValue.serverTimestamp(),
                };
                docId == null
                    ? await _firestore.collection('rate_list').add(rateData)
                    : await _firestore
                          .collection('rate_list')
                          .doc(docId)
                          .update(rateData);
                Navigator.pop(context);
              },
              child: const Text(
                "SAVE",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "RATE LIST",
          style: TextStyle(
            color: Color(0xFFD4AF37),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFD4AF37)),
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              backgroundColor: const Color(0xFFD4AF37),
              onPressed: () => _showRateDialog(),
              child: const Icon(Icons.add, color: Colors.black),
            )
          : null,
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('rate_list')
            .orderBy('timestamp', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
            );

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              var data = doc.data() as Map<String, dynamic>;
              List items = data['items'] ?? [];

              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFF1A1A1A),
                  border: Border.all(color: Colors.white12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Section Title Header
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xFFD4AF37),
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            data['sectionTitle'] ?? "SECTION",
                            style: const TextStyle(
                              color: Color(0xFFD4AF37),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          if (isAdmin)
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                    size: 20,
                                  ),
                                  onPressed: () => _showRateDialog(
                                    docId: doc.id,
                                    data: data,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  onPressed: () => doc.reference.delete(),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    // List of Items in Section
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      separatorBuilder: (context, i) => Divider(
                        color: Colors.white.withOpacity(0.05),
                        indent: 20,
                        endIndent: 20,
                      ),
                      itemBuilder: (context, i) {
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 5,
                          ),
                          title: Text(
                            items[i]['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          trailing: Text(
                            "Rs. ${items[i]['price']}",
                            style: const TextStyle(
                              color: Color(0xFFD4AF37),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // --- Helpers for Dialog Fields ---
  Widget _buildPopupField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: const TextStyle(color: Color(0xFFD4AF37), fontSize: 14),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFD4AF37)),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildSmallField({
    required Function(String) onChanged,
    required String hint,
    String? initialValue,
  }) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white24),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFD4AF37)),
        ),
      ),
    );
  }
}
