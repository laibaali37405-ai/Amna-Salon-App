import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DealsPage extends StatefulWidget {
  final String branchName;
  const DealsPage({super.key, required this.branchName});

  @override
  State<DealsPage> createState() => _DealsPageState();
}

class _DealsPageState extends State<DealsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool get isAdmin => widget.branchName == "ADMIN_MODE";

  void _launchWhatsApp(String dealTitle, String price) async {
    String phoneNumber = widget.branchName.toUpperCase().contains("RAWALPINDI")
        ? "923329458823"
        : "923324254790";

    String message =
        "Hello AMNA! I want to book *$dealTitle* (Rs. $price) from the *${widget.branchName}* branch.";
    var url = "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}";
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  // --- Admin Section Management ---
  void _showSectionDialog({String? docId, Map<String, dynamic>? data}) {
    TextEditingController sectionTitleController = TextEditingController(
      text: data?['sectionTitle'] ?? "",
    );

    // Multiple deals ke liye list
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
            docId == null ? "ADD SECTION" : "EDIT SECTION",
            style: const TextStyle(color: Color(0xFFD4AF37)),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildPopupField(
                    sectionTitleController,
                    "Section Name (e.g. HAIR DEALS)",
                  ),
                  const Divider(color: Color(0xFFD4AF37)),
                  ...items.asMap().entries.map((entry) {
                    int idx = entry.key;
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildSmallField(
                                onChanged: (v) => items[idx]['name'] = v,
                                hint: "Deal Name",
                                initialValue: items[idx]['name'],
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: _buildSmallField(
                                onChanged: (v) => items[idx]['price'] = v,
                                hint: "Price",
                                initialValue: items[idx]['price'],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 20,
                              ),
                              onPressed: () {
                                if (items.length > 1)
                                  setDialogState(() => items.removeAt(idx));
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  }).toList(),
                  TextButton.icon(
                    onPressed: () => setDialogState(
                      () => items.add({"name": "", "price": ""}),
                    ),
                    icon: const Icon(
                      Icons.add_circle,
                      color: Color(0xFFD4AF37),
                    ),
                    label: const Text(
                      "ADD MORE DEALS",
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
                Map<String, dynamic> finalData = {
                  "sectionTitle": sectionTitleController.text,
                  "items": items,
                  "timestamp": FieldValue.serverTimestamp(),
                };
                docId == null
                    ? await _firestore.collection('deals_v2').add(finalData)
                    : await _firestore
                          .collection('deals_v2')
                          .doc(docId)
                          .update(finalData);
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
          "EXCLUSIVE DEALS",
          style: TextStyle(
            color: Color(0xFFD4AF37),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Color(0xFFD4AF37)),
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              backgroundColor: const Color(0xFFD4AF37),
              onPressed: () => _showSectionDialog(),
              child: const Icon(Icons.add, color: Colors.black),
            )
          : null,
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('deals_v2')
            .orderBy('timestamp', descending: true)
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
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color(0xFFD4AF37), width: 1),
                  color: Colors.white.withOpacity(0.05),
                ),
                child: Column(
                  children: [
                    // Section Header
                    Container(
                      padding: const EdgeInsets.all(12),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD4AF37),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(14),
                          topRight: Radius.circular(14),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            data['sectionTitle'].toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (isAdmin)
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 20),
                                  onPressed: () => _showSectionDialog(
                                    docId: doc.id,
                                    data: data,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    size: 20,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => doc.reference.delete(),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    // Inner Deals List
                    ...items
                        .map(
                          (item) => ListTile(
                            title: Text(
                              item['name'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              "Rs. ${item['price']}",
                              style: const TextStyle(color: Color(0xFFD4AF37)),
                            ),
                            trailing: !isAdmin
                                ? ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFD4AF37),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                    ),
                                    onPressed: () => _launchWhatsApp(
                                      item['name'],
                                      item['price'],
                                    ),
                                    child: const Text(
                                      "BOOK",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        )
                        .toList(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildPopupField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFD4AF37)),
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
        isDense: true,
      ),
    );
  }
}
