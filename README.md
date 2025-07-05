# 🛒 E-Commerce Flutter App

A comprehensive Flutter e-commerce application with modern UI/UX, state management, and local storage capabilities.

## 🌐 API Integration

This project uses the **[Fake Store API](https://fakestoreapi.com)** for fetching product data, including:
- Product listings with pagination
- Product details (title, description, price, images, categories)
- Categories: Men's clothing, Women's clothing, Jewelry, Electronics

## ✨ Features Implemented

### 🎯 **Core Features**
- ✅ **Splash Screen** - Animated splash with app branding and data preloading
- ✅ **Product Catalog** - Grid view of products with real-time API data
- ✅ **Product Details** - Detailed product view with images and descriptions
- ✅ **Shopping Cart** - Full CRUD operations with quantity management
- ✅ **Favorites System** - Add/remove products to/from favorites
- ✅ **User Profile** - Account information and app settings

### 🔍 **Search & Navigation**
- ✅ **Real-time Search** - Search across product title, description, and category
- ✅ **Category Filtering** - Filter products by category (All, Men's, Women's, etc.)
- ✅ **Bottom Navigation** - 4-tab navigation (Home, Favorites, Cart, Profile)
- ✅ **Smart Navigation** - Cart icon switches to cart tab maintaining navbar

### 📱 **User Experience**
- ✅ **Shimmer Loading** - Professional skeleton loading animations
- ✅ **Pagination** - Load 10 products initially, infinite scroll for more
- ✅ **Empty States** - Meaningful messages for empty cart/favorites
- ✅ **Loading States** - Progress indicators and loading feedback
- ✅ **Error Handling** - Graceful error handling with retry options

### 🎨 **Design & Theming**
- ✅ **Structured Color System** - Centralized color management with AppColor
- ✅ **Premium Theme** - Clean black and white design language
- ✅ **Consistent Styling** - Unified styling across all components
- ✅ **Responsive Design** - Adaptive layouts for different screen sizes

### 🏗️ **Architecture & State Management**
- ✅ **BLoC Pattern** - Complete state management with flutter_bloc
- ✅ **Repository Pattern** - Clean architecture with data repositories
- ✅ **Event-Driven** - Reactive programming with events and states
- ✅ **Separation of Concerns** - Clear separation between UI, business logic, and data

### 💾 **Data Management**
- ✅ **Hive Local Storage** - Persistent storage for cart and favorites
- ✅ **API Integration** - RESTful API calls with Dio HTTP client
- ✅ **Real-time Updates** - Live cart count badges and state synchronization
- ✅ **Data Persistence** - Cart and favorites persist across app restarts

### 🛠️ **Additional Features**
- ✅ **Add to Cart** - Add products with automatic quantity management
- ✅ **Cart Operations** - Increase/decrease quantity, remove items
- ✅ **Checkout Process** - Complete purchase flow with success feedback
- ✅ **Favorites Toggle** - Heart icon to add/remove favorites
- ✅ **Search Clear** - Clear search with X button
- ✅ **Badge Counters** - Real-time cart count display

## 📁 Project Structure

\`\`\`
lib/
├── 🎯 core/
│   └── theme/
│       ├── app_theme.dart           # Centralized app theming
│       └── color/
│           └── app_color.dart       # Structured color system
│
├── 🏠 feature/
│   ├── splash/
│   │   └── view/
│   │       └── splash_screen.dart   # Animated splash screen
│   │
│   ├── home/
│   │   ├── data/
│   │   │   ├── model/
│   │   │   │   └── product_model.dart      # Product data model
│   │   │   ├── repository/
│   │   │   │   └── product_repo.dart       # Product repository
│   │   │   └── service/
│   │   │       └── remote/
│   │   │           └── product_remote.dart # API service
│   │   ├── bloc/
│   │   │   └── bloc/
│   │   │       ├── product_bloc.dart       # Product state management
│   │   │       ├── product_event.dart      # Product events
│   │   │       └── product_state.dart      # Product states
│   │   └── view/
│   │       └── page/
│   │           └── home.dart               # Home page with products
│   │
│   ├── product_detail/
│   │   └── page/
│   │       └── view/
│   │           └── product_details.dart    # Product details page
│   │
│   ├── cart/
│   │   ├── data/
│   │   │   ├── model/
│   │   │   │   └── cart_model.dart         # Cart item model
│   │   │   └── repository/
│   │   │       └── local/
│   │   │           └── cart_repository.dart # Hive cart storage
│   │   ├── bloc/
│   │   │   └── bloc/
│   │   │       ├── cart_bloc.dart          # Cart state management
│   │   │       ├── cart_event.dart         # Cart events
│   │   │       └── cart_state.dart         # Cart states
│   │   └── view/
│   │       └── page/
│   │           └── cart.dart               # Shopping cart page
│   │
│   ├── favourite/
│   │   ├── data/
│   │   │   └── repository/
│   │   │       └── local/
│   │   │           └── favourite_repository.dart # Hive favorites storage
│   │   ├── bloc/
│   │   │   └── bloc/
│   │   │       ├── favorite_bloc.dart      # Favorites state management
│   │   │       ├── favorite_event.dart     # Favorites events
│   │   │       └── favorite_state.dart     # Favorites states
│   │   └── view/
│   │       └── page/
│   │           └── favourite.dart          # Favorites page
│   │
│   ├── profile/
│   │   └── view/
│   │       └── page/
│   │           └── profile.dart            # User profile page
│   │
│   └── navbar/
│       ├── bloc/
│       │   └── bloc/
│       │       ├── navbar_bloc.dart        # Navigation state management
│       │       ├── navbar_event.dart       # Navigation events
│       │       └── navbar_state.dart       # Navigation states
│       └── page/
│           └── navbar.dart                 # Bottom navigation
│
├── 🚀 app.dart                             # App configuration with providers
├── 📱 app_view.dart                        # Main app view with theme
└── 🎯 main.dart                           # App entry point with Hive init
\`\`\`

## 🏛️ Architecture Overview

\`\`\`
┌─────────────────────────────────────────────────────────────────┐
│                          PRESENTATION LAYER                     │
├─────────────────────────────────────────────────────────────────┤
│  Splash Screen  │  Home Page  │  Product Details  │  Cart Page  │
│  Favorites Page │  Profile    │  Bottom Navigation               │
└─────────────────┬───────────────────────────────────────────────┘
                  │
┌─────────────────▼───────────────────────────────────────────────┐
│                        BUSINESS LOGIC LAYER                     │
├─────────────────────────────────────────────────────────────────┤
│  ProductBloc  │  CartBloc  │  FavoriteBloc  │  NavbarBloc      │
│  Events       │  States    │  BLoC Pattern                     │
└─────────────────┬───────────────────────────────────────────────┘
                  │
┌─────────────────▼───────────────────────────────────────────────┐
│                          DATA LAYER                             │
├─────────────────────────────────────────────────────────────────┤
│  Repositories  │  API Services  │  Local Storage (Hive)         │
│  Product Repo  │  Fake Store    │  Cart & Favorites Storage     │
└─────────────────────────────────────────────────────────────────┘
\`\`\`

## 🛠️ Tech Stack

| Category | Technology |
|----------|------------|
| **Framework** | Flutter |
| **Language** | Dart |
| **State Management** | BLoC Pattern (flutter_bloc) |
| **Local Storage** | Hive |
| **HTTP Client** | Dio |
| **API** | Fake Store API |
| **Animations** | Shimmer, Custom Animations |
| **Architecture** | Clean Architecture with Repository Pattern |

## 📦 Dependencies

\`\`\`yaml
dependencies:
  flutter_bloc: ^9.1.1      # State management
  equatable: ^2.0.5         # Value equality
  dio: ^5.8.0               # HTTP client
  hive: ^2.2.3              # Local storage
  hive_flutter: ^1.1.0      # Hive Flutter integration
  shimmer: ^3.0.0           # Loading animations

dev_dependencies:
  hive_generator: ^2.0.1    # Hive code generation
  build_runner: ^2.4.7      # Build system
\`\`\`

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.6.1 or higher)
- Dart SDK
- Android Studio / VS Code
- Android/iOS Emulator or Physical Device

### Installation

1. **Clone the repository**
   \`\`\`bash
   git clone <repository-url>
   cd ecommerce
   \`\`\`

2. **Install dependencies**
   \`\`\`bash
   flutter pub get
   \`\`\`

3. **Generate Hive adapters**
   \`\`\`bash
   flutter packages pub run build_runner build
   \`\`\`

4. **Run the application**
   \`\`\`bash
   flutter run
   \`\`\`

## 📱 Screenshots

The app features a modern, clean design with:
- Premium black and white color scheme
- Smooth animations and transitions
- Intuitive navigation and user interactions
- Professional loading states and empty states

## 🎯 Future Enhancements

- [ ] User authentication and registration
- [ ] Order history and tracking
- [ ] Push notifications
- [ ] Payment gateway integration
- [ ] Product reviews and ratings
- [ ] Wishlist sharing
- [ ] Dark mode theme
- [ ] Multi-language support

## 🤝 Contributing

1. Fork the project
2. Create your feature branch (\`git checkout -b feature/AmazingFeature\`)
3. Commit your changes (\`git commit -m 'Add some AmazingFeature'\`)
4. Push to the branch (\`git push origin feature/AmazingFeature\`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Fake Store API](https://fakestoreapi.com) for providing the product data
- Flutter team for the amazing framework
- BLoC library for state management
- Hive for efficient local storage
