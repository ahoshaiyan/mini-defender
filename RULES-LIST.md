# 🛡️ Mini Defender Rules List

## Table of Contents
1. [🎯 Type Validation](#-type-validation)
2. [🔍 Pattern Matching](#-pattern-matching)
3. [⚡ Conditional Rules](#-conditional-rules)
4. [🌐 URL & Network](#-url--network)
5. [⚖️ Comparison Rules](#-comparison-rules)
6. [📅 Date & Time](#-date--time)
7. [🏦 Financial](#-financial)
8. [📝 Text & String Rules](#-text--string-rules)
9. [🔄 Status & State](#-status--state)
10. [📁 File & Media](#-file--media)
11. [⚙️ Default Values](#-default-values)


> **Note**: All examples shown below will be used within a validator context. For example:
> ```ruby
> # Option a
> validator = MiniDefender::Validator.new({
> 'notification_url' => 'required_if:card.verified,true|string|url',
> 'card.security_code' => 'digits_between:3,4',
> 'card.verified' => 'boolean',
> 'card.manual_input' => 'required|boolean|default:false'
> })
> ```
> ```ruby
> # Option b
> validate!({ 'name' => 'string' }, true)
> ```
>
## 🎯 Type Validation
| Rule      | Description | Example                                 |
|-----------|-------------|-----------------------------------------|
| `string`  | Validates string type | `'books.*' => 'string\|max:255'`        |
| `integer` | Validates integer numbers | `'employees.*.cars.*.year' => 'integer',` |
| `numeric` | Validates numeric values | `'price' => 'numeric'`                  |
| `boolean` | Validates boolean values | `'active' => 'boolean'`                 |
| `array`   | Validates arrays | `'items' => 'array'`                    |
| `json`    | Validates JSON format | `'preferences' => 'required\|json'`     |
| `file`    | Validates file uploads | `'file' => ['required', 'string', 'regex:^data:.+?;base64,.+$']`             |

## 🔍 Pattern Matching
| Rule | Description | Example                                                             |
|------|-------------|---------------------------------------------------------------------|
| `regex` | Regular expression validation | `'currency_code' => 'regex:^[A-Z]{3}$'`                             |
| `not_regex` | Negative regex validation | `'text' => 'not_regex:[0-9]'`                                       |
| `starting_with` | String prefix validation | `'username' => 'starting_with:admin_'`                              |
| `ending_with` | String suffix validation | `'file' => 'ending_with:.pdf'`                                      |
| `in` | Value inclusion validation | `MiniDefender::Rules::In.new(Country::ISO_CODES)`                   |
| `not_in` | Value exclusion validation | `MiniDefender::Rules::NotIn.new(PaymentMethod::TYPES)`              |
| `distinct` | Unique values validation | `'item_sequence_number' => 'string\|digits_between:1,16\|distinct'` |

## ⚡ Conditional Rules
| Rule | Description | Example |
|------|-------------|---------|
| `required` | Field must be present | `'email' => 'required'` |
| `required_if` | Conditionally required | `MiniDefender::Rules::RequiredIf.new('status', ['rejected'])` |
| `required_unless` | Required unless condition | `'phone' => 'required_unless:email,null'` |
| `required_with` | Required with other field | `MiniDefender::Rules::RequiredWith.new(['firstname'])` |
| `required_with_all` | Required with all fields | `'city' => 'required_with_all:street,country'` |
| `required_without` | Required without field | `'phone' => 'required_without:email'` |
| `required_without_all` | Required without all | `MiniDefender::Rules::RequiredWithoutAll.new(['email', 'phone'])` |
| `prohibited` | Field must not be present | `'admin_code' => 'prohibited'` |
| `prohibited_if` | Conditionally prohibited | `MiniDefender::Rules::ProhibitedIf.new('price', [0])` |
| `prohibited_unless` | Prohibited unless condition | `'discount' => 'prohibited_unless:user_type,premium'` |

## 🌐 URL & Network
| Rule | Description | Example                                           |
|------|-------------|---------------------------------------------------|
| `hostname` | Hostname validation | `'host' => 'hostname'`                            |
| `ip` | IP address validation | `'ip_address' => 'ip'`                            |
| `ipv4` | IPv4 address validation | `'ipv4_address' => 'ipv4'`                        |
| `ipv6` | IPv6 address validation | `'ipv6_address' => 'ipv6'`                        |
| `mac_address` | MAC address validation | `MiniDefender::Rules::MacAddress.new`             |
| `url` | URL format validation | `MiniDefender::Rules::Url.new(['https', 'public', 'not_ip'])` |


## ⚖️ Comparison Rules
| Rule | Description | Example |
|------|-------------|---------|
| `between` | Value within range | `'age' => 'between:18,65'` |
| `digits_between` | Digits count within range | `'pin' => 'digits_between:4,6'` |
| `min` | Minimum value | `MiniDefender::Rules::Min.new(0)` |
| `max` | Maximum value | `'quantity' => 'max:999'` |
| `min_digits` | Minimum digits count | `MiniDefender::Rules::MinDigits.new(6)` |
| `max_digits` | Maximum digits count | `'pin' => 'max_digits:4'` |
| `size` | Exact size validation | `MiniDefender::Rules::Size.new(6)` |
| `greater_than` | Greater than comparison | `'end_date' => 'greater_than:start_date'` |
| `greater_than_or_equal` | Greater than or equal | `MiniDefender::Rules::GreaterThanOrEqual.new(:min_stock)` |
| `less_than` | Less than comparison | `'discount' => 'less_than:price'` |
| `less_than_or_equal` | Less than or equal | `MiniDefender::Rules::LessThanOrEqual.new(:max_space)` |
| `equal` | Equality validation | `'confirmation' => 'equal:password'` |

## 📅 Date & Time
| Rule | Description | Example |
|------|-------------|---------|
| `date` | Date validation | `'birth_date' => 'date'` |
| `date_format` | Date format validation | `'event_date' => 'date_format:%Y-%m-%d'` |
| `date_eq` | Date equality | `'expiry_date' => 'date_eq:2024-12-31'` |
| `date_gt` | Date greater than | `'end_date' => 'date_gt:start_date'` |
| `date_gte` | Date greater than or equal | `'start_date' => 'date_gte:2024-01-01'` |
| `date_lt` | Date less than | `'deadline' => 'date_lt:2024-12-31'` |
| `date_lte` | Date less than or equal | `'submission' => 'date_lte:end_date'` |
| `timezone` | Timezone validation | `'user_timezone' => 'timezone'` |


## 🏦 Financial
| Rule | Description | Example |
|------|-------------|---------|
| `credit_card` | Credit/debit card number validation | `'card_number' => 'credit_card'` |
| `currency` | ISO-4217 currency code validation | `'payment_currency' => 'currency'` |
| `iban` | International Bank Account Number validation | `'account_number' => 'iban'` |
| `merchant_category_code` | Merchant Category Code (MCC) validation | `'merchant_type' => 'mcc'` |

## 📝 Text & String Rules
| Rule | Description | Example                            |
|------|-------------|------------------------------------|
| `alpha` | Only alphabetic characters | `'name' => 'alpha'`                |
| `alpha_dash` | Alpha with dashes/underscores | `'username' => 'alpha_dash'`       |
| `alpha_num` | Alphanumeric only | `'reference' => 'alpha_num'`       |
| `email` | Email format validation | `'user_email' => 'email'`          |
| `uuid` | UUID format validation | `'id' => 'uuid'`                   |
| `hash` | Hash format validation | `'metadata' => 'hash:all\|max:30'` |

## 🔄 Status & State
| Rule | Description | Example |
|------|-------------|---------|
| `accepted` | Must be accepted | `'terms' => 'accepted'` |
| `accepted_if` | Conditional acceptance | `'gdpr' => 'accepted_if:country,EU'` |
| `declined` | Must be declined | `'cancellation' => 'declined'` |
| `declined_if` | Conditional decline | `'premium' => 'declined_if:plan,basic'` |
| `confirmed` | Requires confirmation | `'password' => 'confirmed'` |
| `filled` | Must not be empty if present | `'bio' => 'filled'` |
| `present` | Must be present (can be empty) | `'settings' => 'present'` |
| `exists` | Must exist in database | `'user_id' => 'exists:users,id'` |
| `unique` | Must be unique in database | `'email' => 'unique:users,email'` |

## 📁 File & Media
| Rule | Description | Example |
|------|-------------|---------|
| `image` | Image file validation | `'avatar' => 'image\|max_size:5242880'` |
| `mime_types` | MIME type validation | `'document' => 'mime_types:application/pdf'` |

## ⚙️ Default Values
| Rule | Description | Example |
|------|-------------|---------|
| `default` | Static default value | `'status' => 'default:pending'` |