module Subdomain
  @position = 1
  begin
    if Render.config.base_domain
      @position = Render.config.base_domain.split(".").length - 1
    end
  rescue
    #
  end
  
  def self.position
    @position
  end

  def self.matches?(request)
    if Render.config.base_domains.include?(request.domain)
      request.subdomain(@position).present? && request.subdomain(@position) != 'www'
    else
      true
    end
  end
end
