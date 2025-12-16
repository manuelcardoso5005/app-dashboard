import 'package:app/models/chart_data.dart';
import 'package:app/models/product.dart';
import 'package:app/models/recent_activity.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  bool _isDarkMode = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> pages = [
    'Dashboard',
    'Analytics',
    'Products',
    'Orders',
    'Customers',
    'Settings',
    'Profile',
  ];

  /*final List<ChartData> _chartData = [
    ChartData('Jan', 30),
    ChartData('Fev', 42),
    ChartData('Mar', 54),
    ChartData('Abr', 20),
    ChartData('Mai', 76),
    ChartData('Jun', 35),
    ChartData('Jul', 90),
    ChartData('Ago', 45),
    ChartData('Set', 60),
    ChartData('Oct', 80),
    ChartData('Nov', 55),
    ChartData('Dez', 70),
  ];*/

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
      child: Scaffold(key: _scaffoldKey, drawer: _buildDrawer(context)),
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
          ),
        ],
      ),
    );
  }
}
