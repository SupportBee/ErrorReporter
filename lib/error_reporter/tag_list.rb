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
      tags = add_severity_tag(tags)

      tags
    end

    private

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
