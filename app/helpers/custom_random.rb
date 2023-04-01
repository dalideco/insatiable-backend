# Class for generating random with noise
class CustomRandom
  def self.random_with_probability(options)
    current = 0
    max = options.values.inject(:+)
    random_value = rand(max) + 1
    options.each do |key, val|
      current += val
      return key if random_value <= current
    end
  end
end
