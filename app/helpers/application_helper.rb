module ApplicationHelper
  def twitterized_type(type)
    case type
      when :alert
        "alert-block"
      when :error
        "alert-error"
      when :notice
        "alert-info"
      when :success
        "alert-success"
      else
        type.to_s
    end
  end

  def show_in_euro(amount)
    number_to_currency(amount, :locale => :fr, :unit => "&euro;", :separator => ",", :delimiter => " ", :format => "%n%u")
  end

end
