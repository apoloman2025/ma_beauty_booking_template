import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:js' as js;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'models/beauty_models.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BeautyBookingApp());
}

class BeautyBookingApp extends StatelessWidget {
  const BeautyBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lumina Aesthetics • Beauty Booking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0D11),
        primaryColor: const Color(0xFFD4AF37),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD4AF37),
          secondary: Color(0xFFE0A96D),
          surface: Color(0xFF16161D),
        ),
        textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
      ),
      home: const BeautyHomeScreen(),
    );
  }
}

class BeautyHomeScreen extends StatefulWidget {
  const BeautyHomeScreen({super.key});

  @override
  State<BeautyHomeScreen> createState() => _BeautyHomeScreenState();
}

class _BeautyHomeScreenState extends State<BeautyHomeScreen> {
  String _selectedCategoryId = "all";
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  // Masters Data
  final List<Master> _masters = const [
    Master(
      id: "m1",
      name: "Amina Al-Mansoor",
      title: "Top Hair Stylist & Colorist",
      avatarUrl: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500&auto=format&fit=crop&q=80",
      rating: 4.98,
      reviewsCount: 342,
      experience: "8 years (Vogue Certified)",
      portfolioPhotos: [
        "https://images.unsplash.com/photo-1560066984-138dadb4c035?w=500&auto=format&fit=crop&q=80",
        "https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=500&auto=format&fit=crop&q=80",
        "https://images.unsplash.com/photo-1595476108010-b4d1f102b1b1?w=500&auto=format&fit=crop&q=80",
      ],
      instagram: "@amina_hairstudio",
    ),
    Master(
      id: "m2",
      name: "Elena Rostova",
      title: "Luxury Nail Artist",
      avatarUrl: "https://images.unsplash.com/photo-1517841905240-472988babdf9?w=500&auto=format&fit=crop&q=80",
      rating: 4.96,
      reviewsCount: 289,
      experience: "6 years (Milan Masterclass)",
      portfolioPhotos: [
        "https://images.unsplash.com/photo-1632345031435-8727f6897d53?w=500&auto=format&fit=crop&q=80",
        "https://images.unsplash.com/photo-1604654894610-df63bc536371?w=500&auto=format&fit=crop&q=80",
      ],
      instagram: "@elena_nails_dubai",
    ),
    Master(
      id: "m3",
      name: "Daria Novikova",
      title: "Brow & Lash Architect",
      avatarUrl: "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=500&auto=format&fit=crop&q=80",
      rating: 4.99,
      reviewsCount: 415,
      experience: "7 years (International Judge)",
      portfolioPhotos: [
        "https://images.unsplash.com/photo-1583001809873-a128495da465?w=500&auto=format&fit=crop&q=80",
        "https://images.unsplash.com/photo-1516975080664-ed2fc6a32937?w=500&auto=format&fit=crop&q=80",
      ],
      instagram: "@daria_brows_ae",
    ),
    Master(
      id: "m4",
      name: "Chloe Dubois",
      title: "Holistic Facial & Spa Therapist",
      avatarUrl: "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=500&auto=format&fit=crop&q=80",
      rating: 4.95,
      reviewsCount: 198,
      experience: "9 years (Paris Spa Academy)",
      portfolioPhotos: [
        "https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=500&auto=format&fit=crop&q=80",
        "https://images.unsplash.com/photo-1512290900672-1f4a9b6c085b?w=500&auto=format&fit=crop&q=80",
      ],
      instagram: "@chloe_spa_aesthetics",
    ),
  ];

  // Categories Data
  final List<BeautyCategory> _categories = const [
    BeautyCategory(id: "all", name: "All Services", emoji: "✨", icon: Icons.auto_awesome),
    BeautyCategory(id: "hair", name: "Hair & Styling", emoji: "💇‍♀️", icon: Icons.face_retouching_natural),
    BeautyCategory(id: "nails", name: "Nails & Spa", emoji: "💅", icon: Icons.brush),
    BeautyCategory(id: "brows", name: "Brows & Lashes", emoji: "👁️", icon: Icons.remove_red_eye),
    BeautyCategory(id: "spa", name: "Massage & Body", emoji: "💆‍♀️", icon: Icons.spa),
    BeautyCategory(id: "facial", name: "Aesthetics & Care", emoji: "💎", icon: Icons.favorite_border),
  ];

  // Services Data
  final List<BeautyService> _services = const [
    BeautyService(
      id: "s1",
      name: "AirTouch Luxury Blonde & Care",
      categoryId: "hair",
      durationMinutes: 180,
      price: 650,
      currency: "AED",
      description: "Signature gentle seamless lightening with silk protein treatment and French gloss toning.",
      masterIds: ["m1"],
      isPopular: true,
      imageUrl: "https://images.unsplash.com/photo-1560066984-138dadb4c035?w=500&auto=format&fit=crop&q=80",
    ),
    BeautyService(
      id: "s2",
      name: "Silk Express Blowout & Styling",
      categoryId: "hair",
      durationMinutes: 45,
      price: 180,
      currency: "AED",
      description: "Volume styling with caviar serum hydration and heat-shield gloss finish.",
      masterIds: ["m1"],
      imageUrl: "https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=500&auto=format&fit=crop&q=80",
    ),
    BeautyService(
      id: "s3",
      name: "Japanese SMART Manicure + Gel",
      categoryId: "nails",
      durationMinutes: 75,
      price: 240,
      currency: "AED",
      description: "Ultra-clean cuticle hardware technique, therapeutic organic oil massage & long-wear coat.",
      masterIds: ["m2"],
      isPopular: true,
      imageUrl: "https://images.unsplash.com/photo-1632345031435-8727f6897d53?w=500&auto=format&fit=crop&q=80",
    ),
    BeautyService(
      id: "s4",
      name: "Spa Pedicure with Gold Scrub",
      categoryId: "nails",
      durationMinutes: 60,
      price: 260,
      currency: "AED",
      description: "Relaxing foot soak with 24k gold flakes, deep scrub, reflexology massage and coating.",
      masterIds: ["m2"],
      imageUrl: "https://images.unsplash.com/photo-1604654894610-df63bc536371?w=500&auto=format&fit=crop&q=80",
    ),
    BeautyService(
      id: "s5",
      name: "Brow Architecture & Lamination",
      categoryId: "brows",
      durationMinutes: 60,
      price: 210,
      currency: "AED",
      description: "Custom geometric mapping, gentle keratin lamination and hybrid botanical tinting.",
      masterIds: ["m3"],
      isPopular: true,
      imageUrl: "https://images.unsplash.com/photo-1583001809873-a128495da465?w=500&auto=format&fit=crop&q=80",
    ),
    BeautyService(
      id: "s6",
      name: "Velvet Lash Extension (2D / 3D)",
      categoryId: "brows",
      durationMinutes: 100,
      price: 320,
      currency: "AED",
      description: "Feather-light cashmere lashes for natural elegance and fluffy volume.",
      masterIds: ["m3"],
      imageUrl: "https://images.unsplash.com/photo-1516975080664-ed2fc6a32937?w=500&auto=format&fit=crop&q=80",
    ),
    BeautyService(
      id: "s7",
      name: "Deep Hydration Hydro-Facial",
      categoryId: "facial",
      durationMinutes: 60,
      price: 390,
      currency: "AED",
      description: "Vacuum pore purification, antioxidant peptide infusion and cold cryogenic lifting.",
      masterIds: ["m4"],
      isPopular: true,
      imageUrl: "https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=500&auto=format&fit=crop&q=80",
    ),
    BeautyService(
      id: "s8",
      name: "Balinese Aromatherapy Ritual",
      categoryId: "spa",
      durationMinutes: 90,
      price: 420,
      currency: "AED",
      description: "Warm organic lotus oil massage, muscle tension release and calming sound therapy.",
      masterIds: ["m4"],
      imageUrl: "https://images.unsplash.com/photo-1512290900672-1f4a9b6c085b?w=500&auto=format&fit=crop&q=80",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredServices = _services.where((s) {
      final matchesCategory = _selectedCategoryId == "all" || s.categoryId == _selectedCategoryId;
      final matchesSearch = _searchQuery.isEmpty ||
          s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            // Top Salon Brand Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFD4AF37), Color(0xFFE0A96D)],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFD4AF37).withOpacity(0.35),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.spa, color: Colors.black, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "LUMINA AESTHETICS",
                                      style: GoogleFonts.cinzel(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.2,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(Icons.verified, color: Color(0xFFD4AF37), size: 16),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Dubai Marina • Luxury Salon & Spa",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1E26),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.4)),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.star, color: Color(0xFFD4AF37), size: 14),
                              SizedBox(width: 4),
                              Text(
                                "4.98",
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Search Bar
                    Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: const Color(0xFF16161E),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white.withOpacity(0.08)),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) => setState(() => _searchQuery = val),
                        style: const TextStyle(fontSize: 14, color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Search services (e.g. AirTouch, Manicure, Facial)...",
                          hintStyle: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.35)),
                          prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.4), size: 20),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Top Masters Stories Carousel
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "OUR TOP MASTERS",
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                            color: const Color(0xFFD4AF37),
                          ),
                        ),
                        Text(
                          "Tap to see portfolio",
                          style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.4)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 106,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      itemCount: _masters.length,
                      itemBuilder: (context, index) {
                        final m = _masters[index];
                        return _buildMasterStoryItem(m);
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Categories Filter Pills
            SliverToBoxAdapter(
              child: Container(
                height: 42,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final isSelected = cat.id == _selectedCategoryId;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategoryId = cat.id),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFD4AF37) : const Color(0xFF16161E),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: isSelected ? const Color(0xFFD4AF37) : Colors.white.withOpacity(0.08),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(cat.emoji, style: const TextStyle(fontSize: 13)),
                            const SizedBox(width: 6),
                            Text(
                              cat.name,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected ? Colors.black : Colors.white.withOpacity(0.85),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Section Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "SERVICES & TREATMENTS",
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                    Text(
                      "${filteredServices.length} available",
                      style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.4)),
                    ),
                  ],
                ),
              ),
            ),

            // Services List
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final s = filteredServices[index];
                    final master = _masters.firstWhere(
                      (m) => s.masterIds.contains(m.id),
                      orElse: () => _masters.first,
                    );
                    return _buildServiceCard(s, master);
                  },
                  childCount: filteredServices.length,
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 50),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMasterStoryItem(Master m) {
    return GestureDetector(
      onTap: () => _showMasterPortfolio(m),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(2.5),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFFD4AF37), Color(0xFFE0A96D), Color(0xFF9E782F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(m.avatarUrl),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              m.name.split(" ").first,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
            ),
            Text(
              "★ ${m.rating}",
              style: const TextStyle(fontSize: 10, color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(BeautyService s, Master m) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF15151D),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Banner with Badges
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  s.imageUrl,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              if (s.isPopular)
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "MOST POPULAR 🔥",
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.black),
                    ),
                  ),
                ),
              Positioned(
                bottom: 10,
                left: 14,
                child: Row(
                  children: [
                    CircleAvatar(radius: 12, backgroundImage: NetworkImage(m.avatarUrl)),
                    const SizedBox(width: 6),
                    Text(
                      "By ${m.name}",
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        s.name,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${s.currency} ${s.price.toInt()}",
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFD4AF37),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  s.description,
                  style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.6), height: 1.35),
                ),
                const SizedBox(height: 14),

                // Footer Row: Duration & Book Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E28),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.access_time, size: 13, color: Colors.white.withOpacity(0.6)),
                          const SizedBox(width: 5),
                          Text(
                            "${s.durationMinutes} min",
                            style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8)),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _openBookingCalendarSheet(s, m),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4AF37),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.calendar_month, size: 16),
                          SizedBox(width: 6),
                          Text("BOOK NOW", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMasterPortfolio(Master m) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF121218),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 32, backgroundImage: NetworkImage(m.avatarUrl)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 2),
                        Text(m.title, style: const TextStyle(fontSize: 13, color: Color(0xFFD4AF37))),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Color(0xFFD4AF37), size: 14),
                            Text(" ${m.rating} (${m.reviewsCount} reviews)", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text("Experience: ${m.experience}", style: const TextStyle(fontSize: 13, color: Colors.white70)),
              const SizedBox(height: 16),
              const Text("PORTFOLIO OF WORKS", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFD4AF37), letterSpacing: 1.2)),
              const SizedBox(height: 10),
              SizedBox(
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: m.portfolioPhotos.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        image: DecorationImage(
                          image: NetworkImage(m.portfolioPhotos[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _openBookingCalendarSheet(BeautyService s, Master m) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF121218),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (context) {
        return _BookingCalendarSheet(service: s, initialMaster: m, allMasters: _masters);
      },
    );
  }
}

class _BookingCalendarSheet extends StatefulWidget {
  final BeautyService service;
  final Master initialMaster;
  final List<Master> allMasters;

  const _BookingCalendarSheet({
    required this.service,
    required this.initialMaster,
    required this.allMasters,
  });

  @override
  State<_BookingCalendarSheet> createState() => _BookingCalendarSheetState();
}

class _BookingCalendarSheetState extends State<_BookingCalendarSheet> {
  String? _telegramUserId;
  late Master _selectedMaster;
  DateTime _selectedDate = DateTime.now();
  String? _selectedTimeSlot;
  final TextEditingController _nameController = TextEditingController(text: "Alina K.");
  final TextEditingController _phoneController = TextEditingController(text: "+971 50 892 4192");
  final TextEditingController _telegramController = TextEditingController(text: "@alina_dubai");

  final List<String> _morningSlots = ["10:00", "11:00", "11:45"];
  final List<String> _afternoonSlots = ["13:00", "14:15", "15:30", "16:45"];
  final List<String> _eveningSlots = ["18:00", "19:15", "20:30"];

  @override
  void initState() {
    super.initState();
    _selectedMaster = widget.initialMaster;
    _selectedTimeSlot = "14:15"; // default selected
    _detectTelegramUser();
  }

  void _detectTelegramUser() {
    try {
      final tg = js.context['Telegram']?['WebApp'];
      if (tg != null) {
        final user = tg['initDataUnsafe']?['user'];
        if (user != null) {
          final id = user['id'];
          if (id != null) _telegramUserId = id.toString();
          final username = user['username'];
          final first = user['first_name'];
          if (username != null && username.toString().isNotEmpty) _telegramController.text = "@$username";
          if (first != null && first.toString().isNotEmpty) _nameController.text = first.toString();
        }
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final dates = List.generate(14, (i) => DateTime.now().add(Duration(days: i)));

    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Handle
            Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Service Title & Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.service.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Duration: ${widget.service.durationMinutes} min",
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Text(
                  "${widget.service.currency} ${widget.service.price.toInt()}",
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFD4AF37),
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.white12, height: 28),

            // Select Master
            const Text(
              "SELECT SPECIALIST",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFD4AF37), letterSpacing: 1.2),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 48,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.allMasters.length,
                itemBuilder: (context, index) {
                  final m = widget.allMasters[index];
                  final isSel = m.id == _selectedMaster.id;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedMaster = m),
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSel ? const Color(0xFFD4AF37) : const Color(0xFF1C1C26),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isSel ? const Color(0xFFD4AF37) : Colors.white12,
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(radius: 12, backgroundImage: NetworkImage(m.avatarUrl)),
                          const SizedBox(width: 8),
                          Text(
                            m.name.split(" ").first,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isSel ? Colors.black : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Select Date Carousel
            const Text(
              "SELECT DATE",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFD4AF37), letterSpacing: 1.2),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 72,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: dates.length,
                itemBuilder: (context, index) {
                  final d = dates[index];
                  final isSameDay = d.day == _selectedDate.day && d.month == _selectedDate.month;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedDate = d),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 58,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: isSameDay ? const Color(0xFFD4AF37) : const Color(0xFF1A1A24),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSameDay ? const Color(0xFFD4AF37) : Colors.white10,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('EEE').format(d).toUpperCase(),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isSameDay ? Colors.black87 : Colors.white54,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${d.day}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: isSameDay ? Colors.black : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Select Time Slot
            const Text(
              "AVAILABLE TIME SLOTS",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFD4AF37), letterSpacing: 1.2),
            ),
            const SizedBox(height: 10),
            _buildSlotSection("Morning", _morningSlots),
            _buildSlotSection("Afternoon", _afternoonSlots),
            _buildSlotSection("Evening", _eveningSlots),
            const SizedBox(height: 16),

            // Client Contact Fields
            const Text(
              "CLIENT DETAILS",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFD4AF37), letterSpacing: 1.2),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildInput(_nameController, "Your Name", Icons.person_outline),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildInput(_phoneController, "Phone Number", Icons.phone_outlined),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildInput(_telegramController, "Telegram Username", Icons.send_outlined),
            const SizedBox(height: 24),

            // Confirm Booking Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _selectedTimeSlot == null ? null : _confirmBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 6,
                  shadowColor: const Color(0xFFD4AF37).withOpacity(0.4),
                ),
                child: Text(
                  "CONFIRM APPOINTMENT (${widget.service.currency} ${widget.service.price.toInt()})",
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 0.8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlotSection(String title, List<String> slots) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 11, color: Colors.white54)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: slots.map((slot) {
              final isSel = _selectedTimeSlot == slot;
              return GestureDetector(
                onTap: () => setState(() => _selectedTimeSlot = slot),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSel ? const Color(0xFFD4AF37) : const Color(0xFF1E1E28),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSel ? const Color(0xFFD4AF37) : Colors.white12,
                    ),
                  ),
                  child: Text(
                    slot,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isSel ? Colors.black : Colors.white70,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInput(TextEditingController controller, String hint, IconData icon) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: const Color(0xFF181822),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 13, color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFFD4AF37), size: 17),
          hintText: hint,
          hintStyle: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.3)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 11),
        ),
      ),
    );
  }

  Future<void> _sendTelegramNotification() async {
    final String dateStr = DateFormat('dd MMMM yyyy').format(_selectedDate);
    final String timeStr = _selectedTimeSlot ?? "14:15";
    final String clientName = _nameController.text.trim().isEmpty ? "VIP Client" : _nameController.text.trim();
    final String clientPhone = _phoneController.text.trim().isEmpty ? "+971 50 892 4192" : _phoneController.text.trim();
    final String clientTg = _telegramController.text.trim().isEmpty ? "@apoloman2014" : _telegramController.text.trim();

    final Map<String, dynamic> payload = {
      'chat_id': (_telegramUserId != null && _telegramUserId!.isNotEmpty) ? _telegramUserId : "397179760",
      'service_name': widget.service.name,
      'master_name': _selectedMaster.name,
      'date': dateStr,
      'time': timeStr,
      'price': widget.service.price.toInt().toString(),
      'currency': widget.service.currency,
      'client_name': clientName,
      'client_phone': clientPhone,
      'client_tg': clientTg,
    };

    try {
      // 1. Post to same-origin /api/book (Bypasses Browser CORS 100%)
      await http.post(
        Uri.parse('/api/book'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );
    } catch (_) {}

    // 2. Also trigger Telegram native sendData if inside Telegram WebApp
    try {
      if (js.context.hasProperty('Telegram')) {
        final tg = js.context['Telegram']?['WebApp'];
        if (tg != null) {
          tg.callMethod('sendData', [jsonEncode(payload)]);
        }
      }
    } catch (_) {}
  }

  void _confirmBooking() {
    HapticFeedback.heavyImpact();
    _sendTelegramNotification();
    Navigator.pop(context);

    // Show Success Booking Ticket
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF15151D),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFD4AF37),
                ),
                child: const Icon(Icons.check, color: Colors.black, size: 34),
              ),
              const SizedBox(height: 18),
              Text(
                "APPOINTMENT CONFIRMED!",
                style: GoogleFonts.cinzel(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                "Booking ticket has been sent to the salon manager in Telegram.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const Divider(color: Colors.white12, height: 24),
              _buildTicketRow("Service", widget.service.name),
              _buildTicketRow("Specialist", _selectedMaster.name),
              _buildTicketRow("Date", DateFormat('dd MMMM yyyy').format(_selectedDate)),
              _buildTicketRow("Time", _selectedTimeSlot ?? "14:15"),
              _buildTicketRow("Total", "${widget.service.currency} ${widget.service.price.toInt()}"),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text("GREAT", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTicketRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(val, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }
}
