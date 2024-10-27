# Mini Defender Rules 

## Table of Contents
- [Type Validation](#type-validation)
- [Pattern Matching](#pattern-matching)
- [Conditional Rules](#conditional-rules)
- [URL & Network](#url--network)
- [Comparison Rules](#comparison-rules)
- [Date & Time](#date--time)
- [Financial & Business](#business)
- [Text & String Rules](#text--string-rules)
- [Status & State](#status--state)
- [File & Media](#file--media)
- [Default Values](#default-values)


## Type Validation
- `string` - String type validation
- `integer` - Integer validation
- `numeric` - Numeric validation
- `boolean` - Boolean validation
- `array` - Array type validation
- `json` - JSON format validation
- `file` - File validation

## Pattern Matching
- `regex` - Regular expression validation
- `not_regex` - Negative regular expression validation
- `starting_with` - String prefix validation
- `not_starting_with` - Negative string prefix validation
- `ending_with` - String suffix validation
- `not_ending_with` - String suffix validation
- `in` - Value inclusion validation
- `not_in` - Value exclusion validation
- `distinct` - Unique values validation

## Conditional Rules
- `required` - Required field validation
- `required_if` - Conditionally required
- `required_unless` - Required unless condition
- `required_with` - Required with other field
- `required_with_all` - Required with all other fields
- `required_without` - Required without other field
- `required_without_all` - Required without all other fields
- `prohibited` - Field must not be present
- `prohibited_if` - Conditionally prohibited
- `prohibited_unless` - Prohibited unless condition

## URL & Network
- `url` - URL format validation
- `hostname` - Hostname validation
- `ip` - IP address validation
- `ipv4` - IPv4 address validation
- `ipv6` - IPv6 address validation
- `mac_address` - MAC address validation
- `not_ip_url` - Force domain names in URLs
- `not_local_url` - Prevent localhost URLs

## Comparison Rules
- `between` - Value within range
- `digits_between` - Digits count within range
- `min` - Minimum value
- `max` - Maximum value
- `min_digits` - Minimum digits count
- `max_digits` - Maximum digits count
- `size` - Exact size validation
- `greater_than` - Greater than comparison
- `greater_than_or_equal` - Greater than or equal comparison
- `less_than` - Less than comparison
- `less_than_or_equal` - Less than or equal comparison
- `equal` - Equality validation

## Date & Time
- `date` - Date validation
- `date_format` - Date format validation
- `date_eq` - Date equality
- `date_gt` - Date greater than
- `date_gte` - Date greater than or equal
- `date_lt` - Date less than
- `date_lte` - Date less than or equal
- `timezone` - Timezone validation
- `expiry_date` - Expiry date validation
- `expiry_month` - Expiry month validation
- `expiry_year` - Expiry year validation

## Business
- `credit_card` - Credit card validation
- `iban` - IBAN validation
- `currency` - Currency validation
- `merchant_category_code` - MCC validation
- `country_code` - Country code validation
- `national_id` - National ID validation

## Text & String Rules
- `alpha` - Alphabetic validation
- `alpha_dash` - Alphadash validation
- `alpha_num` - Alphanumeric validation
- `email` - Email format validation
- `uuid` - UUID validation
- `hash` - Hash validation

## Status & State
- `accepted` - Acceptance validation
- `accepted_if` - Conditional acceptance
- `declined` - Decline validation
- `declined_if` - Conditional decline
- `confirmed` - Confirmation validation
- `filled` - Filled validation
- `present` - Presence validation
- `exists` - Existence validation
- `unique` - Uniqueness validation

## File & Media
- `image` - Image file validation
- `mime_types` - MIME type validation

## Default Values
- `default` - Default value setting
