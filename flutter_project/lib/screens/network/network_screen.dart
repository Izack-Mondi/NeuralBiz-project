import 'package:flutter/material.dart';

import '../../widgets/feedback/nexify_empty_state.dart';
import '../../widgets/feedback/nexify_error_state.dart';
import '../../widgets/feedback/nexify_loading.dart';

class NetworkScreen extends StatefulWidget {
  const NetworkScreen({super.key});

  @override
  State<NetworkScreen> createState() => _NetworkScreenState();
}

class _NetworkScreenState extends State<NetworkScreen> {
  bool _isLoading = true;
  bool _hasLoadError = false;

  @override
  void initState() {
    super.initState();
    _loadNetworkData();
  }

  Future<void> _loadNetworkData() async {
    setState(() {
      _isLoading = true;
      _hasLoadError = false;
    });

    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    setState(() => _isLoading = false);
  }

  Future<void> _retryLoad() async {
    await _loadNetworkData();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> connections = [
      {
        'name': 'Grace Wanjiku',
        'role': 'Maize Farmer',
        'location': 'Kiambu, Kenya',
        'mutual': '12 mutual connections',
      },
      {
        'name': 'John Kamau',
        'role': 'Agri-Supplier',
        'location': 'Nakuru, Kenya',
        'mutual': '8 mutual connections',
      },
      {
        'name': 'Peter Odhiambo',
        'role': 'Agri-Consultant',
        'location': 'Kisumu, Kenya',
        'mutual': '9 mutual connections',
      },
    ];

    final List<Map<String, dynamic>> pending = [
      {
        'name': 'Samuel Kiprotich',
        'role': 'Cereal Farmer',
        'location': 'Eldoret, Kenya',
        'mutual': '7 mutual connections',
      },
      {
        'name': 'Caroline Atieno',
        'role': 'Agri-Product Trader',
        'location': 'Migori, Kenya',
        'mutual': '5 mutual connections',
      },
    ];

    final List<Map<String, dynamic>> suggested = [
      {
        'name': 'Mercy Njeri',
        'role': 'Poultry Farmer',
        'location': 'Nakuru, Kenya',
      },
      {
        'name': 'David Mutua',
        'role': 'Agri-Equipment Supplier',
        'location': 'Kisumu, Kenya',
      },
      {
        'name': 'Esther Mwangi',
        'role': 'Organic Produce Buyer',
        'location': 'Nairobi, Kenya',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 21),
          tooltip: 'Back',
        ),
        title: const Text(
          'Network',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A0F1C),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: Colors.white70, size: 22),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Search users by name, username, skills, sector, location...',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Grow your connections. Grow your opportunities.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 18),
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: NexifyLoading(size: 32)),
                )
              else if (_hasLoadError)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: NexifyErrorState(
                    title: 'Something went wrong',
                    message: 'We could not load your network suggestions.',
                    onRetry: _retryLoad,
                  ),
                )
              else ...[
                _buildSectionHeader('Connections', 'See all'),
                const SizedBox(height: 10),
                if (connections.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: NexifyEmptyState(
                      title: 'No connections yet',
                      message: 'Your Nexify connections will appear here.',
                      icon: Icons.people_outline,
                    ),
                  )
                else
                  _buildProfileList(connections, isConnection: true),
                const SizedBox(height: 18),
                _buildSectionHeader('Pending Requests', 'See all'),
                const SizedBox(height: 10),
                if (pending.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: NexifyEmptyState(
                      title: 'No pending requests',
                      message: 'New connection requests will appear here.',
                      icon: Icons.schedule_outlined,
                    ),
                  )
                else
                  _buildPendingList(pending),
                const SizedBox(height: 18),
                _buildSectionHeader('People You May Know', 'See all'),
                const SizedBox(height: 10),
                if (suggested.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: NexifyEmptyState(
                      title: 'No suggestions right now',
                      message: 'Try checking back later for new people to connect with.',
                      icon: Icons.person_add_alt_1_outlined,
                    ),
                  )
                else
                  _buildSuggestedList(suggested),
                const SizedBox(height: 18),
                _buildSectionHeader('Suggested Groups', 'See all'),
                const SizedBox(height: 10),
                _buildGroupList(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String action) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        Text(
          action,
          style: const TextStyle(
            color: Color(0xFF22C55E),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileList(List<Map<String, dynamic>> items, {required bool isConnection}) {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            width: 170,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0A0F1C),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E).withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Color(0xFF22C55E),
                        size: 20,
                      ),
                    ),
                    const Spacer(),
                    if (isConnection)
                      const Icon(
                        Icons.verified,
                        color: Color(0xFF22C55E),
                        size: 16,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  item['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item['role'],
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  item['location'],
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 10),
                if (isConnection)
                  Text(
                    item['mutual'],
                    style: const TextStyle(
                      color: Color(0xFF22C55E),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPendingList(List<Map<String, dynamic>> items) {
    return Column(
      children: items.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF0A0F1C),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: Color(0xFF22C55E), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['role'],
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['location'],
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Respond',
                  style: TextStyle(
                    color: Color(0xFF22C55E),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSuggestedList(List<Map<String, dynamic>> items) {
    return Column(
      children: items.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF0A0F1C),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_outline, color: Color(0xFF22C55E), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['role'],
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['location'],
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              FilledButton.tonal(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF22C55E),
                  foregroundColor: Colors.black,
                  minimumSize: const Size(88, 36),
                ),
                child: const Text('Connect'),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGroupList() {
    final groups = [
      'Nairobi Agri Community',
      'Farmers & Buyers Kenya',
      'Smart Food Supply Circle',
    ];

    return Column(
      children: groups.map((group) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF0A0F1C),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.groups_outlined, color: Color(0xFF22C55E), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  group,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white70),
            ],
          ),
        );
      }).toList(),
    );
  }
}
