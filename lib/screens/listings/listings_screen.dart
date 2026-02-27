import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';
import '../../providers/app_state.dart';

class ListingsScreen extends StatefulWidget {
  const ListingsScreen({super.key});

  @override
  State<ListingsScreen> createState() => _ListingsScreenState();
}

class _ListingsScreenState extends State<ListingsScreen> {
  String _filterProduct = 'All';
  bool _isGridView = false;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    var listings = appState.activeListings;

    if (_filterProduct != 'All') {
      listings = listings.where((l) => l.productType == _filterProduct).toList();
    }

    return Scaffold(
      backgroundColor: AppTheme.surfaceLight,
      appBar: AppBar(
        title: Text('Marketplace', style: GoogleFonts.outfit(fontWeight: FontWeight.w700)),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/create-listing'),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Filters
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _filterChip('All'),
                ...AppConstants.productCategories.take(10).map((p) => _filterChip(p)),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Listings
          Expanded(
            child: listings.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.storefront, size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        Text(
                          'No listings found',
                          style: GoogleFonts.outfit(fontSize: 16, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  )
                : _isGridView
                    ? GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.85,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: listings.length,
                        itemBuilder: (context, index) {
                          return FadeInUp(
                            delay: Duration(milliseconds: index * 80),
                            child: _gridCard(context, listings[index]),
                          );
                        },
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: listings.length,
                        itemBuilder: (context, index) {
                          return FadeInUp(
                            delay: Duration(milliseconds: index * 80),
                            child: _listCard(context, listings[index]),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label) {
    final isSelected = _filterProduct == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => setState(() => _filterProduct = label),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryGreen : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppTheme.primaryGreen : Colors.grey.shade300,
            ),
          ),
          child: Center(
            child: Text(
              label == 'All' ? '🌐 All' : '${AppConstants.productEmojis[label] ?? ''} $label',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _listCard(BuildContext context, listing) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/listing-detail', arguments: listing),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  AppConstants.productEmojis[listing.productType] ?? '📦',
                  style: const TextStyle(fontSize: 26),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listing.productType,
                    style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${listing.quantity} ${listing.unit} • ${listing.farmerVillage}',
                    style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'by ${listing.farmerName}',
                    style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade400),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.accentAmber.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Wants: ${listing.desiredProduct}',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.accentAmber,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${listing.valuationScore.toStringAsFixed(0)}',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryGreen,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _gridCard(BuildContext context, listing) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/listing-detail', arguments: listing),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppConstants.productEmojis[listing.productType] ?? '📦',
              style: const TextStyle(fontSize: 36),
            ),
            const SizedBox(height: 8),
            Text(
              listing.productType,
              style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            Text(
              '${listing.quantity} ${listing.unit}',
              style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 6),
            Text(
              'Wants: ${listing.desiredProduct}',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.accentAmber,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              '₹${listing.valuationScore.toStringAsFixed(0)}',
              style: GoogleFonts.outfit(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
