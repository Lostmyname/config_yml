require "spec_helper"

describe Configuration do
  let(:files) { ["config/file_a.yml", "config/file_b.yml"] }

  before do
    Configuration.instance_variable_set(:@hash, nil)
    Dir.stub(:glob).and_return(files)
    YAML.stub(:load_file).and_return(file_a, file_b)
  end

  describe "loading config files" do
    let(:file_a) { double }
    let(:file_b) { double }

    it "loads all config files" do
      Configuration.file_a
      Configuration.files.should be_eql files
    end
  end

  describe "acessing a key from configuration files" do
    context "when a file has a flat hash" do
      let(:file_a) { { key_a: "value_a" } }
      let(:file_b) { { key_b: "value_b" } }

      it "responds to keys split in different files" do
        Configuration.file_a[:key_a].should be_eql "value_a"
        Configuration.file_b[:key_b].should be_eql "value_b"
      end
    end

    context "when a file has a nested hash" do
      let(:file_a) { { nested: { key: "value" } } }
      let(:file_b) { double }

      it "responds to nested key values" do
        Configuration.file_a[:nested][:key].should be_eql "value"
      end
    end

    context "when a file first level keys is environment names" do
      let(:file_b) { double }
      let(:file_a) do
        { test: { key: "value_test" },
          development: { key: "value_dev" } }
      end

      it "returns hash of environment key" do
        Configuration.file_a[:key].should be_eql "value_test"
      end

      it "doesn't load hash of other environments" do
        Configuration.file_a[:key].should_not be_eql "value_dev"
      end
    end

    context "when configuration file doesn't exist" do
      let(:file_a) { double }
      let(:file_b) { double }

      it "returns nil" do
        Configuration.foo.should be_nil
      end
    end
  end
end
