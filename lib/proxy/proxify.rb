module Proxy

  class ProxyContainer

    attr_reader :subject, :accepts

    def initialize(subject, accepts)
      @subject = subject
      @accepts = accepts
    end

    def method_missing(method, *args, &block)
      if @accepts.include?(method)
        return subject.send(method)
      else
        raise NoMethodError, method.to_s
      end
    end
  end

  module Proxify
    def proxy
      class_name = "#{self.class.name}Proxy"
      klass = Object.const_set(class_name,ProxyContainer)
      klass.new(self, self.class.acceptable)
    end
  end

  module ProxifyClass
    attr_accessor :acceptable

    def accepts(*ting)
      @acceptable = ting
    end
  end
end
