module Mincer
  def find_image(name)
    if i = self.site.images.find_by_name(name)
      return i.full_url
    end
  end

  def find_form_action(name)
    if f = self.site.forms.find_by_name(name)
      return "http://simplepage.biz/submit/#{f.uuid}"
    end
  end

  def insert_site_url
    self.site.full_url
  end

  def set_values_map(name, value)
    @values_map = {} unless @values_map
    @values_map[name] = value
    return nil
  end

  def get_values_map(name)
    return @values_map[name] if @values_map
    return ''
  end

  def code
    if self.cacher
      if (self.cacher.updated_at < site.modified_at) || (self.cacher.updated_at < self.updated_at)
        self.compile
      end
    else
      self.compile
    end
    self.cacher.content
  end

  def compile
    self.cacher = Cacher.new unless self.cacher
    self.cacher.content = self.parser([], nil, self.content)
    self.cacher.save
  end

  def parser stack, segment, content
    return "" unless content
    return "[::deep includes(#{stack.join(',')})::]" if stack.length > 30
    return "[::includes error::]" if stack.include?(segment)

    # INFO: variable setting
    content.gsub!(/\s*\[% *\$(\w+) *= *['"]?(.+?)['"]? *%\]\s*/) do |value|
      self.set_values_map("#{$1}", "#{$2}")
    end

    # INFO: images includes
    content.gsub!(/\[% *image:([[:word:]\-]+) *%\]/) do |value|
      self.find_image($1)
    end

    # INFO: form actions
    content.gsub!(/\[% *form:([[:word:]\-]+):action *%\]/) do |value|
      self.find_form_action($1)
    end

    # INFO: Site URL
    content.gsub!(/\[% *site:url *%\]/) do |value|
      self.insert_site_url
    end

    # INFO: includes
    content.gsub!(/\s*\[% *include +['"]?(.+?)['"]? *%\]\s*/) do |template|
      self.parser(stack.push(segment), $1, @t.content) if @t = self.site.templates.find_by_name($1)
    end

    # INFO: layouts
    if content =~ /\s*\[% *layout +['"]?(.+?)['"]? *%\]\s*/
      if @l = self.site.layouts.find_by_name($1)
        layout = self.parser(stack.push(segment), "%#{$1}", @l.content)
        layout.gsub!(/\s*\[% *yield +%\]\s*/, content)
        content = layout
      end
      content.gsub!(/\s*\[% *layout +['"]?(.+?)['"]? *%\]\s*/, '')
    end

    # INFO: variable substitutions
    content.gsub!(/\[% *\$(\w+) *%\]/) do |value|
      self.get_values_map($1)
    end

    content = HtmlPress.press(content) if self.site.compress
    content
  end
end
