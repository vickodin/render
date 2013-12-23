module Mincer
  def find_image(name)
    if i = self.site.images.find_by_name(name)
      return i.full_url
    end
  end

  def find_template(name)
    # self.site.templates.find_by_name($1)
  end

  def find_entity(name, klass = :file)
    names = name.split('/')
    last_entity = nil
    parent_id   = nil

    names.each do |one|
      if i = (klass == :file ? find_one_file(one, parent_id) : find_one_template(one, parent_id) )
        last_entity = i
        parent_id = i.id
      else
        return nil
      end
    end

    if last_entity
      if klass == :file
        return last_entity.full_url
      else
        return last_entity
      end
    else
      return nil
    end
  end

=begin
  def find_file(name)
    names = name.split('/')
    last_file = nil
    parent_id = nil

    names.each do |one|
      if i = find_one_file(one, parent_id)
        last_file = i
        parent_id = i.id
      else
        return nil
      end
    end

    if last_file
      return last_file.full_url
    else
      return nil
    end
  end
=end

  def find_one_file(name, parent_id = nil)
    self.site.documents.where(name: name, parent_id: parent_id).first
  end

  def find_one_template(name, parent_id = nil)
    self.site.templates.where(name: name, parent_id: parent_id).first
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
    if (cacher && cacher.expired?) || !cacher
      self.compile
    end
    cacher.content
  end

  def compile
    self.cacher = Cacher.new unless cacher
    self.cacher.content = self.parser([], nil, self.content)
    self.cacher.save
    self.cacher.touch
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
    content.gsub!(/\[% *image:(.+?) *%\]/) do |value|
      self.find_image($1)
    end

    # INFO: files
    content.gsub!(/\[% *file:(.+?) *%\]/) do |value|
      self.find_entity($1, :file)
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
      #self.parser(stack.push(segment), $1, @t.content) if @t = self.site.templates.find_by_name($1)
      self.parser(stack.push(segment), $1, @t.content) if @t = self.find_entity($1, :template)
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
