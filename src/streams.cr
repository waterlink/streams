require "./streams/*"
require "./future"

module Streams
  extend self

  def source(enumerable : Enumerable)
    Source(typeof(enumerable.first)).new(enumerable)
  end

  module Sink
    extend self

    def each(f)
      Each(typeof(f.input)).new(f)
    end

    class Each(I)
      def initialize(@callable) end
      def handle(data) data.each { |x| handle_one(x) } end
      def handle_one(i : I) @callable.call(i); nil end
    end

    def fold(f2)
      Fold(typeof(f2.input1), typeof(f2.input2))
        .new(f2)
    end

    class Fold(A, I)
      def initialize(@callable) end
      def handle(data) data.inject { |acc, x| handle_one(acc, x) } end
      def handle_one(acc : A, x : I) @callable.call(acc, x) end
    end
  end

  module DSL
    def initialize(@data : Enumerable)
    end

    macro apply1(name)
      class {{name.id.camelcase}}(T) include DSL end
      def {{name.id}}(callable)
        {{name.id.camelcase}}(typeof(@data.{{name.id}} { |__| callable.call(__) }.first))
          .new(@data.{{name.id}} { |__| callable.call(__) })
      end
    end

    apply1 map
    apply1 select

    def run_with(sink)
      Future.new { sink.handle(@data) }
    end

    def to_a
      @data.to_a
    end
  end

  class Source(T) include DSL end

  class Probe(I)
    def call() yield I.allocate end
  end

  class Probe2(I1, I2)
    def call() yield(I1.allocate, I2.allocate) end
  end

  class F(I, O)
    def initialize(&@body : I -> O) end
    def call(i) @body.call(i) end
    def input() I.allocate end
    def output() O.allocate end
  end

  class F2(I1, I2, O)
    def initialize(&@body : (I1, I2) -> O) end
    def call(a, b) @body.call(a, b) end
    def input1() I1.allocate end
    def input2() I2.allocate end
    def output() O.allocate end
  end

macro f(expr)
{% ty = expr.receiver %}
{% fn = expr.args[0] %}
F({{ty}}, typeof(Probe({{ty}}).new.call { |__| {{fn}} }))
  .new { |__| {{fn}} }
end

macro f2(expr)
{% tys = expr.receiver %}
{% ty1 = tys[0] %}
{% ty2 = tys[1] %}
{% fn = expr.args[0] %}
F2({{ty1}}, {{ty2}}, typeof(Probe2({{ty1}}, {{ty2}}).new.call { |_1, _2| {{fn}} }))
  .new { |_1, _2| {{fn}} }
end
end
