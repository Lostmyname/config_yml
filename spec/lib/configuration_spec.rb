require "spec_helper"

describe Configuration do
  let(:files) { ["config/file_a.yml", "config/file_b.yml"] }

  before do
    subject.instance_variable_set(:@hash, nil)
    Dir.stub(:glob).and_return(files)
    YAML.stub(:load_file).and_return(file_a, file_b)
  end

  describe "loading config files" do
    let(:file_a) { double }
    let(:file_b) { double }

    it "loads all config files" do
      subject.files.should be_eql files
    end
  end

  describe ".env" do
    let(:file_a) { double }
    let(:file_b) { double }
    let(:rack_env) { "rack_test" }
    let(:rails_env) { "rails_test" }

    before { subject.instance_variable_set(:@env, nil) }

    context "when Rack application" do
      before { ENV["RACK_ENV"] = rack_env }
      after { ENV["RACK_ENV"] = nil }

      it "returns the environment as symbol" do
        subject.env.should be_eql rack_env.to_sym
      end
    end

    context "when is a Rails application" do
      before do
        module Rails ; end
        Rails.stub(:env).and_return(rails_env)
      end

      after { Object.send(:remove_const, :Rails) }

      it "returns the environment as symbol" do
        subject.env.should be_eql rails_env.to_sym
      end
    end

    context "when environment isn't defined" do
      it "returns nil" do
        subject.env.should be_nil
      end
    end
  end

  describe "acessing a key from configuration files" do
    context "when a file has a flat hash" do
      let(:file_a) { { key_a: "value_a" } }
      let(:file_b) { { key_b: "value_b" } }

      it "responds to keys split in different files" do
        subject.file_a[:key_a].should be_eql "value_a"
        subject.file_b[:key_b].should be_eql "value_b"
      end
    end

    context "when a file has a nested hash" do
      let(:file_a) { { nested: { key: "value" } } }
      let(:file_b) { double }

      it "responds to nested key values" do
        subject.file_a[:nested][:key].should be_eql "value"
      end
    end

    context "when a file first level keys is environment names" do
      let(:file_b) { double }
      let(:file_a) do
        { test: { key: "value_test" },
          development: { key: "value_dev" } }
      end

      before { ENV["RACK_ENV"] = "test" }
      after { ENV["RACK_ENV"] = nil }

      it "returns hash of environment key" do
        subject.file_a[:key].should be_eql "value_test"
      end

      it "doesn't load hash of other environments" do
        subject.file_a[:key].should_not be_eql "value_dev"
      end
    end

    context "when configuration file doesn't exist" do
      let(:file_a) { double }
      let(:file_b) { double }

      it "returns nil" do
        subject.foo.should be_nil
      end
    end
  end
end
