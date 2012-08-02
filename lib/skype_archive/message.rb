module SkypeArchive
  class Message
    attr_reader :attributes

    def initialize(attributes={})
      @attributes = attributes
      @timestamp = @attributes.delete(:timestamp)
      @attributes[:created_at] = Time.at(@timestamp)
    end

    def method_missing(method, *args, &block)
      @attributes[method.to_sym] or super
    end
  end
end
