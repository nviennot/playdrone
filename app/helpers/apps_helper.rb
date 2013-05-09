module AppsHelper
  def do_facet(facet, options={}, &block)
    terms = @results.facets[facet.to_s].terms
    terms = terms.sort_by { |t| t['term'] } if options[:sort]
    terms = terms.reverse if options[:reverse]

    ["<p>",
     ("#{options[:name]}: " if options[:name]),
     terms.map(&block),
    "</p>"].flatten.compact.join.html_safe
  end

  def do_facet_with_link(facet, options={})
    do_facet(facet, options) do |f|
      term = f['term'].to_s

      if options[:array]
        if params[facet].to_a.include? term
          css = "selected"
          target = params[facet].to_a - [term]
          target = nil unless target.present?
        else
          css = nil
          target = params[facet].to_a + [term]
        end
      else
        if params[facet] == term
          css = "selected"
          target = nil
        else
          css = nil
          target = term
        end
      end

      name = options[:name_lookup] ? options[:name_lookup].call(term) : term
      name = name.split('_').map(&:capitalize).join(' ') if options[:capitalize]
      link_to(name, params.merge(facet => target, :page => nil), :class => css) + "<span class='count'>#{f['count']}</span> ".html_safe
    end
  end

  def list_facet(facet, name, options={})
    do_facet_with_link(facet, options.merge(:name => name, :array => true))
  end

  def bool_facet(facet, true_string, false_string, options={})
    name_lookup = ->(v){ v == 'T' ? true_string : false_string }
    do_facet_with_link(facet, :reverse => true, :name_lookup => name_lookup)
  end
end
