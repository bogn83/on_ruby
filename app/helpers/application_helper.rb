module ApplicationHelper

  def repos(nickname)
    logger.info "getting repos for #{nickname}"
    resp = Faraday.get "http://github.com/api/v2/json/repos/show/#{nickname}"
    repos = Hashie::Mash.new(MultiJson.decode(resp.body)).repositories || []
    repos.sort { |a, b| b.watchers + b.forks <=> a.watchers + a.forks }[0..2]
  rescue
    logger.warn $!
    []
  end

  def awesome_link_to(name, url, options={})
    content_tag :li, :class => css_class_for_link(name) do
      content_tag(:span) + content_tag(:b) { link_to t("menu.#{name}", options), url }
    end
  end
  
  def flash_growl
    if notice
      js add_gritter(flash[:notice], :image => :notice, :title => "Hey:", :time => 2000)
    elsif alert
      js add_gritter(flash[:alert], :image => :warning, :title => "Ohoh:", :time => 3000)
    end
  end

private

  def css_class_for_link(name)
    controller.controller_name == name.to_s ? "active" : ""
  end

end