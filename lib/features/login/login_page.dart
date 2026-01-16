import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:inta_mobile_pms/core/config/responsive_config.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/services/apiServices/user_api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String _version = '0.0.0.0';
  String _logo = '';
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _hotelIdController = TextEditingController();

  final UserApiService _userApiService = Get.find<UserApiService>();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final v = await _userApiService.getVersion;
      final logo = await _userApiService.getIconPath;
      setState(() {
        _version = v;
        _logo = logo;
      });
    });
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _hotelIdController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await _userApiService.login(
      _usernameController.text,
      _passwordController.text,
      _hotelIdController.text,
    );
    setState(() => _isLoading = false);
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  String? _validateHotelId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Hotel ID is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: ResponsiveConfig.horizontalPadding(context),
                child: Column(
                  children: [
                    // Logo Section
                    if (!isKeyboardVisible) ...[
                      SizedBox(
                        height: ResponsiveConfig.scaleHeight(context, 60),
                      ),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildLogoSection(context),
                      ),
                    ],

                    SizedBox(
                      height: ResponsiveConfig.scaleHeight(
                        context,
                        isKeyboardVisible ? 40 : 80,
                      ),
                    ),

                    // Login Form
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildLoginForm(context, theme),
                      ),
                    ),

                    const Spacer(),

                    // Footer
                    if (!isKeyboardVisible)
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildFooter(context),
                      ),

                    SizedBox(height: ResponsiveConfig.defaultPadding(context)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection(BuildContext context) {
    return Column(
      children: [
        // App Logo (just the image)
        Image.asset(
          _logo, // path to your image
          height: ResponsiveConfig.scaleHeight(context, 120),
          width: ResponsiveConfig.scaleWidth(context, 120),
          fit: BoxFit.contain,
        ),
        SizedBox(height: ResponsiveConfig.scaleHeight(context, 24)),

        // Welcome Text
        Text(
          'Welcome to Inta PMS Mobile',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.darkgrey,
            fontSize:
                ResponsiveConfig.scaleWidth(context, 18) *
                ResponsiveConfig.fontScale(context),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: ResponsiveConfig.scaleHeight(context, 8)),
        Text(
          'Welcome back! Please sign in to continue.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.lightgrey,
            fontSize:
                ResponsiveConfig.scaleWidth(context, 14) *
                ResponsiveConfig.fontScale(context),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Widget _buildLogoSection(BuildContext context) {
  //   return Column(
  //     children: [
  //       // App Logo
  //       Container(
  //         height: ResponsiveConfig.scaleHeight(context, 120),
  //         width: ResponsiveConfig.scaleWidth(context, 120),
  //         decoration: BoxDecoration(
  //           color: AppColors.primary,
  //           borderRadius: BorderRadius.circular(
  //             ResponsiveConfig.cardRadius(context) * 1.5,
  //           ),
  //           boxShadow: [
  //             BoxShadow(
  //               color: AppColors.primary.withOpacity(0.3),
  //               blurRadius: 20,
  //               offset: const Offset(0, 8),
  //             ),
  //           ],
  //         ),
  //         child: Center(
  //           child: Text(
  //             'INTA',
  //             style: Theme.of(context).textTheme.titleLarge?.copyWith(
  //               color: AppColors.onPrimary,
  //               fontWeight: FontWeight.bold,
  //               fontSize: ResponsiveConfig.scaleWidth(context, 28),
  //             ),
  //           ),
  //         ),
  //       ),
  //       SizedBox(height: ResponsiveConfig.scaleHeight(context, 24)),

  //       // Welcome Text
  //       Text(
  //         'Welcome to Inta PMS Mobile',
  //         style: Theme.of(context).textTheme.titleMedium?.copyWith(
  //           color: AppColors.darkgrey,
  //           fontSize:
  //               ResponsiveConfig.scaleWidth(context, 18) *
  //               ResponsiveConfig.fontScale(context),
  //         ),
  //         textAlign: TextAlign.center,
  //       ),
  //       SizedBox(height: ResponsiveConfig.scaleHeight(context, 8)),
  //       Text(
  //         'Welcome back! Please sign in to continue.',
  //         style: Theme.of(context).textTheme.bodyMedium?.copyWith(
  //           color: AppColors.lightgrey,
  //           fontSize:
  //               ResponsiveConfig.scaleWidth(context, 14) *
  //               ResponsiveConfig.fontScale(context),
  //         ),
  //         textAlign: TextAlign.center,
  //       ),
  //     ],
  //   );
  // }

  Widget _buildLoginForm(BuildContext context, ThemeData theme) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: ResponsiveConfig.isDesktop(context) ? 400 : double.infinity,
      ),
      padding: EdgeInsets.all(ResponsiveConfig.defaultPadding(context) * 1.5),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(
          ResponsiveConfig.cardRadius(context) * 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Username Field
            _buildInputField(
              controller: _usernameController,
              label: 'Username',
              hint: 'Enter your username',
              prefixIcon: Icons.person,
              keyboardType: TextInputType.text,
              validator: _validateUsername,
              textInputAction: TextInputAction.next,
            ),

            SizedBox(height: ResponsiveConfig.scaleHeight(context, 20)),

            // Password Field
            _buildInputField(
              controller: _passwordController,
              label: 'Password',
              hint: 'Enter your password',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
              validator: _validatePassword,
              textInputAction: TextInputAction.next,
            ),

            SizedBox(height: ResponsiveConfig.scaleHeight(context, 16)),

            // Hotel ID Field
            _buildInputField(
              controller: _hotelIdController,
              label: 'Hotel ID',
              hint: 'Enter the Hotel ID',
              prefixIcon: Icons.hotel,
              keyboardType: TextInputType.text,
              validator: _validateHotelId,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _handleLogin(),
            ),

            SizedBox(height: ResponsiveConfig.scaleHeight(context, 16)),

            SizedBox(height: ResponsiveConfig.scaleHeight(context, 32)),

            _buildLoginButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData prefixIcon,
    bool isPassword = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    TextInputAction? textInputAction,
    void Function(String)? onFieldSubmitted,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.darkgrey,
            fontWeight: FontWeight.w500,
            fontSize:
                ResponsiveConfig.scaleWidth(context, 14) *
                ResponsiveConfig.fontScale(context),
          ),
        ),
        SizedBox(height: ResponsiveConfig.scaleHeight(context, 8)),
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: controller,
          obscureText: isPassword && !_isPasswordVisible,
          keyboardType: keyboardType,
          validator: validator,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(
              prefixIcon,
              color: AppColors.lightgrey,
              size: ResponsiveConfig.iconSize(context),
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.lightgrey,
                      size: ResponsiveConfig.iconSize(context),
                    ),
                    onPressed: () {
                      setState(() => _isPasswordVisible = !_isPasswordVisible);
                      HapticFeedback.lightImpact();
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                ResponsiveConfig.cardRadius(context),
              ),
              borderSide: const BorderSide(
                color: AppColors.lightgrey,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                ResponsiveConfig.cardRadius(context),
              ),
              borderSide: BorderSide(
                color: AppColors.lightgrey.withOpacity(0.5),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                ResponsiveConfig.cardRadius(context),
              ),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                ResponsiveConfig.cardRadius(context),
              ),
              borderSide: const BorderSide(color: AppColors.error, width: 1),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: ResponsiveConfig.scaleWidth(context, 16),
              vertical: ResponsiveConfig.scaleHeight(context, 16),
            ),
            filled: true,
            fillColor: AppColors.background.withOpacity(0.3),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading
          ? null
          : () async {
              await _handleLogin();
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 4,
        shadowColor: AppColors.primary.withOpacity(0.4),
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveConfig.scaleHeight(context, 16),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            ResponsiveConfig.cardRadius(context),
          ),
        ),
      ),
      child: _isLoading
          ? SizedBox(
              height: ResponsiveConfig.scaleHeight(context, 20),
              width: ResponsiveConfig.scaleWidth(context, 20),
              child: const CircularProgressIndicator(
                color: AppColors.onPrimary,
                strokeWidth: 2,
              ),
            )
          : Text(
              'Sign In',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.w600,
                fontSize:
                    ResponsiveConfig.scaleWidth(context, 16) *
                    ResponsiveConfig.fontScale(context),
              ),
            ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        // Divider with text
        Row(
          children: [
            Expanded(
              child: Divider(color: AppColors.lightgrey.withOpacity(0.5)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveConfig.scaleWidth(context, 16),
              ),
              child: Text(
                'Need Help?',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.lightgrey,
                  fontSize:
                      ResponsiveConfig.scaleWidth(context, 12) *
                      ResponsiveConfig.fontScale(context),
                ),
              ),
            ),
            Expanded(
              child: Divider(color: AppColors.lightgrey.withOpacity(0.5)),
            ),
          ],
        ),

        SizedBox(height: ResponsiveConfig.scaleHeight(context, 16)),

        // Support Button
        TextButton.icon(
          onPressed: () {
            HapticFeedback.lightImpact();
            // Handle support contact
          },
          icon: Icon(
            Icons.support_agent,
            color: AppColors.primary,
            size: ResponsiveConfig.iconSize(context),
          ),
          label: Text(
            'Contact Support',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
              fontSize:
                  ResponsiveConfig.scaleWidth(context, 14) *
                  ResponsiveConfig.fontScale(context),
            ),
          ),
        ),

        SizedBox(height: ResponsiveConfig.scaleHeight(context, 16)),

        // Version Info
        Text(
          'Inta PMS v${_version}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.lightgrey,
            fontSize:
                ResponsiveConfig.scaleWidth(context, 11) *
                ResponsiveConfig.fontScale(context),
          ),
        ),
      ],
    );
  }
}
