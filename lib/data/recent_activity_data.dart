import 'package:flutter/material.dart';
import '../models/recent_activity.dart';

final List<RecentActivity> recentActivities = [
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
