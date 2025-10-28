import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:inta_mobile_pms/core/config/responsive_config.dart';
import 'package:inta_mobile_pms/features/reservations/models/guest_item.dart';
import 'package:inta_mobile_pms/features/reservations/models/update_guest_payload.dart';
import 'package:inta_mobile_pms/features/reservations/viewmodels/edit_guest_details_vm.dart';
import 'package:intl/intl.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/core/theme/app_text_theme.dart';

enum GuestType { adult, child }

enum Gender { male, female, other }

class EditGuestDetails extends StatefulWidget {
  final GuestItem? guestItem;
  const EditGuestDetails({super.key, required this.guestItem});

  @override
  State<EditGuestDetails> createState() => _EditGuestDetailsState();
}

class _EditGuestDetailsState extends State<EditGuestDetails>
    with SingleTickerProviderStateMixin {
  final _editGuestDetailsVm = Get.find<EditGuestDetailsVm>();
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;
  bool _isSaving = false;
  String _title = '';

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _faxController = TextEditingController();
  final TextEditingController _registrationNoController =
      TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _issuingCityController = TextEditingController();
  final TextEditingController _birthCityController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();

  // Selections
  GuestType _guestType = GuestType.adult;
  Gender _gender = Gender.male;
  String? _country = 'Sri Lanka';
  String? _idType;
  String? _issuingCountry;
  String? _nationality = 'Sri Lanka';
  String? _vipStatus;
  String? _birthCountry;
  String? _purposeOfVisit;

  // Dates
  DateTime? _expiryDate;
  DateTime? _birthDate;
  DateTime? _spouseBirthDate;
  DateTime? _weddingAnniversary;

  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final guestDetails = widget.guestItem;
      if (mounted && guestDetails != null) {
        await _editGuestDetailsVm.loadGuestDetails(guestDetails);

        _nameController.text = guestDetails.guestName;
        _addressController.text = guestDetails.fullAddress ?? '';
        _cityController.text =
            guestDetails.cityName ?? guestDetails.zipCode ?? '';
        _mobileNoController.text = guestDetails.mobile ?? '';
        _phoneNoController.text = guestDetails.phone ?? '';
        _emailController.text = guestDetails.email ?? '';
        _faxController.text = guestDetails.fax ?? '';
        _registrationNoController.text = guestDetails.resId;
        _idNumberController.text = guestDetails.idNumber ?? '';
        _issuingCityController.text = _editGuestDetailsVm.getCity(
          guestDetails.identityIssuingCityId,
        );
        _companyController.text = guestDetails.company ?? '';
        _birthCityController.text = _editGuestDetailsVm.getCity(
          guestDetails.birthCityId,
        );

        setState(() {
          _guestType = switch (guestDetails.isAdult!) {
            true => GuestType.adult,
            false => GuestType.child,
          };
          _gender = switch (guestDetails.gender) {
            'Male' => Gender.male,
            'Female' => Gender.female,
            'Other' => Gender.other,
            _ => Gender.other,
          };
          _title = _editGuestDetailsVm.getTitle(guestDetails.titleId);
             
          _idType = _editGuestDetailsVm.getIdType(guestDetails.identityType);
          _issuingCountry = _editGuestDetailsVm.getCountry(
            guestDetails.identityIssuingCountryId,
          );
          if (guestDetails.vipStatusId != null) {
        
            _vipStatus = _editGuestDetailsVm.getVipStatus(guestDetails.vipStatusId);
          }

          _nationality = _editGuestDetailsVm.getNationality(
            guestDetails.nationalityId,
          );
          if (guestDetails.dateofBirth!.isNotEmpty) {
            _birthDate = _editGuestDetailsVm.getDateTime(
              guestDetails.dateofBirth!,
            );
          }

          if (guestDetails.anniversaryDate!.isNotEmpty) {
            _birthDate = _editGuestDetailsVm.getDateTime(
              guestDetails.anniversaryDate!,
            );
          }
          if (guestDetails.spouseDateofBirth!.isNotEmpty) {
            _birthDate = _editGuestDetailsVm.getDateTime(
              guestDetails.spouseDateofBirth!,
            );
          }
        });
      }
    });
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _mobileNoController.dispose();
    _phoneNoController.dispose();
    _emailController.dispose();
    _faxController.dispose();
    _registrationNoController.dispose();
    _idNumberController.dispose();
    _issuingCityController.dispose();
    _birthCityController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
    BuildContext context,
    DateTime? initialDate,
    Function(DateTime) onDateSelected,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.onPrimary,
              surface: AppColors.surface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }

  Future<void> _handleSave() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);

      final guestDetails = widget.guestItem;
      final gender = switch (_gender) {
        Gender.male => 'Male',
        Gender.female => 'Female',
        Gender.other => 'Other',
      };

      final isAdult = switch (_guestType) {
        GuestType.adult => true,
        GuestType.child => false,
      };

      if (guestDetails != null) {
        await _editGuestDetailsVm.updateGuestDetails(
          UpdateGuestPayload(
            guestId: guestDetails.guestId,
            firstName: _nameController.text,
            lastName: '',
            email: _emailController.text,
            mobile: _mobileNoController.text,
            homeTel: _phoneNoController.text,
            phone1: '',
            phone2: '',
            address1: _addressController.text,
            fullAddress: _addressController.text,
            cityId: _editGuestDetailsVm.getCityId(_cityController.text),
            state: guestDetails.state,
            countryId: _editGuestDetailsVm.getCountryId(_country),
            zipCode: guestDetails.zipCode,
            gender: gender,
            isAdult: isAdult,
            isBlackListed: guestDetails.isBlackListed,
            isMainGuest: guestDetails.isMainGuest,
            identityNumber: _idNumberController.text,
            identityType: _editGuestDetailsVm.getIdentidyTypeId(_idType),
            identityIssuingCityId: _editGuestDetailsVm.getCityId(_issuingCityController.text),
            identityIssuingCountryId: _editGuestDetailsVm.getCountryId(_issuingCountry),
            imagePath: guestDetails.imagePath,
            titleId: _editGuestDetailsVm.getTitleId(_title),
            vipStatusId:_editGuestDetailsVm.getVipStatusId(_vipStatus),
            vIPStatusId: _editGuestDetailsVm.getVipStatusId(_vipStatus),
            workPlace: guestDetails.workPlace,
            salutation: 0,
            blackListedReason: '',
            designation:'',
            remark:guestDetails.remarks,
            fax: _faxController.text,
            specialReq:'',
            registrationId: "0",
            formOfCommunication: 0,
            birthCityId: _editGuestDetailsVm.getCityId(_birthCityController.text),
            birthCountryId: _editGuestDetailsVm.getCountryId(_birthCountry),
            dateofBirth: _birthDate != null ? _birthDate.toString() : '',
            spouseDateofBirth: _spouseBirthDate != null ?  _spouseBirthDate.toString() : '',
            anniversaryDate:_weddingAnniversary != null ? _weddingAnniversary.toString() : '',
            guestAddresses: [],
            alllergies:'',
            civilStatus:'',
            expiryDate: _expiryDate != null ? _expiryDate.toString() : '',
            guestIdentityImage:  guestDetails.imagePath,
            nationalityId: _editGuestDetailsVm.getNationalityId(_nationality),
            status: int.tryParse(guestDetails.status!),
            swipeCardId:guestDetails.swipeCardId.toString(),
          ),
        );

        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).brightness == Brightness.light
        ? AppTextTheme.lightTextTheme
        : AppTextTheme.darkTextTheme;
    final padding = ResponsiveConfig.horizontalPadding(context);
    final verticalSpacing = ResponsiveConfig.listItemSpacing(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Edit Guest Details', style: textTheme.titleLarge),
        centerTitle: true,
        leading: const SizedBox.shrink(),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Close',
          ),
        ],
        backgroundColor: AppColors.surface,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: AppColors.surface,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.darkgrey,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              labelStyle: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: textTheme.titleSmall,
              tabs: const [
                Tab(text: 'Guest Info'),
                Tab(text: 'Contact'),
                Tab(text: 'Identity'),
                Tab(text: 'Other'),
              ],
            ),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildGuestInfoTab(padding, verticalSpacing, textTheme),
            _buildContactTab(padding, verticalSpacing, textTheme),
            _buildIdentityTab(padding, verticalSpacing, textTheme),
            _buildOtherTab(padding, verticalSpacing, textTheme),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(padding, verticalSpacing, textTheme),
    );
  }

  Widget _buildGuestInfoTab(
    EdgeInsets padding,
    double spacing,
    TextTheme textTheme,
  ) {
    return SingleChildScrollView(
      padding: padding.copyWith(top: spacing * 1.5, bottom: spacing * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionCard(
            children: [
              _buildTextField(
                controller: _nameController,
                label: 'Full Name',
                icon: Icons.person_outline,
                isRequired: true,
                prefixText: '${_title} ',
              ),
              SizedBox(height: spacing * 1.5),
              _buildModernRadioGroup<GuestType>(
                label: 'Guest Type',
                value: _guestType,
                items: const [
                  (GuestType.adult, 'Adult', Icons.person),
                  (GuestType.child, 'Child', Icons.child_care),
                ],
                onChanged: (val) => setState(() => _guestType = val!),
              ),
              SizedBox(height: spacing * 1.5),
              _buildModernRadioGroup<Gender>(
                label: 'Gender',
                value: _gender,
                items: const [
                  (Gender.male, 'Male', Icons.male),
                  (Gender.female, 'Female', Icons.female),
                  (Gender.other, 'Other', Icons.transgender),
                ],
                onChanged: (val) => setState(() => _gender = val!),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactTab(
    EdgeInsets padding,
    double spacing,
    TextTheme textTheme,
  ) {
    return SingleChildScrollView(
      padding: padding.copyWith(top: spacing * 1.5, bottom: spacing * 2),
      child: Column(
        children: [
          _buildSectionCard(
            children: [
              _buildTextField(
                controller: _addressController,
                label: 'Address',
                icon: Icons.home_outlined,
                maxLines: 2,
              ),
              SizedBox(height: spacing * 1.5),
              Obx(
                () => _buildDropdown(
                  value: _country,
                  items: _editGuestDetailsVm.countries,
                  label: 'Country',
                  icon: Icons.public,
                  onChanged: (val) => setState(() => _country = val),
                ),
              ),

              SizedBox(height: spacing * 1.5),
              _buildTextField(
                controller: _cityController,
                label: 'City / Postal Code',
                icon: Icons.location_city,
              ),
              SizedBox(height: spacing * 1.5),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _mobileNoController,
                      label: 'Mobile',
                      icon: Icons.phone_android,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  SizedBox(width: spacing),
                  Expanded(
                    child: _buildTextField(
                      controller: _phoneNoController,
                      label: 'Phone',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing * 1.5),
              _buildTextField(
                controller: _emailController,
                label: 'Email Address',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: spacing * 1.5),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _faxController,
                      label: 'Fax',
                      icon: Icons.print_outlined,
                    ),
                  ),
                  SizedBox(width: spacing),
                  Expanded(
                    child: _buildTextField(
                      controller: _registrationNoController,
                      label: 'Registration No',
                      icon: Icons.confirmation_number_outlined,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIdentityTab(
    EdgeInsets padding,
    double spacing,
    TextTheme textTheme,
  ) {
    return SingleChildScrollView(
      padding: padding.copyWith(top: spacing * 1.5, bottom: spacing * 2),
      child: Column(
        children: [
          _buildSectionCard(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Obx(() {
                      // Ensure _idType exists in the list, otherwise set to null
                      final currentValue =
                          _editGuestDetailsVm.idTypes.contains(_idType)
                          ? _idType
                          : null;

                      return _buildDropdown(
                        value: currentValue,
                        items: _editGuestDetailsVm.idTypes
                            .toList(), // convert RxList to normal List
                        label: 'ID Type',
                        icon: Icons.badge_outlined,
                        onChanged: (val) => setState(() => _idType = val),
                      );
                    }),
                  ),

                  SizedBox(width: spacing),
                  Expanded(
                    child: _buildTextField(
                      controller: _idNumberController,
                      label: 'ID Number',
                      icon: Icons.numbers,
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing * 1.5),
              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => _buildDropdown(
                        value: _issuingCountry,
                        items: _editGuestDetailsVm.countries,
                        label: 'Issuing Country',
                        icon: Icons.flag_outlined,
                        onChanged: (val) => _issuingCountry = val,
                      ),
                    ),
                  ),

                  SizedBox(width: spacing),
                  Expanded(
                    child: _buildTextField(
                      controller: _issuingCityController,
                      label: 'Issuing City',
                      icon: Icons.location_on_outlined,
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing * 1.5),
              _buildDateField(
                label: 'Expiry Date',
                date: _expiryDate,
                icon: Icons.event_outlined,
                onDateSelected: (date) => setState(() => _expiryDate = date),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOtherTab(
    EdgeInsets padding,
    double spacing,
    TextTheme textTheme,
  ) {
    return SingleChildScrollView(
      padding: padding.copyWith(top: spacing * 1.5, bottom: spacing * 2),
      child: Column(
        children: [
          _buildSectionCard(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Obx(() {
                      return _buildDropdown(
                        value: _nationality,
                        items: _editGuestDetailsVm.nationalityNames.toList(),
                        label: 'Nationality',
                        icon: Icons.language,
                        onChanged: (val) => setState(() => _nationality = val),
                      );
                    }),
                  ),

                  SizedBox(width: spacing),
                  Expanded(
                    child: Obx(() {
                      return _buildDropdown(
                        value: _vipStatus,
                        items: _editGuestDetailsVm.vipStatuses.toList(),
                        label: 'VIP Status',
                        icon: Icons.star_outline,
                        onChanged: (val) => setState(() => _vipStatus = val),
                      );
                    }),
                  ),
                ],
              ),
              SizedBox(height: spacing * 1.5),
              _buildDateField(
                label: 'Birth Date',
                date: _birthDate,
                icon: Icons.cake_outlined,
                onDateSelected: (date) => setState(() => _birthDate = date),
              ),
              SizedBox(height: spacing * 1.5),
              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => _buildDropdown(
                        value: _birthCountry,
                        items: _editGuestDetailsVm.countries,
                        label: 'Birth Country',
                        icon: Icons.place_outlined,
                        onChanged: (val) => _birthCountry = val,
                      ),
                    ),
                  ),

                  SizedBox(width: spacing),
                  Expanded(
                    child: _buildTextField(
                      controller: _birthCityController,
                      label: 'Birth City',
                      icon: Icons.location_city_outlined,
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing * 1.5),
              _buildDateField(
                label: 'Spouse Birth Date',
                date: _spouseBirthDate,
                icon: Icons.favorite_outline,
                onDateSelected: (date) =>
                    setState(() => _spouseBirthDate = date),
              ),
              SizedBox(height: spacing * 1.5),
              _buildDateField(
                label: 'Wedding Anniversary',
                date: _weddingAnniversary,
                icon: Icons.favorite,
                onDateSelected: (date) =>
                    setState(() => _weddingAnniversary = date),
              ),
              SizedBox(height: spacing * 1.5),
              _buildTextField(
                controller: _companyController,
                label: 'Company',
                icon: Icons.business_outlined,
              ),
              // SizedBox(height: spacing * 1.5),
              // _buildDropdown(
              //   value: _purposeOfVisit,
              //   items: _purposes,
              //   label: 'Purpose of Visit',
              //   icon: Icons.flight_takeoff,
              //   onChanged: (val) => setState(() => _purposeOfVisit = val),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required List<Widget> children}) {
    return Container(
      padding: EdgeInsets.all(ResponsiveConfig.scaleWidth(context, 20)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(
          ResponsiveConfig.cardRadius(context),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isRequired = false,
    String? prefixText,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label + (isRequired ? ' *' : ''),
        prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
        prefixText: prefixText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.lightgrey.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.lightgrey.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      validator: (value) => isRequired && (value == null || value.isEmpty)
          ? 'This field is required'
          : null,
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required String label,
    required IconData icon,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.lightgrey.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.lightgrey.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required IconData icon,
    required Function(DateTime) onDateSelected,
  }) {
    return InkWell(
      onTap: () => _selectDate(context, date, onDateSelected),
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
          suffixIcon: const Icon(Icons.calendar_today, size: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.lightgrey.withOpacity(0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.lightgrey.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        child: Text(
          date != null ? _dateFormat.format(date) : 'Select date',
          style: TextStyle(
            color: date != null ? Colors.black87 : AppColors.lightgrey,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildModernRadioGroup<T>({
    required String label,
    required T value,
    required List<(T, String, IconData)> items,
    required Function(T?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.darkgrey,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: items.map((item) {
            final isSelected = value == item.$1;
            return InkWell(
              onTap: () => onChanged(item.$1),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withOpacity(0.1)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.lightgrey.withOpacity(0.3),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.$3,
                      size: 18,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.darkgrey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item.$2,
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.darkgrey,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBottomBar(
    EdgeInsets padding,
    double spacing,
    TextTheme textTheme,
  ) {
    return Container(
      padding: padding.copyWith(top: spacing, bottom: spacing * 1.5),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Cancel',
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(width: spacing),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed:  _handleSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 2,
              ),
              child: _isSaving
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.onPrimary,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Save Changes',
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
