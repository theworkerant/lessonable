require "spec_helper"

describe "ActiveAdmin User" do
  let(:resource_class) { User }
  let(:namespace)  { ActiveAdmin.application.namespaces[:admin] }
  let(:resource)   { namespace.resource_for(resource_class) }
  
  it "has the correct name" do
    expect(resource.resource_name).to eq "User"
  end
  it "shows in the menu" do
    resource.should be_include_in_menu
  end
end