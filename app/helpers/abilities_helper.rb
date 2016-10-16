module AbilitiesHelper
  def check_box_name(object_name)
    "#{object_name}[ability_ids][]"
  end
end
