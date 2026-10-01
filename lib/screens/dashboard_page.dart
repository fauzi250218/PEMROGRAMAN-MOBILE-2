import 'package:flutter/material.dart';
import 'login_page.dart';
import 'product_list/product_list_screen.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  void logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      // =========================
      // APP BAR
      // =========================

      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,

        elevation: 0,

        actions: [
          IconButton(
            tooltip: 'Logout',

            onPressed: () {
              showDialog(
                context: context,

                builder: (context) {
                  return AlertDialog(
                    title: const Text(
                      'Logout',
                    ),

                    content: const Text(
                      'Apakah kamu yakin ingin keluar?',
                    ),

                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },

                        child: const Text(
                          'Batal',
                        ),
                      ),

                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);

                          logout(context);
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),

                        child: const Text(
                          'Logout',
                        ),
                      ),
                    ],
                  );
                },
              );
            },

            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),

      // =========================
      // BODY
      // =========================

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            // =========================
            // WELCOME
            // =========================

            const Text(
              'Selamat Datang, Admin 👋',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Kelola data inventory melalui aplikasi ini.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 25),

            // =========================
            // PRODUCT CARD
            // =========================

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const ProductListScreen(),
                  ),
                );
              },

              child: Container(
                width: double.infinity,

                padding: const EdgeInsets.all(22),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(18),

                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),

                child: Row(
                  children: [

                    // ICON
                    Container(
                      width: 65,
                      height: 65,

                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,

                        borderRadius:
                            BorderRadius.circular(15),
                      ),

                      child: const Icon(
                        Icons.inventory_2,
                        size: 35,
                        color: Colors.blue,
                      ),
                    ),

                    const SizedBox(width: 18),

                    // TEXT
                    const Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [
                          Text(
                            'Products',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 5),

                          Text(
                            'Kelola data produk inventory',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ARROW
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // =========================
            // API CARD
            // =========================

            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(22),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(18),

                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),

              child: Row(
                children: [

                  Container(
                    width: 65,
                    height: 65,

                    decoration: BoxDecoration(
                      color: Colors.green.shade50,

                      borderRadius:
                          BorderRadius.circular(15),
                    ),

                    child: const Icon(
                      Icons.api,
                      size: 35,
                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(width: 18),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [
                        Text(
                          'REST API',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 5),

                        Text(
                          'Terhubung dengan BaaS',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}