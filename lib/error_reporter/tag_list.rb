module SupportBee
  class TagList
    attr_writer :severity

    include SupportBee::Errors

    def initialize(tags, options = {})
      @tags = tags
      @severity = options[:severity]
    end

    def to_a
      tags = Array(@tags)
      raise_error_if_any_invalid_tag(tags)
      tags = add_severity_tag(tags)

      tags
    end

    private

    def raise_error_if_any_invalid_tag(tags)
      raise InvalidTag.new('A tag is invalid') if any_invalid_tag?(tags)
    end

    def any_invalid_tag?(tags)
      !(tags - valid_tags).empty?
    end

    def valid_tags
      SupportBee::VALID_TAGS
    end

    def add_severity_tag(tags)
      tags << severity_tag
    end

    def severity_tag
      case @severity
      when :critical
        "severity_critical"
      when :low
        "severity_low"
      else
        "severity_normal"
      end
    end
  end
end
