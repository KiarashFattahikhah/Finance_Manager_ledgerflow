import 'package:iconsax/iconsax.dart';
import '../models/category.dart';

const List<AppCategory> appCategories = [ 
  AppCategory("Food", Iconsax.cake),                 // food
  AppCategory("Groceries", Iconsax.shopping_cart),  // groceries
  AppCategory("Transport", Iconsax.car),            // transport
  AppCategory("Shopping", Iconsax.shopping_bag),    // shopping
  AppCategory("Bills", Iconsax.receipt),            // bills
  AppCategory("Salary", Iconsax.money),             // salary
  AppCategory("Health", Iconsax.health),            // health
  AppCategory("Education", Iconsax.book),           // education
  AppCategory("Travel", Iconsax.airplane),          // travel
  AppCategory("Entertainment", Iconsax.play),       // entertainment
  AppCategory("Home", Iconsax.home),                // home
  AppCategory("Pets", Iconsax.pet),                 // pets
  AppCategory("Gifts", Iconsax.gift),               // gifts
  AppCategory("Other", Iconsax.more),             // fallback
];
