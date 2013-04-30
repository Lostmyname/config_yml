require "spec_helper"

describe Configuration::Syntax::Conf do
  let(:files) { ["config/file_a.yml", "config/file_b.yml"] }
  let(:file_a) { { key_a: "value_a" } }
  let(:file_b) { { key_b: "value_b" } }

  before do
    Dir.stub(:glob).and_return(files)
    YAML.stub(:load_file).and_return(file_a, file_b)
  end

  it "provides an interface for access yml config files" do
    Conf.file_a[:key_a].should be_eql "value_a"
    Conf.file_b[:key_b].should be_eql "value_b"
  end

  it "doesn't provide an interface for access other attributes" do
    Conf.files.should_not be_eql files
  end
end
