import '../models/product.dart';

/// Mock catalog spanning all 23 categories. Several product types are
/// deliberately offered by more than one brand (e.g. Running Shoes by both
/// Nike and Adidas) so brand-vs-brand comparison shows up naturally in the
/// list. Prices are realistic ballpark MRPs in ₹; per-platform variation is
/// layered on top in mock_price_offers.dart.
const List<Product> mockProducts = [
  // Electronics
  Product(id: 'boat_headphones', categoryId: 'electronics', brand: 'boAt', name: 'Wireless Headphones', unit: '1 pc', emoji: '🎧', basePrice: 1999),
  Product(id: 'sony_headphones', categoryId: 'electronics', brand: 'Sony', name: 'Wireless Headphones', unit: '1 pc', emoji: '🎧', basePrice: 8990),
  Product(id: 'mi_power_bank', categoryId: 'electronics', brand: 'Mi', name: 'Power Bank 10000 mAh', unit: '1 pc', emoji: '🔋', basePrice: 1299),
  Product(id: 'samsung_smart_tv', categoryId: 'electronics', brand: 'Samsung', name: '43" Smart TV', unit: '1 pc', emoji: '📺', basePrice: 28990),
  Product(id: 'jbl_speaker', categoryId: 'electronics', brand: 'JBL', name: 'Bluetooth Speaker', unit: '1 pc', emoji: '🔊', basePrice: 2999),

  // Health & Personal Care
  Product(id: 'dettol_handwash', categoryId: 'health_personal_care', brand: 'Dettol', name: 'Hand Wash', unit: '250 ml', emoji: '🧼', basePrice: 99),
  Product(id: 'colgate_toothpaste', categoryId: 'health_personal_care', brand: 'Colgate', name: 'Toothpaste', unit: '150 g', emoji: '🪥', basePrice: 60),
  Product(id: 'sensodyne_toothpaste', categoryId: 'health_personal_care', brand: 'Sensodyne', name: 'Toothpaste', unit: '150 g', emoji: '🪥', basePrice: 135),
  Product(id: 'himalaya_face_wash', categoryId: 'health_personal_care', brand: 'Himalaya', name: 'Face Wash', unit: '150 ml', emoji: '🧴', basePrice: 165),
  Product(id: 'nivea_body_lotion', categoryId: 'health_personal_care', brand: 'Nivea', name: 'Body Lotion', unit: '400 ml', emoji: '🧴', basePrice: 349),

  // Home Improvement
  Product(id: 'philips_led_bulb', categoryId: 'home_improvement', brand: 'Philips', name: 'LED Bulb 9W', unit: '1 pc', emoji: '💡', basePrice: 149),
  Product(id: 'wipro_led_bulb', categoryId: 'home_improvement', brand: 'Wipro', name: 'LED Bulb 9W', unit: '1 pc', emoji: '💡', basePrice: 119),
  Product(id: 'bosch_drill', categoryId: 'home_improvement', brand: 'Bosch', name: 'Cordless Drill', unit: '1 pc', emoji: '🛠️', basePrice: 4499),
  Product(id: 'stanley_toolkit', categoryId: 'home_improvement', brand: 'Stanley', name: 'Tool Kit 42 pcs', unit: '1 set', emoji: '🧰', basePrice: 2799),
  Product(id: 'asian_paints_wall_paint', categoryId: 'home_improvement', brand: 'Asian Paints', name: 'Wall Paint', unit: '1 L', emoji: '🎨', basePrice: 425),

  // Computers & Accessories
  Product(id: 'logitech_mouse', categoryId: 'computers_accessories', brand: 'Logitech', name: 'Wireless Mouse', unit: '1 pc', emoji: '🖱️', basePrice: 995),
  Product(id: 'hp_mouse', categoryId: 'computers_accessories', brand: 'HP', name: 'Wireless Mouse', unit: '1 pc', emoji: '🖱️', basePrice: 649),
  Product(id: 'dell_keyboard', categoryId: 'computers_accessories', brand: 'Dell', name: 'Wired Keyboard', unit: '1 pc', emoji: '⌨️', basePrice: 799),
  Product(id: 'sandisk_ssd', categoryId: 'computers_accessories', brand: 'SanDisk', name: 'Portable SSD 1 TB', unit: '1 pc', emoji: '💾', basePrice: 6499),
  Product(id: 'tplink_router', categoryId: 'computers_accessories', brand: 'TP-Link', name: 'Wi-Fi Router', unit: '1 pc', emoji: '📡', basePrice: 1899),

  // Shoes
  Product(id: 'nike_running_shoes', categoryId: 'shoes', brand: 'Nike', name: 'Running Shoes', unit: '1 pair', emoji: '👟', basePrice: 4995),
  Product(id: 'adidas_running_shoes', categoryId: 'shoes', brand: 'Adidas', name: 'Running Shoes', unit: '1 pair', emoji: '👟', basePrice: 4599),
  Product(id: 'puma_sneakers', categoryId: 'shoes', brand: 'Puma', name: 'Sneakers', unit: '1 pair', emoji: '👟', basePrice: 3299),
  Product(id: 'bata_formal_shoes', categoryId: 'shoes', brand: 'Bata', name: 'Formal Shoes', unit: '1 pair', emoji: '👞', basePrice: 1999),

  // Sports, Fitness & Outdoors
  Product(id: 'yonex_racquet', categoryId: 'sports_fitness_outdoors', brand: 'Yonex', name: 'Badminton Racquet', unit: '1 pc', emoji: '🏸', basePrice: 1850),
  Product(id: 'cosco_football', categoryId: 'sports_fitness_outdoors', brand: 'Cosco', name: 'Football', unit: '1 pc', emoji: '⚽', basePrice: 899),
  Product(id: 'boldfit_yoga_mat', categoryId: 'sports_fitness_outdoors', brand: 'Boldfit', name: 'Yoga Mat', unit: '6 mm', emoji: '🧘', basePrice: 799),
  Product(id: 'domyos_dumbbells', categoryId: 'sports_fitness_outdoors', brand: 'Domyos', name: 'Dumbbell Set', unit: '10 kg', emoji: '🏋️', basePrice: 1499),

  // Home & Kitchen
  Product(id: 'prestige_cooker', categoryId: 'home_kitchen', brand: 'Prestige', name: 'Pressure Cooker 5 L', unit: '1 pc', emoji: '🍲', basePrice: 2195),
  Product(id: 'hawkins_cooker', categoryId: 'home_kitchen', brand: 'Hawkins', name: 'Pressure Cooker 5 L', unit: '1 pc', emoji: '🍲', basePrice: 1985),
  Product(id: 'philips_mixer', categoryId: 'home_kitchen', brand: 'Philips', name: 'Mixer Grinder', unit: '750 W', emoji: '🥣', basePrice: 3995),
  Product(id: 'milton_bottle', categoryId: 'home_kitchen', brand: 'Milton', name: 'Thermosteel Bottle', unit: '1 L', emoji: '🍶', basePrice: 745),
  Product(id: 'borosil_glass_set', categoryId: 'home_kitchen', brand: 'Borosil', name: 'Glass Set', unit: '6 pcs', emoji: '🥃', basePrice: 549),

  // Grocery & Gourmet Food
  Product(id: 'tata_salt', categoryId: 'grocery_gourmet', brand: 'Tata', name: 'Iodised Salt', unit: '1 kg', emoji: '🧂', basePrice: 28),
  Product(id: 'aashirvaad_atta', categoryId: 'grocery_gourmet', brand: 'Aashirvaad', name: 'Whole Wheat Atta', unit: '5 kg', emoji: '🌾', basePrice: 245),
  Product(id: 'fortune_oil', categoryId: 'grocery_gourmet', brand: 'Fortune', name: 'Sunflower Oil', unit: '1 L', emoji: '🛢️', basePrice: 139),
  Product(id: 'amul_butter', categoryId: 'grocery_gourmet', brand: 'Amul', name: 'Butter', unit: '500 g', emoji: '🧈', basePrice: 275),
  Product(id: 'daawat_basmati', categoryId: 'grocery_gourmet', brand: 'Daawat', name: 'Basmati Rice', unit: '1 kg', emoji: '🍚', basePrice: 189),
  Product(id: 'india_gate_basmati', categoryId: 'grocery_gourmet', brand: 'India Gate', name: 'Basmati Rice', unit: '1 kg', emoji: '🍚', basePrice: 210),

  // Clothing & Accessories
  Product(id: 'levis_jeans', categoryId: 'clothing_accessories', brand: "Levi's", name: 'Slim Fit Jeans', unit: '1 pc', emoji: '👖', basePrice: 2999),
  Product(id: 'allen_solly_shirt', categoryId: 'clothing_accessories', brand: 'Allen Solly', name: 'Casual Shirt', unit: '1 pc', emoji: '👔', basePrice: 1499),
  Product(id: 'jockey_tshirt', categoryId: 'clothing_accessories', brand: 'Jockey', name: 'Cotton T-Shirt', unit: '1 pc', emoji: '👕', basePrice: 649),
  Product(id: 'wildcraft_cap', categoryId: 'clothing_accessories', brand: 'Wildcraft', name: 'Baseball Cap', unit: '1 pc', emoji: '🧢', basePrice: 499),

  // Beauty
  Product(id: 'lakme_lipstick', categoryId: 'beauty', brand: 'Lakmé', name: 'Matte Lipstick', unit: '1 pc', emoji: '💄', basePrice: 399),
  Product(id: 'maybelline_lipstick', categoryId: 'beauty', brand: 'Maybelline', name: 'Matte Lipstick', unit: '1 pc', emoji: '💄', basePrice: 449),
  Product(id: 'loreal_shampoo', categoryId: 'beauty', brand: "L'Oréal", name: 'Shampoo', unit: '340 ml', emoji: '🧴', basePrice: 349),
  Product(id: 'plum_serum', categoryId: 'beauty', brand: 'Plum', name: 'Vitamin C Serum', unit: '30 ml', emoji: '✨', basePrice: 599),

  // Watches
  Product(id: 'titan_analog_watch', categoryId: 'watches', brand: 'Titan', name: 'Analog Watch', unit: '1 pc', emoji: '⌚', basePrice: 3495),
  Product(id: 'casio_gshock', categoryId: 'watches', brand: 'Casio', name: 'G-Shock', unit: '1 pc', emoji: '⌚', basePrice: 7995),
  Product(id: 'noise_smartwatch', categoryId: 'watches', brand: 'Noise', name: 'Smartwatch', unit: '1 pc', emoji: '⌚', basePrice: 2499),
  Product(id: 'boat_smartwatch', categoryId: 'watches', brand: 'boAt', name: 'Smartwatch', unit: '1 pc', emoji: '⌚', basePrice: 1799),

  // Car & Motorbike
  Product(id: 'castrol_engine_oil', categoryId: 'car_motorbike', brand: 'Castrol', name: 'Engine Oil', unit: '1 L', emoji: '🛢️', basePrice: 449),
  Product(id: 'studds_helmet', categoryId: 'car_motorbike', brand: 'Studds', name: 'Riding Helmet', unit: '1 pc', emoji: '⛑️', basePrice: 1249),
  Product(id: 'vega_helmet', categoryId: 'car_motorbike', brand: 'Vega', name: 'Riding Helmet', unit: '1 pc', emoji: '⛑️', basePrice: 1399),
  Product(id: 'bosch_wipers', categoryId: 'car_motorbike', brand: 'Bosch', name: 'Wiper Blades', unit: '1 pair', emoji: '🚗', basePrice: 649),
  Product(id: '3m_car_shampoo', categoryId: 'car_motorbike', brand: '3M', name: 'Car Shampoo', unit: '500 ml', emoji: '🧽', basePrice: 375),

  // Toys & Games
  Product(id: 'lego_classic', categoryId: 'toys_games', brand: 'LEGO', name: 'Classic Brick Box', unit: '484 pcs', emoji: '🧱', basePrice: 2499),
  Product(id: 'hotwheels_5pack', categoryId: 'toys_games', brand: 'Hot Wheels', name: 'Cars 5-Pack', unit: '5 pcs', emoji: '🏎️', basePrice: 549),
  Product(id: 'funskool_monopoly', categoryId: 'toys_games', brand: 'Funskool', name: 'Monopoly', unit: '1 set', emoji: '🎲', basePrice: 799),
  Product(id: 'nerf_blaster', categoryId: 'toys_games', brand: 'Nerf', name: 'Elite Blaster', unit: '1 pc', emoji: '🎯', basePrice: 1299),

  // Musical Instruments
  Product(id: 'yamaha_guitar', categoryId: 'musical_instruments', brand: 'Yamaha', name: 'Acoustic Guitar', unit: '1 pc', emoji: '🎸', basePrice: 9990),
  Product(id: 'juarez_ukulele', categoryId: 'musical_instruments', brand: 'Juarez', name: 'Ukulele', unit: '1 pc', emoji: '🪕', basePrice: 1899),
  Product(id: 'casio_keyboard', categoryId: 'musical_instruments', brand: 'Casio', name: 'Keyboard 61 Keys', unit: '1 pc', emoji: '🎹', basePrice: 8495),
  Product(id: 'boya_mic', categoryId: 'musical_instruments', brand: 'Boya', name: 'Lapel Microphone', unit: '1 pc', emoji: '🎤', basePrice: 899),

  // Jewellery
  Product(id: 'giva_pendant', categoryId: 'jewellery', brand: 'GIVA', name: 'Silver Pendant', unit: '1 pc', emoji: '💎', basePrice: 1999),
  Product(id: 'zaveri_necklace_set', categoryId: 'jewellery', brand: 'Zaveri Pearls', name: 'Necklace Set', unit: '1 set', emoji: '📿', basePrice: 1299),
  Product(id: 'voylla_earrings', categoryId: 'jewellery', brand: 'Voylla', name: 'Earrings', unit: '1 pair', emoji: '💍', basePrice: 799),

  // Office Products
  Product(id: 'parker_pen', categoryId: 'office_products', brand: 'Parker', name: 'Ball Pen', unit: '1 pc', emoji: '🖊️', basePrice: 425),
  Product(id: 'cello_gel_pens', categoryId: 'office_products', brand: 'Cello', name: 'Gel Pens', unit: '10 pcs', emoji: '🖊️', basePrice: 199),
  Product(id: 'classmate_notebooks', categoryId: 'office_products', brand: 'Classmate', name: 'Notebooks', unit: '6 pcs', emoji: '📓', basePrice: 240),
  Product(id: 'casio_calculator', categoryId: 'office_products', brand: 'Casio', name: 'Scientific Calculator', unit: '1 pc', emoji: '🧮', basePrice: 1095),
  Product(id: 'postit_notes', categoryId: 'office_products', brand: 'Post-it', name: 'Sticky Notes', unit: '5 pads', emoji: '🗒️', basePrice: 325),

  // Kindle Store
  Product(id: 'kindle_paperwhite', categoryId: 'kindle_store', brand: 'Amazon', name: 'Kindle Paperwhite', unit: '16 GB', emoji: '📖', basePrice: 14999),
  Product(id: 'kindle_unlimited', categoryId: 'kindle_store', brand: 'Amazon', name: 'Kindle Unlimited', unit: '3 months', emoji: '📚', basePrice: 599),
  Product(id: 'kindle_cover', categoryId: 'kindle_store', brand: 'Amazon', name: 'Kindle Fabric Cover', unit: '1 pc', emoji: '📕', basePrice: 1799),

  // Outdoor Living
  Product(id: 'quechua_tent', categoryId: 'outdoor_living', brand: 'Quechua', name: 'Camping Tent', unit: '2 person', emoji: '⛺', basePrice: 3999),
  Product(id: 'coleman_chair', categoryId: 'outdoor_living', brand: 'Coleman', name: 'Folding Chair', unit: '1 pc', emoji: '🪑', basePrice: 1899),
  Product(id: 'ugaoo_planters', categoryId: 'outdoor_living', brand: 'Ugaoo', name: 'Ceramic Planter Set', unit: '3 pcs', emoji: '🪴', basePrice: 699),
  Product(id: 'havells_string_lights', categoryId: 'outdoor_living', brand: 'Havells', name: 'Solar String Lights', unit: '10 m', emoji: '✨', basePrice: 899),

  // Video Games
  Product(id: 'sony_dualsense', categoryId: 'video_games', brand: 'Sony', name: 'Game Controller', unit: '1 pc', emoji: '🎮', basePrice: 5990),
  Product(id: 'xbox_controller', categoryId: 'video_games', brand: 'Microsoft', name: 'Game Controller', unit: '1 pc', emoji: '🎮', basePrice: 5490),
  Product(id: 'nintendo_switch', categoryId: 'video_games', brand: 'Nintendo', name: 'Switch OLED', unit: '1 pc', emoji: '🕹️', basePrice: 31999),
  Product(id: 'ea_fc_ps5', categoryId: 'video_games', brand: 'EA', name: 'FC 25 (PS5)', unit: '1 disc', emoji: '💿', basePrice: 3999),

  // Pet Supplies
  Product(id: 'pedigree_dog_food', categoryId: 'pet_supplies', brand: 'Pedigree', name: 'Dog Food', unit: '3 kg', emoji: '🐶', basePrice: 699),
  Product(id: 'royal_canin_dog_food', categoryId: 'pet_supplies', brand: 'Royal Canin', name: 'Dog Food', unit: '3 kg', emoji: '🐶', basePrice: 2199),
  Product(id: 'whiskas_cat_food', categoryId: 'pet_supplies', brand: 'Whiskas', name: 'Cat Food', unit: '1.2 kg', emoji: '🐱', basePrice: 399),
  Product(id: 'huft_leash', categoryId: 'pet_supplies', brand: 'Heads Up For Tails', name: 'Dog Leash', unit: '1 pc', emoji: '🦮', basePrice: 549),

  // Home Medical Supplies
  Product(id: 'drtrust_bp_monitor', categoryId: 'home_medical', brand: 'Dr Trust', name: 'BP Monitor', unit: '1 pc', emoji: '🩺', basePrice: 1899),
  Product(id: 'omron_bp_monitor', categoryId: 'home_medical', brand: 'Omron', name: 'BP Monitor', unit: '1 pc', emoji: '🩺', basePrice: 2499),
  Product(id: 'accuchek_glucometer', categoryId: 'home_medical', brand: 'Accu-Chek', name: 'Glucometer', unit: '1 kit', emoji: '🩸', basePrice: 1249),
  Product(id: 'bpl_oximeter', categoryId: 'home_medical', brand: 'BPL', name: 'Pulse Oximeter', unit: '1 pc', emoji: '📟', basePrice: 899),
  Product(id: 'vicks_thermometer', categoryId: 'home_medical', brand: 'Vicks', name: 'Digital Thermometer', unit: '1 pc', emoji: '🌡️', basePrice: 299),

  // Software
  Product(id: 'ms365_personal', categoryId: 'software', brand: 'Microsoft', name: '365 Personal', unit: '1 year', emoji: '💻', basePrice: 4899),
  Product(id: 'quickheal_security', categoryId: 'software', brand: 'Quick Heal', name: 'Total Security', unit: '1 year', emoji: '🛡️', basePrice: 1591),
  Product(id: 'adobe_photoshop', categoryId: 'software', brand: 'Adobe', name: 'Photoshop CC', unit: '1 year', emoji: '🖌️', basePrice: 9467),

  // Bags, Wallets & Luggage
  Product(id: 'american_tourister_trolley', categoryId: 'bags_wallets_luggage', brand: 'American Tourister', name: 'Trolley 55 cm', unit: '1 pc', emoji: '🧳', basePrice: 4299),
  Product(id: 'safari_trolley', categoryId: 'bags_wallets_luggage', brand: 'Safari', name: 'Trolley 55 cm', unit: '1 pc', emoji: '🧳', basePrice: 3499),
  Product(id: 'wildcraft_backpack', categoryId: 'bags_wallets_luggage', brand: 'Wildcraft', name: 'Backpack 35 L', unit: '1 pc', emoji: '🎒', basePrice: 1799),
  Product(id: 'titan_wallet', categoryId: 'bags_wallets_luggage', brand: 'Titan', name: 'Leather Wallet', unit: '1 pc', emoji: '👛', basePrice: 995),
];
