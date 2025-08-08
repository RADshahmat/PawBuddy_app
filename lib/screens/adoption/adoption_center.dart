import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../utils/app_colors.dart';
import '../../models/report.dart';
import '../checkout/checkout.dart';

Widget buildAdoptionContent() {
return const _AdoptionContent();
}

// Stateful widget so it can fetch & filter
class _AdoptionContent extends StatefulWidget {
const _AdoptionContent({super.key});

@override
State<_AdoptionContent> createState() => _AdoptionContentState();
}

class _AdoptionContentState extends State<_AdoptionContent> {
List<Report> _reports = [];
bool _loading = true;
String? _selectedAnimal;
String? _selectedReportType;

// 'All' => null (no filter), 'Free' => 'report', 'Paid' => 'sell'
final Map<String, String?> reportTypeMap = {
  'All': null,
  'Free': 'report',
  'Paid': 'sell',
};

int _currentPage = 1;
final int _limit = 10;
bool _hasMore = true;
bool _isLoadingMore = false;

final ScrollController _scrollController = ScrollController();

// Simple local state for the carousel page label per list index
// (we don't need exact per-report index; a generic overlay looks great)
@override
void initState() {
  super.initState();
  _loadReports(page: _currentPage);

  _scrollController.addListener(() {
    if (!_isLoadingMore && _hasMore) {
      if (_scrollController.position.atEdge) {
        final bool isBottom = _scrollController.position.pixels != 0;
        if (isBottom) {
          _loadReports(
            page: _currentPage + 1,
            animalType: _selectedAnimal,
            reportType: _selectedReportType,
          );
        }
      }
    }
  });
}

@override
void dispose() {
  _scrollController.dispose();
  super.dispose();
}

Future<void> _loadReports({
  String? animalType,
  String? reportType,
  int page = 1,
}) async {
  if (page == 1) {
    if (mounted) setState(() => _loading = true);
  } else {
    if (mounted) setState(() => _isLoadingMore = true);
  }

  final queryParams = {
    'page': page.toString(),
    'limit': _limit.toString(),
    if (animalType != null && animalType.isNotEmpty) 'animalType': animalType,
    if (reportType != null && reportType.isNotEmpty) 'reportType': reportType,
  };

  final uri = Uri.parse(
    'https://pawbuddy.cse.pstu.ac.bd/api/reports/',
  ).replace(queryParameters: queryParams);

  try {
    final res = await http.get(uri);
    if (!mounted) return;

    if (res.statusCode == 200) {
      final jsonBody = jsonDecode(res.body);
      final List data = jsonBody['data']['reports'];

      setState(() {
        if (page == 1) {
          _reports = data.map((e) => Report.fromJson(e)).toList();
        } else {
          _reports.addAll(data.map((e) => Report.fromJson(e)).toList());
        }
        _currentPage = page;
        _hasMore = data.length == _limit; // more if we got full page
        _loading = false;
        _isLoadingMore = false;
      });
    } else {
      setState(() {
        _loading = false;
        _isLoadingMore = false;
      });
    }
  } catch (_) {
    if (!mounted) return;
    setState(() {
      _loading = false;
      _isLoadingMore = false;
    });
  }
}

Future<void> _refresh() async {
  _currentPage = 1;
  _hasMore = true;
  await _loadReports(
    page: 1,
    animalType: _selectedAnimal,
    reportType: _selectedReportType,
  );
}

void _applyInlineFilters({
  String? animal,
  String? type,
}) {
  _selectedAnimal = (animal == 'All') ? null : animal ?? _selectedAnimal;
  // type can be 'All' | 'Free' | 'Paid'
  if (type != null) {
    _selectedReportType = reportTypeMap[type];
  }
  _currentPage = 1;
  _hasMore = true;
  _loadReports(
    page: 1,
    animalType: _selectedAnimal,
    reportType: _selectedReportType,
  );
}

void _showFilterSheet() {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return DraggableScrollableSheet(
        initialChildSize: 0.45,
        minChildSize: 0.3,
        maxChildSize: 0.85,
        expand: false,
        builder: (context, scrollController) {
          String? tempAnimal = _selectedAnimal ?? 'All';
          String tempTypeLabel = reportTypeMap.entries
              .firstWhere(
                (entry) => entry.value == _selectedReportType,
                orElse: () => const MapEntry('All', null),
              )
              .key;

          return StatefulBuilder(
            builder: (context, setStateModal) {
              return SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Filters",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Animal type",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final e in ['All', 'Dog', 'Cat', 'Bird', 'Rabbit', 'Other'])
                          ChoiceChip(
                            label: Text(e),
                            selected: (tempAnimal ?? 'All') == e,
                            onSelected: (_) {
                              setStateModal(() {
                                tempAnimal = e == 'All' ? 'All' : e;
                              });
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Adoption type",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        for (final label in ['All', 'Free', 'Paid'])
                          FilterChip(
                            label: Text(label),
                            selected: tempTypeLabel == label,
                            showCheckmark: false,
                            onSelected: (_) {
                              setStateModal(() {
                                tempTypeLabel = label;
                              });
                            },
                            avatar: label == 'Free'
                                ? const Icon(Icons.volunteer_activism, size: 18)
                                : label == 'Paid'
                                    ? const Icon(Icons.attach_money, size: 18)
                                    : const Icon(Icons.all_inclusive, size: 18),
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        icon: const Icon(Icons.check_circle),
                        onPressed: () {
                          Navigator.pop(context);
                          _applyInlineFilters(
                            animal: tempAnimal,
                            type: tempTypeLabel,
                          );
                        },
                        label: const Text("Apply filters"),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.restart_alt),
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            _selectedAnimal = null;
                            _selectedReportType = null;
                          });
                          _refresh();
                        },
                        label: const Text("Reset"),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    },
  );
}

@override
Widget build(BuildContext context) {
  final cs = Theme.of(context).colorScheme;

  return Column(
    children: [
      // Elevated hero header
      _Header(
        onOpenFilters: _showFilterSheet,
        total: _reports.length,
      ),

      // Inline filters: modern chips bar
      

      Expanded(
        child: RefreshIndicator(
          onRefresh: _refresh,
          color: cs.primary,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _loading && _reports.isEmpty
                ? ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.only(
                      top: 12,
                      bottom: kBottomNavigationBarHeight + 24,
                    ),
                    itemCount: 4,
                    itemBuilder: (_, __) => const _ReportSkeleton(),
                  )
                : _reports.isEmpty
                    ? _EmptyState(onTryAgain: _refresh)
                    : ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.only(
                          top: 12,
                          bottom: kBottomNavigationBarHeight + 24,
                        ),
                        itemCount: _reports.length + (_isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index < _reports.length) {
                            return _ReportCard(
                              report: _reports[index],
                              onPrimaryPressed: () {
                                final report = _reports[index];
                                final isPaid = report.reportType == 'sell';
                                if (isPaid) {
                                  proceedToCheckout(
                                    context,
                                    totalPrice: report.price ?? 0,
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (_) => const Center(child: CircularProgressIndicator()),
                                  );
                                  Future.delayed(const Duration(seconds: 2), () {
                                    Navigator.of(context).pop(); // close loading dialog
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text('Done! We will contact you soon.'),
                                        backgroundColor: AppColors.success,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    );
                                  });
                                }
                              },
                            );
                          } else {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                        },
                      ),
          ),
        ),
      ),
    ],
  );
}
}

class _Header extends StatelessWidget {
final VoidCallback onOpenFilters;
final int total;
const _Header({required this.onOpenFilters, required this.total});

@override
Widget build(BuildContext context) {
  final cs = Theme.of(context).colorScheme;

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          cs.primary.withOpacity(0.12),
          cs.primary.withOpacity(0.04),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border(
        bottom: BorderSide(color: cs.outlineVariant.withOpacity(0.4)),
      ),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Adoption Center",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                total == 0 ? "Find your new best friend" : "$total results • Updated just now",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                    ),
              ),
            ],
          ),
        ),
        IconButton.filledTonal(
          tooltip: "Filters",
          onPressed: onOpenFilters,
          icon: const Icon(Icons.tune),
        ),
      ],
    ),
  );
}
}

class _FiltersBar extends StatelessWidget {
final String selectedAnimal; // 'All' | 'Dog' | 'Cat' | 'Bird' | 'Rabbit' | 'Other'
final String selectedTypeLabel; // 'All' | 'Free' | 'Paid'
final ValueChanged<String> onAnimalChanged;
final ValueChanged<String> onTypeChanged;

const _FiltersBar({
  required this.selectedAnimal,
  required this.selectedTypeLabel,
  required this.onAnimalChanged,
  required this.onTypeChanged,
});

@override
Widget build(BuildContext context) {
  final animals = const ['All', 'Dog', 'Cat', 'Bird', 'Rabbit', 'Other'];
  final types = const ['All', 'Free', 'Paid'];
  final cs = Theme.of(context).colorScheme;

  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
      color: cs.surface,
      border: Border(
        bottom: BorderSide(color: cs.outlineVariant.withOpacity(0.4)),
      ),
    ),
    child: Column(
      children: [
        // Animal chips
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemBuilder: (_, i) {
              final label = animals[i];
              final selected = label == selectedAnimal;
              return ChoiceChip(
                label: Text(label),
                selected: selected,
                onSelected: (_) => onAnimalChanged(label),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemCount: animals.length,
          ),
        ),
        const SizedBox(height: 8),
        // Type chips
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemBuilder: (_, i) {
              final label = types[i];
              final selected = label == selectedTypeLabel;
              return FilterChip(
                label: Text(label),
                selected: selected,
                showCheckmark: false,
                onSelected: (_) => onTypeChanged(label),
                avatar: label == 'Free'
                    ? const Icon(Icons.volunteer_activism, size: 18)
                    : label == 'Paid'
                        ? const Icon(Icons.attach_money, size: 18)
                        : const Icon(Icons.all_inclusive, size: 18),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemCount: types.length,
          ),
        ),
      ],
    ),
  );
}
}

class _ReportCard extends StatelessWidget {
final Report report;
final VoidCallback onPrimaryPressed;

const _ReportCard({
  required this.report,
  required this.onPrimaryPressed,
});

@override
Widget build(BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  final isFree = report.price == null || report.price == 0;
  final isPaid = report.reportType == 'sell';

  final imageUrls = report.images;
  final hasImages = imageUrls.isNotEmpty;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    child: Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {}, // Hook for future detail page
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image / Carousel
            if (hasImages)
              Stack(
                children: [
                  if (imageUrls.length > 1)
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 220,
                        viewportFraction: 1.0,
                        enableInfiniteScroll: imageUrls.length > 1,
                        autoPlay: imageUrls.length > 1,
                        autoPlayInterval: const Duration(seconds: 4),
                        autoPlayAnimationDuration: const Duration(milliseconds: 700),
                      ),
                      items: imageUrls.map((img) {
                        return Image.network(
                          img,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 220,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              height: 220,
                              color: cs.surfaceVariant.withOpacity(0.4),
                              alignment: Alignment.center,
                              child: const CircularProgressIndicator(),
                            );
                          },
                          errorBuilder: (_, __, ___) => _ImageFallback(height: 220),
                        );
                      }).toList(),
                    )
                  else
                    Image.network(
                      imageUrls.first,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 220,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          height: 220,
                          color: cs.surfaceVariant.withOpacity(0.4),
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(),
                        );
                      },
                      errorBuilder: (_, __, ___) => _ImageFallback(height: 220),
                    ),
                  // Top gradient overlay for badges
                  Positioned.fill(
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.35),
                              Colors.transparent,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Badges
                  Positioned(
                    left: 12,
                    top: 12,
                    child: _Badge(
                      text: isFree ? 'Free' : 'Paid',
                      color: isFree ? AppColors.success : cs.primary,
                      icon: isFree ? Icons.volunteer_activism : Icons.attach_money,
                    ),
                  ),
                  if (isPaid && (report.price ?? 0) > 0)
                    Positioned(
                      right: 12,
                      top: 12,
                      child: _Badge(
                        text: 'Price: ${report.price}',
                        color: cs.secondary,
                        icon: Icons.sell,
                      ),
                    ),
                ],
              )
            else
              _ImageFallback(height: 220),

            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
              child: Row(
                children: [
                  Icon(Icons.pets, size: 18, color: cs.primary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      report.animalType,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            if (report.user != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text(
                  "Posted by ${report.user!.username}",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                      ),
                ),
              ),

            if (report.description != null) const SizedBox(height: 6),
            if (report.description != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text(
                  report.description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),

            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: isFree ? AppColors.success : null,
                      ),
                      onPressed: onPrimaryPressed,
                      icon: Icon(isFree ? Icons.favorite : Icons.shopping_bag),
                      label: Text(isFree ? 'Adopt' : 'Buy'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}

class _ImageFallback extends StatelessWidget {
final double height;
const _ImageFallback({required this.height});

@override
Widget build(BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  return Container(
    height: height,
    width: double.infinity,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          cs.surfaceVariant.withOpacity(0.6),
          cs.surfaceVariant.withOpacity(0.3),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    alignment: Alignment.center,
    child: Icon(Icons.image_not_supported, color: cs.onSurface.withOpacity(0.4), size: 40),
  );
}
}

class _Badge extends StatelessWidget {
final String text;
final Color color;
final IconData icon;
const _Badge({required this.text, required this.color, required this.icon});

@override
Widget build(BuildContext context) {
  final onColor = Colors.white;
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: color.withOpacity(0.95),
      borderRadius: BorderRadius.circular(999),
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(0.35),
          blurRadius: 10,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Row(
      children: [
        Icon(icon, color: onColor, size: 16),
        const SizedBox(width: 6),
        Text(
          text,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: onColor,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    ),
  );
}
}

class _ReportSkeleton extends StatelessWidget {
const _ReportSkeleton({super.key});

@override
Widget build(BuildContext context) {
  final base = Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5);

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Container(height: 220, color: base),
          Container(height: 14, margin: const EdgeInsets.fromLTRB(14, 14, 140, 10), color: base),
          Container(height: 12, margin: const EdgeInsets.fromLTRB(14, 0, 180, 8), color: base),
          Container(height: 12, margin: const EdgeInsets.fromLTRB(14, 0, 30, 14), color: base),
          const SizedBox(height: 6),
        ],
      ),
    ),
  );
}
}

class _EmptyState extends StatelessWidget {
final Future<void> Function() onTryAgain;
const _EmptyState({required this.onTryAgain});

@override
Widget build(BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  return ListView(
    physics: const AlwaysScrollableScrollPhysics(),
    padding: EdgeInsets.only(
      bottom: kBottomNavigationBarHeight + 24,
    ),
    children: [
      const SizedBox(height: 80),
      Icon(Icons.pets, size: 64, color: cs.primary),
      const SizedBox(height: 12),
      Text(
        "No pets found",
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 6),
      Text(
        "Try adjusting filters or pull to refresh.",
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
      ),
      const SizedBox(height: 20),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: FilledButton.icon(
          onPressed: onTryAgain,
          icon: const Icon(Icons.refresh),
          label: const Text("Try again"),
        ),
      ),
      const SizedBox(height: 60),
    ],
  );
}
}
