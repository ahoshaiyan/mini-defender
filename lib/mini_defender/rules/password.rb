# frozen_string_literal: true

class MiniDefender::Rules::Password < MiniDefender::Rule
  SPECIAL_CHARS = '!@#$%^&*()_+-=[]{}|;:,.<>?'.freeze
  MIN_LENGTH = 8

  def self.signature
    'password'
  end

  def passes?(attribute, value, validator)
    unless value.is_a?(String)
      return false
    end
    
    @missing_requirements = []
    
    check_length(value)
    check_lowercase(value)
    check_uppercase(value)
    check_digit(value)
    check_special_char(value)
    
    @missing_requirements.empty?
  end

  def message(attribute, value, validator)
    unless value.is_a?(String)
      return 'Password must be a string.'
    end
    
    if @missing_requirements.nil? || @missing_requirements.empty?
      return 'Password is valid.'
    end
    
    "Password is missing: #{@missing_requirements.join(', ')}."
  end

  private

  def check_length(value)
    if value.length < MIN_LENGTH
      @missing_requirements << "at least #{MIN_LENGTH} characters"
    end
  end

  def check_lowercase(value)
    unless value.match?(/[a-z]/)
      @missing_requirements << 'at least one lowercase letter'
    end
  end

  def check_uppercase(value)
    unless value.match?(/[A-Z]/)
      @missing_requirements << 'at least one uppercase letter'
    end
  end

  def check_digit(value)
    unless value.match?(/\d/)
      @missing_requirements << 'at least one digit'
    end
  end

  def check_special_char(value)
    unless value.chars.any? { |char| SPECIAL_CHARS.include?(char) }
      @missing_requirements << 'at least one special character'
    end
  end
end
