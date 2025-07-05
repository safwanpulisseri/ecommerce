import 'package:ecommerce/app_view.dart';
import 'package:ecommerce/feature/cart/bloc/bloc/cart_bloc.dart';
import 'package:ecommerce/feature/cart/data/repository/local/cart_repository.dart';
import 'package:ecommerce/feature/favourite/bloc/bloc/favorite_bloc.dart';
import 'package:ecommerce/feature/favourite/data/repository/local/favourite_repository.dart';
import 'package:ecommerce/feature/home/bloc/bloc/product_bloc.dart';
import 'package:ecommerce/feature/home/data/repository/product_repo.dart';
import 'package:ecommerce/feature/home/data/service/remote/product_remote.dart';
import 'package:ecommerce/feature/navbar/bloc/bloc/navbar_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => ProductRepo(ProductRemoteService()),
        ),
        RepositoryProvider(
          create: (context) => CartRepository(),
        ),
        RepositoryProvider(
          create: (context) => FavoriteRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => NavbarBloc(),
          ),
          BlocProvider(
            create: (context) => ProductBloc(context.read<ProductRepo>()),
          ),
          BlocProvider(
            create: (context) => CartBloc(context.read<CartRepository>()),
          ),
          BlocProvider(
            create: (context) =>
                FavoriteBloc(context.read<FavoriteRepository>()),
          ),
        ],
        child: const MyAppView(),
      ),
    );
  }
}
