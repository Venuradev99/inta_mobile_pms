import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:inta_mobile_pms/core/config/responsive_config.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/productActivation/viewmodels/product_activation_vm.dart';

class ProductActivation extends StatefulWidget {
  const ProductActivation({Key? key}) : super(key: key);

  @override
  State<ProductActivation> createState() => _ProductActivationState();
}

class _ProductActivationState extends State<ProductActivation>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _keyController = TextEditingController();

  final ProductActivationVm _productActivationVm = Get.find<ProductActivationVm>();

  bool _isLoading = false;
  String _logo = '';

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final logo = await _productActivationVm.getIconPath;
      setState(() {
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
    _keyController.dispose();
    super.dispose();
  }

  Future<void> _handleActivation() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await _productActivationVm.activate(
      _keyController.text,
    );
    setState(() => _isLoading = false);
  }

  String? _validateKey(String? value) {
    if (value == null || value.isEmpty) {
      return 'Activation key is required';
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
                        height: ResponsiveConfig.scaleHeight(context, 30),
                      ),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildLogoSection(context),
                      ),
                    ],

                    SizedBox(height: ResponsiveConfig.scaleHeight(context, 10)),

                    // Activation Form
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildActivationForm(context, theme),
                      ),
                    ),

                    const Spacer(),

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
        if (_logo.isNotEmpty)
          Image.asset(
            _logo,
            height: ResponsiveConfig.scaleHeight(context, 120),
            width: ResponsiveConfig.scaleWidth(context, 120),
            fit: BoxFit.contain,
          )
        else
          const SizedBox(height: 120),
        Text(
          'Product Activation',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.darkgrey,
            fontSize:
                ResponsiveConfig.scaleWidth(context, 18) *
                ResponsiveConfig.fontScale(context),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildActivationForm(BuildContext context, ThemeData theme) {
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
            // Activation Key Field
            _buildInputField(
              controller: _keyController,
              label: 'Activation Key',
              hint: 'Enter your activation key',
              prefixIcon: Icons.key,
              keyboardType: TextInputType.text,
              validator: _validateKey,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _handleActivation(),
            ),

            SizedBox(height: ResponsiveConfig.scaleHeight(context, 32)),

            _buildActivateButton(context),
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

  Widget _buildActivateButton(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading
          ? null
          : () async {
              await _handleActivation();
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
              'Activate',
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
}