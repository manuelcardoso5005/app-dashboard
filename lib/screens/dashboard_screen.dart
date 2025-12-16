import 'package:app/models/chart_model.dart';
import 'package:app/models/product.dart';
import 'package:app/models/recent_activity.dart';
import 'package:flutter/material.dart';
import 'package:app/data/pages.dart';
import 'package:flutter/rendering.dart';
//import 'package:flutter/rendering.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  bool _isDarkMode = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<ChartData> _chartData = [
    ChartData('Seg', 45, 30),
    ChartData('Ter', 56, 40),
    ChartData('Qua', 55, 35),
    ChartData('Qui', 60, 50),
    ChartData('Sex', 61, 60),
    ChartData('Sab', 70, 65),
    ChartData('Dom', 75, 70),
  ];

  final List<RecentActivity> _recentActivites = [
    RecentActivity(
      'Novo Pedido Recebido',
      '#ORD-12345',
      '2 min atrás',
      Icons.shopping_cart,
      Colors.blue,
    ),
    RecentActivity(
      'Pagamento Confirmado',
      '#PAY-98765',
      '10 min atrás',
      Icons.check_circle,
      Colors.green,
    ),
    RecentActivity(
      'Pedido Enviado',
      '#ORD-12344',
      '1 hora atrás',
      Icons.local_shipping,
      Colors.orange,
    ),
    RecentActivity(
      'Cliente Registrado',
      '#USR-54321',
      '3 horas atrás',
      Icons.person_add,
      Colors.purple,
    ),
    RecentActivity(
      'Produto Atualizado',
      '#PRD-67890',
      'Ontem',
      Icons.update,
      Colors.teal,
    ),
  ];

  final List<Product> _topProduct = [
    Product(
      'iPhone 12',
      '\$ 999',
      150,
      'https://loja.iservices.pt/10628-large_default/iphone-12.jpg',
    ),
    Product(
      'Samsung Galaxy S21',
      '\$ 899',
      120,
      'https://image.coolblue.be/max/394xauto/products/1857219',
    ),
    Product(
      'MacBook Air M1',
      '\$ 1199',
      80,
      'https://cdsassets.apple.com/live/SZLF0YNV/images/sp/111883_macbookair.png',
    ),
    Product(
      'Apple Watch Series 6',
      '\$ 399',
      200,
      'https://cdn11.bigcommerce.com/s-ilhtqzrn07/images/stencil/1280x1280/products/731/983/watch540__16988.1571652005.1280.1280__62666.1602607987.jpg?c=1',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        key: _scaffoldKey,
        drawer: _buildDrawer(context),
        body: LayoutBuilder(
          builder: (context, constraints) {
            bool isMobile = constraints.maxWidth < 600;
            bool isTablet =
                constraints.maxWidth >= 601 && constraints.maxWidth < 900;
            bool isDesktop = constraints.maxWidth >= 900;
            return Row(
              children: [
                if (!isMobile)
                  Container(
                    width: isDesktop ? 260 : 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: _isDarkMode
                            ? [Colors.grey[900]!, Colors.grey[850]!]
                            : [Colors.blue[900]!, Colors.blue[750]!],
                      ),
                    ),
                    child: _buildSideNavigation(isDesktop),
                  ),
              ],
            );
          },
        ),
        bottomNavigationBar: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return BottomNavigationBar(
                currentIndex: _selectedIndex.clamp(0, 3),
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.blue[700],
                unselectedItemColor: Colors.grey,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard),
                    label: 'Dashboard',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.analytics),
                    label: 'Analytics',
                  ),

                  BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_bag),
                    label: 'Products',
                  ),

                  BottomNavigationBarItem(
                    icon: Icon(Icons.more_horiz),
                    label: 'More',
                  ),
                ],
              );
            }
            return SizedBox.shrink();
          },
        ),
        floatingActionButton: _selectedIndex == 0
            ? FloatingActionButton.extended(
                onPressed: () {},
                label: Text("Novo Pedido"),
                icon: Icon(Icons.add),
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
              )
            : null,
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[900]!, Colors.blue[700]!],
              ),
            ),
            accountName: Text('Manuel Cardoso'),
            accountEmail: Text("manuelcardoso@gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://i.ibb.co/8gzs7C4g/woman.png',
              ),
            ),
          ),
          // Lista de páginas do menu
          Expanded(
            child: ListView.builder(
              itemCount: pages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(_getIcon(index)),
                  title: Text(pages[index]),
                  selected: _selectedIndex == index,
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          Divider(),
          SwitchListTile(
            title: Text('Dark Mode'),
            secondary: Icon(Icons.dark_mode),
            value: _isDarkMode,
            onChanged: (value) {
              setState(() {
                _isDarkMode = value;
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sair'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSideNavigation(bool isDesktop) {
    return Column(
      children: [
        SizedBox(height: 30),
        Container(
          padding: EdgeInsets.all(10),
          child: CircleAvatar(
            radius: isDesktop ? 40 : 25,
            backgroundImage: NetworkImage(
              'https://i.ibb.co/8gzs7C4g/woman.png',
            ),
          ),
        ),
        if (isDesktop) ...[
          SizedBox(height: 10),
          Text(
            'Manuel Cardoso',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text('Admn', style: TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ],
    );
  }

  Widget _buildDefaultScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction,
            size: 100,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(height: 20),
          Text(
            'Oagina em construção',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(int index) {
    final icons = [
      Icons.dashboard,
      Icons.analytics,
      Icons.shopping_bag,
      Icons.receipt_long,
      Icons.people,
      Icons.settings,
      Icons.person,
    ];
    return icons[index];
  }
}
