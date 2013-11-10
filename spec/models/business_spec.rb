require "spec_helper"
describe Lessonable::Business do
  # let(:klass) { class DummyClass; include ; end }
  subject { Business.new }
  
  it "has a name and description" do
    expect(subject.respond_to?(:name)).to eq true
    expect(subject.respond_to?(:description)).to eq true
  end
end