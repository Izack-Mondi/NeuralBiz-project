import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/sale_request_repository.dart';
import '../../models/sale_request.dart';
import '../../widgets/feedback/nexify_empty_state.dart';
import '../../widgets/feedback/nexify_error_state.dart';
import '../../widgets/feedback/nexify_loading.dart';
import '../../widgets/nexify_transitions.dart';
import 'product_details_screen.dart';
import 'request_a_product_screen.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedFilter = 0;
  final _filters = const ['All Requests', 'Urgent', 'Nearby'];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRequests() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      await context.read<SaleRequestRepository>().loadRequests(
        search: _searchController.text,
      );
      if (!mounted) {
        return;
      }
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() => _hasError = true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  List<SaleRequest> get _filteredRequests {
    final query = _searchController.text.trim().toLowerCase();
    return context.read<SaleRequestRepository>().requests.where((request) {
      final matchesQuery =
          query.isEmpty ||
          [
            request.title,
            request.category,
            request.location,
            request.requesterName,
          ].join(' ').toLowerCase().contains(query);

      if (!matchesQuery) {
        return false;
      }

      switch (_selectedFilter) {
        case 1:
          return request.urgency == SaleRequestUrgency.urgent;
        case 2:
          final town = request.location.toLowerCase();
          return town.contains('nairobi') || town.contains('kiambu');
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<SaleRequestRepository>();
    final content = SafeArea(
      child: Column(
        children: [
          if (!widget.embedded) _buildHeader(),
          _buildSearch(),
          _buildFilters(),
          if (_isLoading)
            _wrapContent(child: const Center(child: NexifyLoading()))
          else if (_hasError)
            _wrapContent(
              child: NexifyErrorState(
                title: 'Unable to load requests',
                message: 'Please check your connection and try again.',
                onRetry: _loadRequests,
              ),
            )
          else if (_filteredRequests.isEmpty)
            _wrapContent(
              child: NexifyEmptyState(
                title: 'No matching requests',
                message: 'Try another search or post a new sale request.',
                icon: Icons.search_off_outlined,
              ),
            )
          else
            _wrapContent(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 32),
                shrinkWrap: widget.embedded,
                physics: widget.embedded
                    ? const NeverScrollableScrollPhysics()
                    : const BouncingScrollPhysics(),
                itemCount: _filteredRequests.length,
                itemBuilder: (context, index) {
                  final request = _filteredRequests[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        NexifyTransitions.fadeSlide(
                          ProductDetailsScreen(product: request.toLegacyMap()),
                          horizontal: true,
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0B1015),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: .07),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 46,
                                height: 46,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF22C55E)
                                      .withValues(alpha: .12),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.assignment_outlined,
                                  color: Color(0xFF22C55E),
                                  size: 25,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      request.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${request.requesterName} • ${request.location}',
                                      style: const TextStyle(
                                        color: Colors.white54,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF153220),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  request.urgency == SaleRequestUrgency.urgent
                                      ? 'Urgent'
                                      : 'Open',
                                  style: const TextStyle(
                                    color: Color(0xFF22C55E),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              _infoChip(request.quantity),
                              const SizedBox(width: 8),
                              _infoChip(request.budget),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            request.description,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                color: Colors.white54,
                                size: 15,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Needed by ${request.neededBy}',
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${request.connectionCount} ${request.connectionCount == 1 ? 'connection' : 'connections'}',
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );

    if (widget.embedded) {
      return content;
    }

    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: _buildCreateRequestButton(),
      body: content,
    );
  }

  Widget _wrapContent({required Widget child}) {
    return widget.embedded ? child : Expanded(child: child);
  }

  Widget _buildCreateRequestButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(
          context,
          NexifyTransitions.fadeSlide(
            const RequestAProductScreen(),
            horizontal: true,
          ),
        ).then((value) {
          if (value is SaleRequest && mounted) {
            context.read<SaleRequestRepository>().addRequest(value);
          }
        });
      },
      backgroundColor: const Color(0xFF22C55E),
      foregroundColor: Colors.black,
      icon: const Icon(Icons.add),
      label: const Text('New request'),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 16, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Requests',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'What are people looking for?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Find requests and respond with what you can supply.',
                  style: TextStyle(color: Colors.white60, fontSize: 15),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFF101417),
              borderRadius: BorderRadius.circular(17),
            ),
            child: const Icon(Icons.tune, color: Color(0xFF22C55E), size: 29),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Container(
      height: 55,
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      padding: const EdgeInsets.symmetric(horizontal: 17),
      decoration: BoxDecoration(
        color: const Color(0xFF101112),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: .08)),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.white70, size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                hintText: 'Search requests...',
                hintStyle: TextStyle(color: Colors.white54, fontSize: 16),
                border: InputBorder.none,
                isDense: true,
              ),
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 51,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final selected = index == _selectedFilter;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = index),
            child: Container(
              width: index == 0 ? 188 : 218,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF22C55E)
                    : const Color(0xFF101112),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (index == 2) ...[
                      const Icon(
                        Icons.location_on_outlined,
                        color: Colors.white,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      _filters[index],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _infoChip(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF101112),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
