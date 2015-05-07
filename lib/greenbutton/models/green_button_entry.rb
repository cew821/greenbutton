module GreenButton
  class GreenButtonEntry
    include Helpers

    RULES = {
      href: Rule.new(:href, "./link[@rel='self']/@href", :string),
      parent_href: Rule.new(:parent_href, "./link[@rel='up']/@href", :string),
      id: Rule.new(:id, "./id", :string),
      title: Rule.new(:title, "./title", :string),
      date_published: Rule.new(:date_published, "./published", :datetime),
      date_updated: Rule.new(:date_updated, "./updated", :datetime)
    }

    attr_accessor :related_hrefs, :other_related, :href_from_parent

    def initialize(href_from_parent, entry_node, parent)
      self.href_from_parent = href_from_parent
      @entry_node = entry_node
      self.related_hrefs = []
      self.other_related = []
      create_attributes
      pre_rule_assignment(parent)
      get_related_links
    end

    def create_attributes
      all_rules.each_pair do |attr, rule|
        create_attr(attr)
      end
    end

    def entry_node
      if @entry_node.nil?
        @entry_node = find_by_href(self.href_from_parent).remove
      end
      @entry_node
    end

    def pre_rule_assignment(parent)
      warn self.class + 'failed to implement pre_rule_assignment'
    end

    def additional_rules
      {}
    end

    def all_rules
      RULES.merge(additional_rules)
    end

    def doc
      self.usage_point.doc
    end

    def find_by_href(href)
      doc.xpath("//link[@rel='self' and @href='#{href}']/..")[0]
    end

    def assign_rule(attr_name)
      rule = all_rules[attr_name]
      rule_xml = entry_node.xpath(rule.xpath)
      value = rule_xml.empty? ? nil : rule_xml.text
      translated_value = value.nil? ? nil : translate(rule.type, value)
      self.send(rule.attr_name.to_s+"=", translated_value)
      translated_value
    end

    def get_related_links
      self.related_hrefs = []
      entry_node.xpath("./link[@rel='related']/@href").each do |href|
        if /\/\d+$/i.match(href.text)
          add_related_link(href.text)
        else
          many_related = doc.xpath("//link[@rel='up' and @href='#{href.text}']")
          many_related = alt_links(href.text) if many_related.length == 0
          many_related.each do |link|
            add_related_link(link.attr('href'), link.parent.remove)
          end
        end
      end
    end

    def add_related_link(href, entry_node = nil)
      self.related_hrefs << href
      name = get_related_name(href)
      classParser = Object.const_get("GreenButton::#{name}")
      if !classParser.nil?
        self.add_related_entry(underscore(name), classParser.new(href, entry_node, self))
      else
        other_related.push([href, entry_node])
      end
    end

    def add_related_entry(type, parser)
      warn self.class + ' does not have any recognized relations.'
    end

    private

    def get_related_name(href)
      regex = /(\w+)(\/\d+)*$/
      m = regex.match(href)
      if !m.nil?
        return m[1]
      end
      nil
    end

    def alt_links(href)
      # SDGE links map as .../MeterReading to .../MeterReading/\d+
      regex =  Regexp.new(href + '\/\d+$')
      related_links = doc.xpath("//link[@rel='self']").select do |e|
        if e['href'] =~ regex
          e.parent
        end
      end
      related_links
    end

    def create_method(name, &block )
      self.class.send(:define_method, name, &block )
    end

    def create_attr( name )
      create_method( "#{name.to_s}=".to_sym ) { |val|
        instance_variable_set( "@" + name.to_s, val)
      }
      create_method( name.to_sym ) {
        val = instance_variable_get( "@" + name.to_s )
        if val == false
          val = assign_rule(name)
          instance_variable_set( "@" + name.to_s, val)
        end
        val
      }
      instance_variable_set( "@" + name.to_s, false)
    end

  end
end
