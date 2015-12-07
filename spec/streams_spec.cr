require "./spec_helper"

include Streams

Spec2.describe Streams do
  it "works with simple example" do
    s = String.build do |io|
      source("Hello world".each_char)
        .map(f Char[__.upcase])
        .select(f Char[77 < __.ord])
        .run_with(Sink.each f Char[io << __])
        .await
    end

    expect(s).to eq("OWOR")
  end

  it "allows to run with fold" do
    fut = source("Hello world".each_char)
      .map(f Char[__.upcase])
      .select(f Char[77 < __.ord])
      .map(f Char[__.ord])
      .run_with(Sink.fold f2 [Int32, Int32][_1 + _2])

    fut.map(f Int32[expect(__).to eq(327)]).await.success!
  end
end
