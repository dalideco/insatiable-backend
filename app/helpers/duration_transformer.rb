# Handles transformations of durations
class DurationTransformer
  def self.lifetime_from_string(text)
    case text
    when '1.hour'
      1.hour
    when '3.hours'
      3.hours
    when '6.hours'
      6.hours
    when '12.hours'
      12.hours
    when '1.day'
      1.day
    when '3.days'
      3.days
    end
  end
end
