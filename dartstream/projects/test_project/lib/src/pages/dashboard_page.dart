import 'package:flutter/material.dart';
import '../services/auth/ping_provider.dart';

/// DashboardPage is a protected route that requires authentication
/// Displays user information and provides logout functionality
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final PingProvider _pingProvider = PingProvider();
  bool _isLoggingOut = false;
  Map<String, dynamic>? _userInfo;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  /// Load user information from Ping Identity
  void _loadUserInfo() {
    setState(() {
      _userInfo = _pingProvider.getUserInfo();
    });
  }

  /// Handle logout button press
  Future<void> _handleLogout() async {
    setState(() {
      _isLoggingOut = true;
    });

    try {
      // Logout and revoke tokens at Ping Identity
      await _pingProvider.logout();

      if (mounted) {
        // Navigate back to login page
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout error: ${e.toString()}'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: _isLoggingOut
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.logout),
            onPressed: _isLoggingOut ? null : _handleLogout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome message
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'You are successfully authenticated via Ping Identity',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // User information section
            Text(
              'User Information',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // User info cards
            if (_userInfo != null) ...[
              _buildInfoCard(
                icon: Icons.person,
                label: 'Name',
                value: _userInfo!['name']?.toString() ?? 'N/A',
              ),
              _buildInfoCard(
                icon: Icons.email,
                label: 'Email',
                value: _userInfo!['email']?.toString() ?? 'N/A',
              ),
              _buildInfoCard(
                icon: Icons.badge,
                label: 'Subject',
                value: _userInfo!['sub']?.toString() ?? 'N/A',
              ),
            ] else
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No user information available'),
                ),
              ),

            const SizedBox(height: 24),

            // Token information section
            Text(
              'Session Information',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            _buildInfoCard(
              icon: Icons.vpn_key,
              label: 'Access Token',
              value: _pingProvider.getAccessToken() != null
                  ? '${_pingProvider.getAccessToken()!.substring(0, 20)}...'
                  : 'N/A',
            ),
            _buildInfoCard(
              icon: Icons.fingerprint,
              label: 'ID Token',
              value: _pingProvider.getIdToken() != null
                  ? '${_pingProvider.getIdToken()!.substring(0, 20)}...'
                  : 'N/A',
            ),
            _buildInfoCard(
              icon: Icons.security,
              label: 'Authentication Status',
              value: _pingProvider.isLoggedIn() ? 'Active' : 'Inactive',
            ),

            const SizedBox(height: 32),

            // Logout button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoggingOut ? null : _handleLogout,
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.red[600],
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build information card widget
  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).primaryColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
