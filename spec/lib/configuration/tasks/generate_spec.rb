require "spec_helper"

describe Configuration::Tasks::Generate do
  before do
    Dir.stub(:glob).and_return(files)
    subject.instance_variable_set(:@grouped_files, nil)
  end

  describe ".generate_ymls" do
    before { subject.stub(:puts) }
    after { files = nil }

    context "when there is only a sample for a foo file" do
      let(:files) { [sample_file] }
      let(:sample_file) { "config/foo.yml.sample" }
      let(:destination_file) { "config/foo.yml" }
      let(:friendly_message) { "#{destination_file} generated from #{sample_file}" }

      it "generates an yaml file from sample" do
        FileUtils.should_receive(:cp).with(sample_file, destination_file)
        subject.generate_ymls
      end

      it "outputs a friendly message" do
        subject.should_receive(:puts).with(friendly_message)
        subject.generate_ymls
      end
    end

    context "when there is an yaml and a sample for a foo file" do
      let(:files) { [destination_file, sample_file] }
      let(:sample_file) { "config/foo.yml.sample" }
      let(:destination_file) { "config/foo.yml" }
      let(:friendly_message) { "#{destination_file} content have been replaced by #{sample_file} content" }

      context "when destination_file content is distinct from sample_file" do
        before do
          subject.should_receive(:read_content).with(sample_file).and_return("bar")
          subject.should_receive(:read_content).with(destination_file).and_return("baz")
        end

        it "replaces yaml file with sample" do
          FileUtils.should_receive(:cp).with(sample_file, destination_file)
          subject.generate_ymls
        end

        it "outputs a friendly message" do
          subject.should_receive(:puts).with(friendly_message)
          subject.generate_ymls
        end
      end

      context "when destination_file content is the same of sample_file" do
        before { subject.stub(:read_content).and_return("bar") }

        it "doesn't replace yaml file with sample" do
          FileUtils.should_not_receive(:cp)
          subject.generate_ymls
        end

        it "doesn't output a friendly message" do
          subject.should_not_receive(:puts)
          subject.generate_ymls
        end
      end
    end

    context "when there is another kind for a foo file" do
      let(:files) { [sample_file, other_file] }
      let(:sample_file) { "config/foo.yml.sample" }
      let(:other_file) { "config/foo.yml.other" }
      let(:error_message) { "An error ocurred when trying to copy config/foo.* files." }

      it "doesn't generate an yaml file from sample" do
        FileUtils.should_not_receive(:cp)
        subject.generate_ymls
      end

      it "outputs an error message" do
        subject.should_receive(:puts).with(error_message)
        subject.generate_ymls
      end
    end
  end

  describe ".grouped_files" do
    let(:files) { files_a + files_b }
    let(:files_a) { ["config/file_a.yml", "config/file_a.yml.sample"] }
    let(:files_b) { ["config/file_b.yml", "config/file_b.yml.sample"] }

    it "returns a list of files grouped by file name" do
      subject.grouped_files["file_a"].should be_eql files_a
      subject.grouped_files["file_b"].should be_eql files_b
    end
  end
end
