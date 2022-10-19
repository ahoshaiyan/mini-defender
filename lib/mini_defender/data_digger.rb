# frozen_string_literal: true

class DataDigger
  def dig(data, key)
    key = key.split('.')
    current = data

    until key.empty?
      current_key = key.shift
      current_key = current_key.to_i if current.is_a?(Array)
      return [false, nil] if current.is_a?(Hash) && !current.key?(current_key)
      return [false, nil] if current.is_a?(Array) && current_key >= current.length

      current = current[current_key]
    end

    [true, current]
  end
end
