import 'package:app/data/get_item.dart';
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
                            ? [Colors.grey[900]!, Colors.grey[800]!]
                            : [Colors.blue[900]!, Colors.blue[700]!],
                      ),
                    ),
                    child: _buildSideNavigation(isDesktop),
                  ),
                Expanded(
                  child: Column(
                    children: [
                      _buildAppBar(isMobile, isTablet, isDesktop),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(isMobile ? 12 : 24),
                          child: _buildPageContent(
                            isMobile,
                            isTablet,
                            isDesktop,
                          ),
                        ),
                      ),
                    ],
                  ),
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
                  leading: Icon(getIcon(index)),
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
        SizedBox(height: 40),
        Expanded(
          child: ListView.builder(
            itemCount: pages.length,
            itemBuilder: (context, index) {
              return _buildNavItem(
                icon: getIcon(index),
                label: pages[index],
                isSelected: _selectedIndex == index,
                isDesktop: isDesktop,
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              );
            },
          ),
        ),
        Divider(color: Colors.white24),
        _buildNavItem(
          icon: Icons.settings,
          label: 'Settings',
          isSelected: false,
          isDesktop: isDesktop,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required bool isDesktop,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        padding: EdgeInsets.symmetric(
          vertical: isDesktop ? 16 : 8,
          horizontal: 12,
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            if (isDesktop) ...[
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(bool isMobile, bool isTablet, bool isDesktop) {
    return Container(
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: _isDarkMode ? Colors.grey[800] : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (isMobile)
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  pages[_selectedIndex],
                  style: TextStyle(
                    fontSize: isMobile ? 20 : 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Welcome Back, Manuel Cardoso',
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (!isMobile) ...[
            Container(
              width: isDesktop ? 300 : 200,
              height: 40,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Pesquisar',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: _isDarkMode ? Colors.grey[800] : Colors.white,
                ),
              ),
            ),
            SizedBox(width: 16),
          ],
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_outlined),
          ),
          SizedBox(width: 8),
          IconButton(
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
          ),
          if (!isMobile) ...[
            SizedBox(width: 16),
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(
                'https://i.ibb.co/8gzs7C4g/woman.png',
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPageContent(bool isMobile, bool isTablet, bool isDesktop) {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardScreen(isMobile, isTablet, isDesktop);
      case 1:
        return _buildDefaultScreen();
      case 2:
        return _buildDefaultScreen();
      default:
        return _buildDefaultScreen();
    }
  }

  Widget _buildDashboardScreen(bool isMobile, bool isTablet, bool isDesktop) {
    int crossAxisCount = isMobile ? 2 : (isTablet ? 3 : 4);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: isMobile ? 1.2 : 1.4,
          children: [
            _buildStateCard(
              'Total de Vendas',
              '\$ 25.000',
              Icons.shopping_cart,
              Colors.blue,
              '+5.4',
            ),
            _buildStateCard(
              'Pedidos',
              '1.245',
              Icons.receipt_long,
              Colors.orange,
              '+5.4',
            ),
            _buildStateCard(
              'Clientes',
              '980',
              Icons.people,
              Colors.green,
              '+5.4',
            ),
            _buildStateCard(
              'Receita',
              '\$ 18.400',
              Icons.attach_money,
              Colors.purple,
              '+5.4',
            ),
          ],
        ),
        SizedBox(height: 24),
      ],
    );
  }

  /*Widget _buildAnalyticsScreen (){

  }*/

  Widget _buildStateCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String change,
  ) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    value,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Text(
              change,
              style: TextStyle(
                color: change.startsWith('+') ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultScreen() {
    return Container(
      color: Colors.red,
      child: Center(
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
              'Pagina em construção',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  /*IconData _getIcon(int index) {
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
  }*/
}
