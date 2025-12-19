import 'package:app/data/get_item.dart';
import 'package:app/data/weekly_chart_data.dart';
import 'package:app/widgets/charts/chart_painter.dart';
import 'package:flutter/material.dart';
import 'package:app/data/pages.dart';
import 'package:app/data/recent_activity_data.dart';
import 'package:app/data/top_products_data.dart';
import 'package:app/widgets/default_screen.dart';
import 'package:app/widgets/top_products_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  bool _isDarkMode = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
                        child: Container(
                          color: _isDarkMode
                              ? Colors.grey[800]
                              : Colors.grey[100],
                          child: SingleChildScrollView(
                            padding: EdgeInsets.all(isMobile ? 12 : 24),
                            child: _buildPageContent(
                              isMobile,
                              isTablet,
                              isDesktop,
                            ),
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
            accountName: Text('Fulana de Tal'),
            accountEmail: Text("fulana@gmail.com"),
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
            'Fulana de Tal',
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
            color: Colors.white.withAlpha((0.05 * 255).round()),
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
                  'Bem-vindo(a) de volta, Fulana de Tal',
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
        return DefaultScreen();
      case 2:
        return DefaultScreen();
      default:
        return DefaultScreen();
    }
  }

  Widget _buildRevenueChart(bool isMobile, bool isTablet, bool isDesktop) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isDarkMode ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: _isDarkMode
                ? Colors.black.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Revenue Chart',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Container(
            height: isMobile ? 200 : 300,
            child: Center(
              child: CustomPaint(
                painter: ChartPainter(weeklyChartData),
                child: Container(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivites() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isDarkMode ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: _isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Actividade recente',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 18),
          ...recentActivities.map((act) {
            return Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: act.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(act.icon, color: act.color, size: 20),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          act.title,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          act.subtitle,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    act.time,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
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
          childAspectRatio: isMobile
              ? 1.2
              : isTablet
              ? 1.5
              : 1.7,
          children: [
            _buildStateCard(
              'Total de Vendas',
              '\$ 25.000',
              Icons.shopping_cart,
              Colors.blue,
              '+5.4',
              _isDarkMode,
            ),
            _buildStateCard(
              'Pedidos',
              '\$1.245',
              Icons.receipt_long,
              Colors.orange,
              '-1.4',
              _isDarkMode,
            ),
            _buildStateCard(
              'Clientes',
              '\$980',
              Icons.people,
              Colors.green,
              '+5.4',
              _isDarkMode,
            ),
            _buildStateCard(
              'Receita',
              '\$ 18.400',
              Icons.attach_money,
              Colors.purple,
              '-2.4',
              _isDarkMode,
            ),
          ],
        ),
        SizedBox(height: 24),
        if (isDesktop)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    _buildRevenueChart(isMobile, isTablet, isDesktop),
                    SizedBox(height: 16),
                    TopProductsCard(
                      isDarkMode: _isDarkMode,
                      products: topProducts,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Expanded(flex: 1, child: _buildRecentActivites()),
            ],
          )
        else ...[
          _buildRevenueChart(isMobile, isTablet, isDesktop),
          SizedBox(height: 16),
          _buildRecentActivites(),
          SizedBox(height: 24),
          TopProductsCard(isDarkMode: _isDarkMode, products: topProducts),
        ],
      ],
    );
  }

  Widget _buildStateCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String change,
    bool isDarkMode,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.2)
                : Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 24),
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
            Spacer(),
            Text(
              value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
