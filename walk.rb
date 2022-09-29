rules = {
    'address' => 'required|hash',
    'address.streets' => 'required|array',
    'address.streets.*' => 'required|integer',
}.sort

pp rules

data = {
    "address" => {
        "streets" => [
            '1', '2', '3', '4', '5'
        ]
    }
}

# Transform rules
new_rules = {}
rules.each do |k, v|
    # TODO: * at the start is not allowed
    new_rules[k] = v unless k.match?(/\.\*\.?/)

    key_parts = k.split('.')
    current_key = [k.unshift]
    current_data = data[current_key[0]]

    key_parts.skip(1).each do |key_part|
        
    end
end
