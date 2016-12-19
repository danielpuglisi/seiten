module Seiten
  module BreadcrumbBuilder
    # get breadcrumb of given page (reversed)
    def self.call(page)
      pages ||= []
      pages << page
      if page.parent
        pages << call(page.parent)
      end
      pages.flatten
    end
  end
end
