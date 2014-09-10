require 'spec_helper'

require File.join File.dirname(__FILE__), '..', 'helpers', 'breadcrumbs_helper'

describe BreadcrumbsHelper do
  before do
    @helper = Object.new
    @helper.singleton_class.send :include, BreadcrumbsHelper
  end

  describe '#breadcrumbs' do
    before do
      self.singleton_class.send :include, Padrino::Helpers
      @page = page
    end

    describe 'top-level page' do
      it 'returns a link to the page' do
        @helper.breadcrumbs(@page).must_equal link_to(@page.data.title, @page.data.path)
      end
    end

    describe 'non-top-level page' do
      it 'joins all links to parent pages with > signs' do
        parent = page
        grandparent = page
        @page.parent = parent
        @page.parent.parent = grandparent

        @helper.breadcrumbs(@page).must_equal([grandparent, parent, @page].collect do |level|
          link_to level.data.title, level.data.path
        end.join ' &gt; ')
      end
    end
  end

  private

  def page
    path = Faker::Internet.http_url
    title = Faker::Lorem.sentence
    data = OpenStruct.new path: path, title: title
    OpenStruct.new data: data
  end
end