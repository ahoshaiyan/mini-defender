# frozen_string_literal: true

class MiniDefender::Rules::Password < MiniDefender::Rule
  def self.signature
    'password'
  end

  def passes?(attribute, value, validator)
    @errors = []

    # Password requirements
    @errors << 'The password must have an uppercase letter' unless /[A-Z]/.match?(value)
    @errors << 'The password must have a lowercase letter' unless /[a-z]/.match?(value)
    @errors << 'The password must have a digit' unless /\d/.match?(value)
    @errors << 'The password must have a special characters (#?!@$%^&*-)' unless /[#?!@$%^&*-]+/.match?(value)

    @errors.empty?
  end

  def message(attribute, value, validator)
    @errors.join(', ')
  end
end
