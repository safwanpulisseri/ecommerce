import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/feature/home/view/page/home.dart';
import 'package:ecommerce/feature/favourite/view/page/favourite.dart';
import 'package:ecommerce/feature/cart/view/page/cart.dart';
import 'package:ecommerce/feature/profile/view/page/profile.dart';
import 'package:ecommerce/feature/navbar/bloc/bloc/navbar_bloc.dart';
import 'package:ecommerce/feature/cart/bloc/bloc/cart_bloc.dart';

class NavbarPage extends StatelessWidget {
  const NavbarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const NavbarView();
  }
}

class NavbarView extends StatelessWidget {
  const NavbarView({super.key});

  static const List<Widget> _pages = [
    HomePage(),
    FavouritePage(),
    CartPage(),
    ProfilePage(),
  ];

  Widget _buildCartIcon(bool isActive, int cartCount) {
    return Stack(
      children: [
        Icon(isActive ? Icons.shopping_cart : Icons.shopping_cart_outlined),
        if (cartCount > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white, width: 1),
              ),
              constraints: const BoxConstraints(
                minWidth: 14,
                minHeight: 14,
              ),
              child: Text(
                cartCount > 99 ? '99+' : cartCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavbarBloc, NavbarState>(
      builder: (context, state) {
        return Scaffold(
          body: IndexedStack(
            index: state.currentIndex,
            children: _pages,
          ),
          bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
            builder: (context, cartState) {
              int cartCount = 0;
              if (cartState is CartLoaded) {
                cartCount = cartState.totalItems;
              }

              return BottomNavigationBar(
                currentIndex: state.currentIndex,
                onTap: (index) {
                  context.read<NavbarBloc>().add(ChangeTabEvent(index));
                },
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,
                selectedItemColor: Colors.black,
                unselectedItemColor: Colors.grey,
                selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                ),
                items: [
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    activeIcon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.favorite_border),
                    activeIcon: Icon(Icons.favorite),
                    label: 'Favorites',
                  ),
                  BottomNavigationBarItem(
                    icon: _buildCartIcon(false, cartCount),
                    activeIcon: _buildCartIcon(true, cartCount),
                    label: 'Cart',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline),
                    activeIcon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
