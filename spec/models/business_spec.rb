require "spec_helper"
describe Lessonable::Business do
  # let(:klass) { class DummyClass; include ; end }
  subject { Business.new }
  
  it "is a Class" do
    expect(subject.foo).to eq true
  end
end