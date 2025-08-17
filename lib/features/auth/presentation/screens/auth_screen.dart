import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/strings.dart';
import '../../../../global/state/auth_notifier.dart';
import '../widgets/login_form.dart';
import '../widgets/register_form.dart';

/// Authentication screen for login and registration
class AuthScreen extends StatefulWidget {
  /// Default constructor
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  Future<void> _handleLogin(String email, String password) async {
    if (_isLoading) return;
    
    _setLoading(true);
    try {
      await Provider.of<AuthNotifier>(context, listen: false)
          .login(email: email, password: password);
      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _handleRegister(String name, String email, String password) async {
    if (_isLoading) return;
    
    _setLoading(true);
    try {
      await Provider.of<AuthNotifier>(context, listen: false)
          .register(name: name, email: email, password: password);
      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      _setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header and logo
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // App logo
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        'A',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // App name
                  Text(
                    AppStrings.appName,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  // App tagline
                  Text(
                    AppStrings.appTagline,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            // Tab Bar
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Login'),
                Tab(text: 'Register'),
              ],
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.primary,
            ),
            
            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Login tab
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: LoginForm(
                      onLogin: _handleLogin,
                      isLoading: _isLoading,
                    ),
                  ),
                  
                  // Register tab
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: RegisterForm(
                      onRegister: _handleRegister,
                      isLoading: _isLoading,
                    ),
                  ),
                ],
              ),
            ),
            
            // Skip button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: TextButton(
                onPressed: () {
                  Provider.of<AuthNotifier>(context, listen: false)
                      .setRequireLogin(false);
                  context.go('/home');
                },
                child: const Text('Skip for now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
