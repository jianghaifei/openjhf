// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Account`
  String get rs_account {
    return Intl.message(
      'Account',
      name: 'rs_account',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get rs_add {
    return Intl.message(
      'Add',
      name: 'rs_add',
      desc: '',
      args: [],
    );
  }

  /// `Select at least one dim.`
  String get rs_add_dim_least_one_tip {
    return Intl.message(
      'Select at least one dim.',
      name: 'rs_add_dim_least_one_tip',
      desc: '',
      args: [],
    );
  }

  /// `Please configure dim for the metric.`
  String get rs_add_dim_tip {
    return Intl.message(
      'Please configure dim for the metric.',
      name: 'rs_add_dim_tip',
      desc: '',
      args: [],
    );
  }

  /// `Please select a metric.`
  String get rs_add_metric_tip {
    return Intl.message(
      'Please select a metric.',
      name: 'rs_add_metric_tip',
      desc: '',
      args: [],
    );
  }

  /// `Add Metrics`
  String get rs_add_metrics {
    return Intl.message(
      'Add Metrics',
      name: 'rs_add_metrics',
      desc: '',
      args: [],
    );
  }

  /// `Advanced`
  String get rs_advanced {
    return Intl.message(
      'Advanced',
      name: 'rs_advanced',
      desc: '',
      args: [],
    );
  }

  /// `Agree`
  String get rs_agree {
    return Intl.message(
      'Agree',
      name: 'rs_agree',
      desc: '',
      args: [],
    );
  }

  /// `Agreed`
  String get rs_agreed {
    return Intl.message(
      'Agreed',
      name: 'rs_agreed',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get rs_all {
    return Intl.message(
      'All',
      name: 'rs_all',
      desc: '',
      args: [],
    );
  }

  /// `All Brands`
  String get rs_all_brands {
    return Intl.message(
      'All Brands',
      name: 'rs_all_brands',
      desc: '',
      args: [],
    );
  }

  /// `Amount not entered`
  String get rs_amount_not_entered {
    return Intl.message(
      'Amount not entered',
      name: 'rs_amount_not_entered',
      desc: '',
      args: [],
    );
  }

  /// `Analysis charts`
  String get rs_analysis_chart {
    return Intl.message(
      'Analysis charts',
      name: 'rs_analysis_chart',
      desc: '',
      args: [],
    );
  }

  /// `Analysis Model`
  String get rs_analysis_model {
    return Intl.message(
      'Analysis Model',
      name: 'rs_analysis_model',
      desc: '',
      args: [],
    );
  }

  /// `Application store`
  String get rs_application_store {
    return Intl.message(
      'Application store',
      name: 'rs_application_store',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get rs_apply {
    return Intl.message(
      'Apply',
      name: 'rs_apply',
      desc: '',
      args: [],
    );
  }

  /// `At least one metric must be displayed`
  String get rs_at_least_display_one_metric {
    return Intl.message(
      'At least one metric must be displayed',
      name: 'rs_at_least_display_one_metric',
      desc: '',
      args: [],
    );
  }

  /// `At least one topic must be displayed`
  String get rs_at_least_display_one_theme {
    return Intl.message(
      'At least one topic must be displayed',
      name: 'rs_at_least_display_one_theme',
      desc: '',
      args: [],
    );
  }

  /// `Basic Settings`
  String get rs_base_settings {
    return Intl.message(
      'Basic Settings',
      name: 'rs_base_settings',
      desc: '',
      args: [],
    );
  }

  /// `My`
  String get rs_bottom_nav_mine {
    return Intl.message(
      'My',
      name: 'rs_bottom_nav_mine',
      desc: '',
      args: [],
    );
  }

  /// `Overview`
  String get rs_bottom_nav_overview {
    return Intl.message(
      'Overview',
      name: 'rs_bottom_nav_overview',
      desc: '',
      args: [],
    );
  }

  /// `By`
  String get rs_by {
    return Intl.message(
      'By',
      name: 'rs_by',
      desc: '',
      args: [],
    );
  }

  /// `Customer service phone numbe`
  String get rs_call_center {
    return Intl.message(
      'Customer service phone numbe',
      name: 'rs_call_center',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get rs_cancel {
    return Intl.message(
      'Cancel',
      name: 'rs_cancel',
      desc: '',
      args: [],
    );
  }

  /// `Cannot be empty`
  String get rs_cannot_be_empty {
    return Intl.message(
      'Cannot be empty',
      name: 'rs_cannot_be_empty',
      desc: '',
      args: [],
    );
  }

  /// `Chart`
  String get rs_chart {
    return Intl.message(
      'Chart',
      name: 'rs_chart',
      desc: '',
      args: [],
    );
  }

  /// `Bar Chart`
  String get rs_chart_bar {
    return Intl.message(
      'Bar Chart',
      name: 'rs_chart_bar',
      desc: '',
      args: [],
    );
  }

  /// `Line graph`
  String get rs_chart_line {
    return Intl.message(
      'Line graph',
      name: 'rs_chart_line',
      desc: '',
      args: [],
    );
  }

  /// `List`
  String get rs_chart_list {
    return Intl.message(
      'List',
      name: 'rs_chart_list',
      desc: '',
      args: [],
    );
  }

  /// `Optional Charts`
  String get rs_chart_optional {
    return Intl.message(
      'Optional Charts',
      name: 'rs_chart_optional',
      desc: '',
      args: [],
    );
  }

  /// `Pie chart`
  String get rs_chart_pie {
    return Intl.message(
      'Pie chart',
      name: 'rs_chart_pie',
      desc: '',
      args: [],
    );
  }

  /// `Sales`
  String get rs_chart_sales {
    return Intl.message(
      'Sales',
      name: 'rs_chart_sales',
      desc: '',
      args: [],
    );
  }

  /// `Chart Type`
  String get rs_chart_type {
    return Intl.message(
      'Chart Type',
      name: 'rs_chart_type',
      desc: '',
      args: [],
    );
  }

  /// `Check`
  String get rs_check {
    return Intl.message(
      'Check',
      name: 'rs_check',
      desc: '',
      args: [],
    );
  }

  /// `Check for New Version`
  String get rs_check_new_version {
    return Intl.message(
      'Check for New Version',
      name: 'rs_check_new_version',
      desc: '',
      args: [],
    );
  }

  /// `Select Date`
  String get rs_choose_date {
    return Intl.message(
      'Select Date',
      name: 'rs_choose_date',
      desc: '',
      args: [],
    );
  }

  /// `Clear All`
  String get rs_clean_all {
    return Intl.message(
      'Clear All',
      name: 'rs_clean_all',
      desc: '',
      args: [],
    );
  }

  /// `Collapse`
  String get rs_collapse {
    return Intl.message(
      'Collapse',
      name: 'rs_collapse',
      desc: '',
      args: [],
    );
  }

  /// `Compare`
  String get rs_compare {
    return Intl.message(
      'Compare',
      name: 'rs_compare',
      desc: '',
      args: [],
    );
  }

  /// `Compare to`
  String get rs_compare_to {
    return Intl.message(
      'Compare to',
      name: 'rs_compare_to',
      desc: '',
      args: [],
    );
  }

  /// `Compared to the previous period`
  String get rs_compare_to_prior {
    return Intl.message(
      'Compared to the previous period',
      name: 'rs_compare_to_prior',
      desc: '',
      args: [],
    );
  }

  /// `Compared`
  String get rs_compared {
    return Intl.message(
      'Compared',
      name: 'rs_compared',
      desc: '',
      args: [],
    );
  }

  /// `Comparison Indicators`
  String get rs_compared_metric {
    return Intl.message(
      'Comparison Indicators',
      name: 'rs_compared_metric',
      desc: '',
      args: [],
    );
  }

  /// `Configuration`
  String get rs_configuration {
    return Intl.message(
      'Configuration',
      name: 'rs_configuration',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get rs_confirm {
    return Intl.message(
      'Confirm',
      name: 'rs_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Company`
  String get rs_corporation {
    return Intl.message(
      'Company',
      name: 'rs_corporation',
      desc: '',
      args: [],
    );
  }

  /// `Currency Type`
  String get rs_currency_types {
    return Intl.message(
      'Currency Type',
      name: 'rs_currency_types',
      desc: '',
      args: [],
    );
  }

  /// `Current`
  String get rs_current {
    return Intl.message(
      'Current',
      name: 'rs_current',
      desc: '',
      args: [],
    );
  }

  /// `Custom`
  String get rs_custom {
    return Intl.message(
      'Custom',
      name: 'rs_custom',
      desc: '',
      args: [],
    );
  }

  /// `Daily average`
  String get rs_daily_average {
    return Intl.message(
      'Daily average',
      name: 'rs_daily_average',
      desc: '',
      args: [],
    );
  }

  /// `Day`
  String get rs_date_day {
    return Intl.message(
      'Day',
      name: 'rs_date_day',
      desc: '',
      args: [],
    );
  }

  /// `Month`
  String get rs_date_month {
    return Intl.message(
      'Month',
      name: 'rs_date_month',
      desc: '',
      args: [],
    );
  }

  /// `Comparison Date`
  String get rs_date_tool_compare_to {
    return Intl.message(
      'Comparison Date',
      name: 'rs_date_tool_compare_to',
      desc: '',
      args: [],
    );
  }

  /// `Current Date`
  String get rs_date_tool_current_date {
    return Intl.message(
      'Current Date',
      name: 'rs_date_tool_current_date',
      desc: '',
      args: [],
    );
  }

  /// `Custom Date`
  String get rs_date_tool_custom {
    return Intl.message(
      'Custom Date',
      name: 'rs_date_tool_custom',
      desc: '',
      args: [],
    );
  }

  /// `Last month`
  String get rs_date_tool_last_month {
    return Intl.message(
      'Last month',
      name: 'rs_date_tool_last_month',
      desc: '',
      args: [],
    );
  }

  /// `Last week`
  String get rs_date_tool_last_week {
    return Intl.message(
      'Last week',
      name: 'rs_date_tool_last_week',
      desc: '',
      args: [],
    );
  }

  /// `Last year`
  String get rs_date_tool_last_year {
    return Intl.message(
      'Last year',
      name: 'rs_date_tool_last_year',
      desc: '',
      args: [],
    );
  }

  /// `The day before`
  String get rs_date_tool_prior_day {
    return Intl.message(
      'The day before',
      name: 'rs_date_tool_prior_day',
      desc: '',
      args: [],
    );
  }

  /// `The previous month`
  String get rs_date_tool_prior_month {
    return Intl.message(
      'The previous month',
      name: 'rs_date_tool_prior_month',
      desc: '',
      args: [],
    );
  }

  /// `The previous week`
  String get rs_date_tool_prior_week {
    return Intl.message(
      'The previous week',
      name: 'rs_date_tool_prior_week',
      desc: '',
      args: [],
    );
  }

  /// `Quick Select`
  String get rs_date_tool_quick {
    return Intl.message(
      'Quick Select',
      name: 'rs_date_tool_quick',
      desc: '',
      args: [],
    );
  }

  /// `This month`
  String get rs_date_tool_this_month {
    return Intl.message(
      'This month',
      name: 'rs_date_tool_this_month',
      desc: '',
      args: [],
    );
  }

  /// `This week`
  String get rs_date_tool_this_week {
    return Intl.message(
      'This week',
      name: 'rs_date_tool_this_week',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get rs_date_tool_today {
    return Intl.message(
      'Today',
      name: 'rs_date_tool_today',
      desc: '',
      args: [],
    );
  }

  /// `Yesterday`
  String get rs_date_tool_yesterday {
    return Intl.message(
      'Yesterday',
      name: 'rs_date_tool_yesterday',
      desc: '',
      args: [],
    );
  }

  /// `Debug`
  String get rs_debug {
    return Intl.message(
      'Debug',
      name: 'rs_debug',
      desc: '',
      args: [],
    );
  }

  /// `Debugging Tool`
  String get rs_debug_tools {
    return Intl.message(
      'Debugging Tool',
      name: 'rs_debug_tools',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get rs_delete {
    return Intl.message(
      'Delete',
      name: 'rs_delete',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete it?`
  String get rs_delete_card_tip {
    return Intl.message(
      'Are you sure you want to delete it?',
      name: 'rs_delete_card_tip',
      desc: '',
      args: [],
    );
  }

  /// `Dimension`
  String get rs_dim {
    return Intl.message(
      'Dimension',
      name: 'rs_dim',
      desc: '',
      args: [],
    );
  }

  /// `Optional Dimensions`
  String get rs_dims_options {
    return Intl.message(
      'Optional Dimensions',
      name: 'rs_dims_options',
      desc: '',
      args: [],
    );
  }

  /// `Disagree`
  String get rs_disagree {
    return Intl.message(
      'Disagree',
      name: 'rs_disagree',
      desc: '',
      args: [],
    );
  }

  /// `Presentation dimension`
  String get rs_display_dim {
    return Intl.message(
      'Presentation dimension',
      name: 'rs_display_dim',
      desc: '',
      args: [],
    );
  }

  /// `Distribution method`
  String get rs_distribution_method {
    return Intl.message(
      'Distribution method',
      name: 'rs_distribution_method',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get rs_edit {
    return Intl.message(
      'Edit',
      name: 'rs_edit',
      desc: '',
      args: [],
    );
  }

  /// `The current edits will not be saved after returning.`
  String get rs_edit_page_back_tip {
    return Intl.message(
      'The current edits will not be saved after returning.',
      name: 'rs_edit_page_back_tip',
      desc: '',
      args: [],
    );
  }

  /// `Using the template will overwrite all content under the current theme.`
  String get rs_edit_page_reset_template_tip {
    return Intl.message(
      'Using the template will overwrite all content under the current theme.',
      name: 'rs_edit_page_reset_template_tip',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get rs_email {
    return Intl.message(
      'Email',
      name: 'rs_email',
      desc: '',
      args: [],
    );
  }

  /// `Employee Code`
  String get rs_employee_code {
    return Intl.message(
      'Employee Code',
      name: 'rs_employee_code',
      desc: '',
      args: [],
    );
  }

  /// `Employee ID`
  String get rs_employee_id {
    return Intl.message(
      'Employee ID',
      name: 'rs_employee_id',
      desc: '',
      args: [],
    );
  }

  /// `Employee Name`
  String get rs_employee_name {
    return Intl.message(
      'Employee Name',
      name: 'rs_employee_name',
      desc: '',
      args: [],
    );
  }

  /// `Expand`
  String get rs_expand {
    return Intl.message(
      'Expand',
      name: 'rs_expand',
      desc: '',
      args: [],
    );
  }

  /// `Feedback and Suggestions`
  String get rs_feedback {
    return Intl.message(
      'Feedback and Suggestions',
      name: 'rs_feedback',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get rs_feedback_send {
    return Intl.message(
      'Submit',
      name: 'rs_feedback_send',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get rs_filter {
    return Intl.message(
      'Filter',
      name: 'rs_filter',
      desc: '',
      args: [],
    );
  }

  /// `Feedback`
  String get rs_give_feedback {
    return Intl.message(
      'Feedback',
      name: 'rs_give_feedback',
      desc: '',
      args: [],
    );
  }

  /// `Group`
  String get rs_group {
    return Intl.message(
      'Group',
      name: 'rs_group',
      desc: '',
      args: [],
    );
  }

  /// `Help Center`
  String get rs_help_center {
    return Intl.message(
      'Help Center',
      name: 'rs_help_center',
      desc: '',
      args: [],
    );
  }

  /// `Input`
  String get rs_input {
    return Intl.message(
      'Input',
      name: 'rs_input',
      desc: '',
      args: [],
    );
  }

  /// `Core indicators`
  String get rs_key_metric {
    return Intl.message(
      'Core indicators',
      name: 'rs_key_metric',
      desc: '',
      args: [],
    );
  }

  /// `Multilingual`
  String get rs_languages {
    return Intl.message(
      'Multilingual',
      name: 'rs_languages',
      desc: '',
      args: [],
    );
  }

  /// `Following System`
  String get rs_languages_auto {
    return Intl.message(
      'Following System',
      name: 'rs_languages_auto',
      desc: '',
      args: [],
    );
  }

  /// `Later`
  String get rs_later {
    return Intl.message(
      'Later',
      name: 'rs_later',
      desc: '',
      args: [],
    );
  }

  /// `1. Information Collection:\nWe may collect personal information you provide while using this application, including but not limited to your name, phone number, email address, etc.\nWe may also collect behavioral data while you use this application, including but not limited to your device information, log information, location information, etc.\n\n2. Information Use:\nThe collected information will be used to provide you with better services and user experience.\nWe may use your information for data analysis to improve our products and services.\n\n3. Information Sharing:\nWe will not share your personal information with any third party unless we have obtained your explicit consent beforehand or it is stipulated by laws and regulations.\nIn some cases, we may share anonymous statistical information with our partners.\n\n4. Information Protection:\nWe employ reasonable security techniques and procedures to protect your personal information from loss, misuse, unauthorized access, or disclosure.\n\n5. Your Rights:\nYou have the right to access, correct, and delete your personal information and can contact us at any time to exercise these rights.\nYou may opt out of certain data collection or usage features at any time.\n\n6. Notice of Changes:\nThis Privacy Policy may be updated from time to time, and we will notify you of any significant changes in a prominent location within the application.\n\n7. Contact Us:\nIf you have any questions or comments about this Privacy Policy, please contact us through our official customer service hotline.`
  String get rs_launch_privacy_alert_body {
    return Intl.message(
      '1. Information Collection:\nWe may collect personal information you provide while using this application, including but not limited to your name, phone number, email address, etc.\nWe may also collect behavioral data while you use this application, including but not limited to your device information, log information, location information, etc.\n\n2. Information Use:\nThe collected information will be used to provide you with better services and user experience.\nWe may use your information for data analysis to improve our products and services.\n\n3. Information Sharing:\nWe will not share your personal information with any third party unless we have obtained your explicit consent beforehand or it is stipulated by laws and regulations.\nIn some cases, we may share anonymous statistical information with our partners.\n\n4. Information Protection:\nWe employ reasonable security techniques and procedures to protect your personal information from loss, misuse, unauthorized access, or disclosure.\n\n5. Your Rights:\nYou have the right to access, correct, and delete your personal information and can contact us at any time to exercise these rights.\nYou may opt out of certain data collection or usage features at any time.\n\n6. Notice of Changes:\nThis Privacy Policy may be updated from time to time, and we will notify you of any significant changes in a prominent location within the application.\n\n7. Contact Us:\nIf you have any questions or comments about this Privacy Policy, please contact us through our official customer service hotline.',
      name: 'rs_launch_privacy_alert_body',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to use our application! For better protecting your privacy and ensuring your right to know when using our services, please read and understand.`
  String get rs_launch_privacy_alert_head {
    return Intl.message(
      'Welcome to use our application! For better protecting your privacy and ensuring your right to know when using our services, please read and understand.',
      name: 'rs_launch_privacy_alert_head',
      desc: '',
      args: [],
    );
  }

  /// `Server Area`
  String get rs_launch_server_region {
    return Intl.message(
      'Server Area',
      name: 'rs_launch_server_region',
      desc: '',
      args: [],
    );
  }

  /// `Select Layout Method`
  String get rs_layout_selection {
    return Intl.message(
      'Select Layout Method',
      name: 'rs_layout_selection',
      desc: '',
      args: [],
    );
  }

  /// `Store`
  String get rs_location {
    return Intl.message(
      'Store',
      name: 'rs_location',
      desc: '',
      args: [],
    );
  }

  /// `Store Name or Store ID`
  String get rs_location_search_hint {
    return Intl.message(
      'Store Name or Store ID',
      name: 'rs_location_search_hint',
      desc: '',
      args: [],
    );
  }

  /// `Select All`
  String get rs_location_select_all {
    return Intl.message(
      'Select All',
      name: 'rs_location_select_all',
      desc: '',
      args: [],
    );
  }

  /// `Selected`
  String get rs_location_selected {
    return Intl.message(
      'Selected',
      name: 'rs_location_selected',
      desc: '',
      args: [],
    );
  }

  /// `Replace`
  String get rs_login_change {
    return Intl.message(
      'Replace',
      name: 'rs_login_change',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get rs_login_email {
    return Intl.message(
      'Email',
      name: 'rs_login_email',
      desc: '',
      args: [],
    );
  }

  /// `The email format is incorrect.`
  String get rs_login_email_format_error_tip {
    return Intl.message(
      'The email format is incorrect.',
      name: 'rs_login_email_format_error_tip',
      desc: '',
      args: [],
    );
  }

  /// `Get verification code`
  String get rs_login_get_code {
    return Intl.message(
      'Get verification code',
      name: 'rs_login_get_code',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get rs_login_password_tip {
    return Intl.message(
      'Password',
      name: 'rs_login_password_tip',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect phone number format`
  String get rs_login_phone_format_error_tip {
    return Intl.message(
      'Incorrect phone number format',
      name: 'rs_login_phone_format_error_tip',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get rs_login_phone_number {
    return Intl.message(
      'Phone',
      name: 'rs_login_phone_number',
      desc: '',
      args: [],
    );
  }

  /// `User Privacy Agreement`
  String get rs_login_privacy_agreement {
    return Intl.message(
      'User Privacy Agreement',
      name: 'rs_login_privacy_agreement',
      desc: '',
      args: [],
    );
  }

  /// `I have read and agree`
  String get rs_login_privacy_agreement_prefix {
    return Intl.message(
      'I have read and agree',
      name: 'rs_login_privacy_agreement_prefix',
      desc: '',
      args: [],
    );
  }

  /// `Resend`
  String get rs_login_resend {
    return Intl.message(
      'Resend',
      name: 'rs_login_resend',
      desc: '',
      args: [],
    );
  }

  /// `LOG IN`
  String get rs_login_uppercase {
    return Intl.message(
      'LOG IN',
      name: 'rs_login_uppercase',
      desc: '',
      args: [],
    );
  }

  /// `Log in using email`
  String get rs_login_use_email {
    return Intl.message(
      'Log in using email',
      name: 'rs_login_use_email',
      desc: '',
      args: [],
    );
  }

  /// `Log in using a password`
  String get rs_login_use_password {
    return Intl.message(
      'Log in using a password',
      name: 'rs_login_use_password',
      desc: '',
      args: [],
    );
  }

  /// `Log in with phone number`
  String get rs_login_use_phone {
    return Intl.message(
      'Log in with phone number',
      name: 'rs_login_use_phone',
      desc: '',
      args: [],
    );
  }

  /// `Log in using a verification code`
  String get rs_login_use_verification_code {
    return Intl.message(
      'Log in using a verification code',
      name: 'rs_login_use_verification_code',
      desc: '',
      args: [],
    );
  }

  /// `Verification code`
  String get rs_login_verification_code_tip {
    return Intl.message(
      'Verification code',
      name: 'rs_login_verification_code_tip',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get rs_logout {
    return Intl.message(
      'Log out',
      name: 'rs_logout',
      desc: '',
      args: [],
    );
  }

  /// `Long press and drag to adjust the order.`
  String get rs_long_press_and_drag_to_adjust_the_order {
    return Intl.message(
      'Long press and drag to adjust the order.',
      name: 'rs_long_press_and_drag_to_adjust_the_order',
      desc: '',
      args: [],
    );
  }

  /// `Exception Management`
  String get rs_loss_management {
    return Intl.message(
      'Exception Management',
      name: 'rs_loss_management',
      desc: '',
      args: [],
    );
  }

  /// `Management by Objectives (MBO)`
  String get rs_management_by_objectives {
    return Intl.message(
      'Management by Objectives (MBO)',
      name: 'rs_management_by_objectives',
      desc: '',
      args: [],
    );
  }

  /// `Indicator`
  String get rs_metric {
    return Intl.message(
      'Indicator',
      name: 'rs_metric',
      desc: '',
      args: [],
    );
  }

  /// `Indicator Card`
  String get rs_metric_card {
    return Intl.message(
      'Indicator Card',
      name: 'rs_metric_card',
      desc: '',
      args: [],
    );
  }

  /// `Indicator`
  String get rs_metrics {
    return Intl.message(
      'Indicator',
      name: 'rs_metrics',
      desc: '',
      args: [],
    );
  }

  /// `Optional indicators`
  String get rs_metrics_options {
    return Intl.message(
      'Optional indicators',
      name: 'rs_metrics_options',
      desc: '',
      args: [],
    );
  }

  /// `Area code for mobile phone, country/region`
  String get rs_mobile_area_code_tip {
    return Intl.message(
      'Area code for mobile phone, country/region',
      name: 'rs_mobile_area_code_tip',
      desc: '',
      args: [],
    );
  }

  /// `Month`
  String get rs_month {
    return Intl.message(
      'Month',
      name: 'rs_month',
      desc: '',
      args: [],
    );
  }

  /// `My Account`
  String get rs_my_account {
    return Intl.message(
      'My Account',
      name: 'rs_my_account',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get rs_name {
    return Intl.message(
      'Name',
      name: 'rs_name',
      desc: '',
      args: [],
    );
  }

  /// `Next step`
  String get rs_next {
    return Intl.message(
      'Next step',
      name: 'rs_next',
      desc: '',
      args: [],
    );
  }

  /// `Next step`
  String get rs_next_step {
    return Intl.message(
      'Next step',
      name: 'rs_next_step',
      desc: '',
      args: [],
    );
  }

  /// `No Data`
  String get rs_no_data {
    return Intl.message(
      'No Data',
      name: 'rs_no_data',
      desc: '',
      args: [],
    );
  }

  /// `Please don't worry, we will handle it as soon as possible.`
  String get rs_no_data_tip {
    return Intl.message(
      'Please don\'t worry, we will handle it as soon as possible.',
      name: 'rs_no_data_tip',
      desc: '',
      args: [],
    );
  }

  /// `Not comparing`
  String get rs_none_compared {
    return Intl.message(
      'Not comparing',
      name: 'rs_none_compared',
      desc: '',
      args: [],
    );
  }

  /// `Bill details`
  String get rs_order_detail {
    return Intl.message(
      'Bill details',
      name: 'rs_order_detail',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get rs_others {
    return Intl.message(
      'Other',
      name: 'rs_others',
      desc: '',
      args: [],
    );
  }

  /// `Phone number`
  String get rs_phone {
    return Intl.message(
      'Phone number',
      name: 'rs_phone',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your feedback and suggestions.`
  String get rs_please_input_feedback {
    return Intl.message(
      'Please enter your feedback and suggestions.',
      name: 'rs_please_input_feedback',
      desc: '',
      args: [],
    );
  }

  /// `Please select`
  String get rs_please_select {
    return Intl.message(
      'Please select',
      name: 'rs_please_select',
      desc: '',
      args: [],
    );
  }

  /// `Please select at least 1 indicator.`
  String get rs_please_select_at_least_one_metric {
    return Intl.message(
      'Please select at least 1 indicator.',
      name: 'rs_please_select_at_least_one_metric',
      desc: '',
      args: [],
    );
  }

  /// `Summary of Privacy Protection Guidelines`
  String get rs_privacy_protection_guideline_summary {
    return Intl.message(
      'Summary of Privacy Protection Guidelines',
      name: 'rs_privacy_protection_guideline_summary',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Protection Guidelines`
  String get rs_privacy_protection_guidelines {
    return Intl.message(
      'Privacy Protection Guidelines',
      name: 'rs_privacy_protection_guidelines',
      desc: '',
      args: [],
    );
  }

  /// `Progress`
  String get rs_progress {
    return Intl.message(
      'Progress',
      name: 'rs_progress',
      desc: '',
      args: [],
    );
  }

  /// `Proportion`
  String get rs_rate {
    return Intl.message(
      'Proportion',
      name: 'rs_rate',
      desc: '',
      args: [],
    );
  }

  /// `Please read and agree first.`
  String get rs_read_agree_privacy_policy {
    return Intl.message(
      'Please read and agree first.',
      name: 'rs_read_agree_privacy_policy',
      desc: '',
      args: [],
    );
  }

  /// `Reload`
  String get rs_reload {
    return Intl.message(
      'Reload',
      name: 'rs_reload',
      desc: '',
      args: [],
    );
  }

  /// `Rest day`
  String get rs_rest_day {
    return Intl.message(
      'Rest day',
      name: 'rs_rest_day',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get rs_save {
    return Intl.message(
      'Save',
      name: 'rs_save',
      desc: '',
      args: [],
    );
  }

  /// `Choose`
  String get rs_select {
    return Intl.message(
      'Choose',
      name: 'rs_select',
      desc: '',
      args: [],
    );
  }

  /// `Select Country/Region`
  String get rs_select_country_region {
    return Intl.message(
      'Select Country/Region',
      name: 'rs_select_country_region',
      desc: '',
      args: [],
    );
  }

  /// `Select Store`
  String get rs_select_location {
    return Intl.message(
      'Select Store',
      name: 'rs_select_location',
      desc: '',
      args: [],
    );
  }

  /// `Please select`
  String get rs_select_metric_tip_prefix {
    return Intl.message(
      'Please select',
      name: 'rs_select_metric_tip_prefix',
      desc: '',
      args: [],
    );
  }

  /// `individual indicators`
  String get rs_select_metric_tip_suffix {
    return Intl.message(
      'individual indicators',
      name: 'rs_select_metric_tip_suffix',
      desc: '',
      args: [],
    );
  }

  /// `Setting`
  String get rs_setting {
    return Intl.message(
      'Setting',
      name: 'rs_setting',
      desc: '',
      args: [],
    );
  }

  /// `View All`
  String get rs_show_all {
    return Intl.message(
      'View All',
      name: 'rs_show_all',
      desc: '',
      args: [],
    );
  }

  /// `Display at least one.`
  String get rs_show_least_one {
    return Intl.message(
      'Display at least one.',
      name: 'rs_show_least_one',
      desc: '',
      args: [],
    );
  }

  /// `You can easily understand how your restaurant is performing, no matter where you are.`
  String get rs_slogan {
    return Intl.message(
      'You can easily understand how your restaurant is performing, no matter where you are.',
      name: 'rs_slogan',
      desc: '',
      args: [],
    );
  }

  /// `Software License and Service Agreement`
  String get rs_software_license_and_service_agreement {
    return Intl.message(
      'Software License and Service Agreement',
      name: 'rs_software_license_and_service_agreement',
      desc: '',
      args: [],
    );
  }

  /// `Sorting`
  String get rs_sort {
    return Intl.message(
      'Sorting',
      name: 'rs_sort',
      desc: '',
      args: [],
    );
  }

  /// `Shop`
  String get rs_store {
    return Intl.message(
      'Shop',
      name: 'rs_store',
      desc: '',
      args: [],
    );
  }

  /// `Sure`
  String get rs_sure {
    return Intl.message(
      'Sure',
      name: 'rs_sure',
      desc: '',
      args: [],
    );
  }

  /// `Target Setting`
  String get rs_target_setting {
    return Intl.message(
      'Target Setting',
      name: 'rs_target_setting',
      desc: '',
      args: [],
    );
  }

  /// `Target value`
  String get rs_target_value {
    return Intl.message(
      'Target value',
      name: 'rs_target_value',
      desc: '',
      args: [],
    );
  }

  /// `Template`
  String get rs_template {
    return Intl.message(
      'Template',
      name: 'rs_template',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get rs_theme {
    return Intl.message(
      'Theme',
      name: 'rs_theme',
      desc: '',
      args: [],
    );
  }

  /// `Dark color`
  String get rs_theme_dark {
    return Intl.message(
      'Dark color',
      name: 'rs_theme_dark',
      desc: '',
      args: [],
    );
  }

  /// `Light color`
  String get rs_theme_light {
    return Intl.message(
      'Light color',
      name: 'rs_theme_light',
      desc: '',
      args: [],
    );
  }

  /// `Topic`
  String get rs_topic {
    return Intl.message(
      'Topic',
      name: 'rs_topic',
      desc: '',
      args: [],
    );
  }

  /// `It is already the latest version.`
  String get rs_update_already_latest_version {
    return Intl.message(
      'It is already the latest version.',
      name: 'rs_update_already_latest_version',
      desc: '',
      args: [],
    );
  }

  /// `Check for New Version`
  String get rs_update_check_new_version {
    return Intl.message(
      'Check for New Version',
      name: 'rs_update_check_new_version',
      desc: '',
      args: [],
    );
  }

  /// `Checking for new versions`
  String get rs_update_checking_new_versions {
    return Intl.message(
      'Checking for new versions',
      name: 'rs_update_checking_new_versions',
      desc: '',
      args: [],
    );
  }

  /// `Continue Downloading`
  String get rs_update_continue_download {
    return Intl.message(
      'Continue Downloading',
      name: 'rs_update_continue_download',
      desc: '',
      args: [],
    );
  }

  /// `Cancel download and re-download.`
  String get rs_update_download_canceled_re_download {
    return Intl.message(
      'Cancel download and re-download.',
      name: 'rs_update_download_canceled_re_download',
      desc: '',
      args: [],
    );
  }

  /// `Download failed, please re-download.`
  String get rs_update_download_failed_re_download {
    return Intl.message(
      'Download failed, please re-download.',
      name: 'rs_update_download_failed_re_download',
      desc: '',
      args: [],
    );
  }

  /// `Install`
  String get rs_update_install {
    return Intl.message(
      'Install',
      name: 'rs_update_install',
      desc: '',
      args: [],
    );
  }

  /// `Find New Version`
  String get rs_update_new_version {
    return Intl.message(
      'Find New Version',
      name: 'rs_update_new_version',
      desc: '',
      args: [],
    );
  }

  /// `Pause`
  String get rs_update_paused {
    return Intl.message(
      'Pause',
      name: 'rs_update_paused',
      desc: '',
      args: [],
    );
  }

  /// `Please go to the store to update.`
  String get rs_update_tip {
    return Intl.message(
      'Please go to the store to update.',
      name: 'rs_update_tip',
      desc: '',
      args: [],
    );
  }

  /// `Update later`
  String get rs_update_update_later {
    return Intl.message(
      'Update later',
      name: 'rs_update_update_later',
      desc: '',
      args: [],
    );
  }

  /// `Update Now`
  String get rs_update_update_now {
    return Intl.message(
      'Update Now',
      name: 'rs_update_update_now',
      desc: '',
      args: [],
    );
  }

  /// `Waiting to download`
  String get rs_update_waiting_download {
    return Intl.message(
      'Waiting to download',
      name: 'rs_update_waiting_download',
      desc: '',
      args: [],
    );
  }

  /// `Version`
  String get rs_version {
    return Intl.message(
      'Version',
      name: 'rs_version',
      desc: '',
      args: [],
    );
  }

  /// `comparison`
  String get rs_vs {
    return Intl.message(
      'comparison',
      name: 'rs_vs',
      desc: '',
      args: [],
    );
  }

  /// `Weekday`
  String get rs_weekday {
    return Intl.message(
      'Weekday',
      name: 'rs_weekday',
      desc: '',
      args: [],
    );
  }

  /// `Analysis`
  String get rs_analysis {
    return Intl.message(
      'Analysis',
      name: 'rs_analysis',
      desc: '',
      args: [],
    );
  }

  /// `Cumulative`
  String get rs_cumulative {
    return Intl.message(
      'Cumulative',
      name: 'rs_cumulative',
      desc: '',
      args: [],
    );
  }

  /// `Time-based`
  String get rs_time_based {
    return Intl.message(
      'Time-based',
      name: 'rs_time_based',
      desc: '',
      args: [],
    );
  }

  /// `AI Smart Assistant`
  String get rs_ai_chat_title {
    return Intl.message(
      'AI Smart Assistant',
      name: 'rs_ai_chat_title',
      desc: '',
      args: [],
    );
  }

  /// `Guess you want to ask`
  String get rs_ai_chat_guess {
    return Intl.message(
      'Guess you want to ask',
      name: 'rs_ai_chat_guess',
      desc: '',
      args: [],
    );
  }

  /// `Chat History`
  String get rs_ai_chat_history {
    return Intl.message(
      'Chat History',
      name: 'rs_ai_chat_history',
      desc: '',
      args: [],
    );
  }

  /// `No Chat History`
  String get rs_ai_chat_history_no_data {
    return Intl.message(
      'No Chat History',
      name: 'rs_ai_chat_history_no_data',
      desc: '',
      args: [],
    );
  }

  /// `30 days ago`
  String get rs_thirty_days_ago {
    return Intl.message(
      '30 days ago',
      name: 'rs_thirty_days_ago',
      desc: '',
      args: [],
    );
  }

  /// `Within 30 days`
  String get rs_thirty_days_within {
    return Intl.message(
      'Within 30 days',
      name: 'rs_thirty_days_within',
      desc: '',
      args: [],
    );
  }

  /// `Please click to retry`
  String get rs_click_to_retry {
    return Intl.message(
      'Please click to retry',
      name: 'rs_click_to_retry',
      desc: '',
      args: [],
    );
  }

  /// `Request Timeout`
  String get rs_timeout {
    return Intl.message(
      'Request Timeout',
      name: 'rs_timeout',
      desc: '',
      args: [],
    );
  }

  /// `Reference`
  String get rs_reference {
    return Intl.message(
      'Reference',
      name: 'rs_reference',
      desc: '',
      args: [],
    );
  }

  /// `Filter criteria`
  String get rs_filter_criteria {
    return Intl.message(
      'Filter criteria',
      name: 'rs_filter_criteria',
      desc: '',
      args: [],
    );
  }

  /// `Display quantity`
  String get rs_display_quantity {
    return Intl.message(
      'Display quantity',
      name: 'rs_display_quantity',
      desc: '',
      args: [],
    );
  }

  /// `Weekly`
  String get rs_weekly {
    return Intl.message(
      'Weekly',
      name: 'rs_weekly',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de', countryCode: 'DE'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'it'),
      Locale.fromSubtags(languageCode: 'nl'),
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'vi', countryCode: 'VN'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
