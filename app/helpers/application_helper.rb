module ApplicationHelper
  def error_messages_for(models)
    return "" if models.nil?
    messages = [models].flatten.collect {|model| error_messages_for_a_single_model(model)}.join

    html = <<-HTML
    <div id="error_explanation">
      <ul>#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end
  
  protected
  
  def error_messages_for_a_single_model(model)
    return "" if model.errors.empty?
    model.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
  end
end
