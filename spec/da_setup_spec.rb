require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../lib/da_setup')

describe DaSetup do

  before do
    stub_request(:get, "http://myfilelocation.com/").
       with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
       to_return(:status => 200, :body => {foo: "bar"}.to_json, :headers => {})
  end

  describe "new" do

    it "sets @@device_atlas" do
      DaSetup.any_instance.stub(:remote_file_exists?).and_return true
      DeviceAtlas.any_instance.stub(:getTreeFromFile).and_return {}

      @da_setup = DaSetup.new("http://myfilelocation.com")
      DaSetup.class_variable_get(:@@device_atlas).should be_a_kind_of DeviceAtlas
    end

    it "sets @@device_atlas_tree" do
      DaSetup.any_instance.stub(:remote_file_exists?).and_return true
      DeviceAtlas.any_instance.stub(:getTreeFromFile).and_return these: "params"

      @da_setup = DaSetup.new("http://myfilelocation.com")
      DaSetup.class_variable_get(:@@device_atlas_tree).should == {these: "params"}
    end

    it "raises an error if the file isn't found" do
      DaSetup.any_instance.stub(:remote_file_exists?).and_return false
      lambda do
        @da_setup = DaSetup.new("http://myfilelocation.com")
      end.should raise_error
    end

  end

  describe "get_properties" do
    it "returns a hash of device properties" do
      DaSetup.any_instance.stub(:remote_file_exists?).and_return true
      DeviceAtlas.any_instance.stub(:getTreeFromFile).and_return {}
      mock_da = mock "DeviceAtlas"
      DeviceAtlas.any_instance.stub(:getProperties).and_return mock_da
      DaSetup.new("http://myfilelocation.com").get_properties("my_user_agent").should == mock_da
    end
  end

end