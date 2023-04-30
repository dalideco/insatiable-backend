# Handles transformations of durations
class DurationTransformer
  def self.lifetime_from_string(text)
    case text
    when '1.hour' then 1.hour
    when '3.hours' then 3.hours
    when '6.hours' then 6.hours
    when '12.hours' then 12.hours
    when '1.day' then 1.day
    when '3.days' then 3.days
    when '30.seconds' then 30.seconds
    end
  end
end
