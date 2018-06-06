require 'rails_helper'

describe "All components" do
  Dir.glob("app/views/govuk_publishing_components/components/*.erb").each do |filename|
    template = filename.split('/').last
    component_name = template.sub('_', '').sub('.html.erb', '')

    describe component_name do
      yaml_file = "#{__dir__}/../../app/views/govuk_publishing_components/components/docs/#{component_name}.yml"

      it "is documented" do
        expect(File).to exist(yaml_file)
      end

      it "has the correct documentation" do
        yaml = YAML.load_file(yaml_file)

        expect(yaml["name"]).not_to be_nil
        expect(yaml["description"]).not_to be_nil
        expect(yaml["examples"]).not_to be_nil
        expect(yaml["accessibility_criteria"]).not_to be_nil
      end

      it "has a correctly named spec file", skip: component_name.in?(%w[contextual_breadcrumbs contextual_sidebar success_alert taxonomy_navigation]) do
        rspec_file = "#{__dir__}/../../spec/components/#{component_name.gsub('-', '_')}_spec.rb"

        expect(File).to exist(rspec_file)
      end

      it "doesn't use `html_safe`", skip: template.in?(%w[_govspeak.html.erb]) do
        file = File.read(filename)

        expect(file).not_to match 'html_safe'
      end
    end
  end
end
