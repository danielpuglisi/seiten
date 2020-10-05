module Seiten
  module HTML
    module Helpers
      def self.build_page_modifiers(page, current_page)
        modifiers = []
        modifiers << :parent if page.children?
        if page.active?(current_page)
          modifiers << :active
          modifiers << (page == current_page ? :current : :expanded)
        end
        modifiers
      end

      def self.build_classes(element = nil, class_options:, modifiers: [], merge: nil)
        classes = []

        klass = class_options[element || :base]
        classes << klass

        if modifiers.any?
          base = (class_options[:mod_base].presence || klass)
          modifiers.each do |modifier|
            classes << "#{base}#{class_options[:mod_sep]}#{class_options[:modifiers][modifier]}"
          end
        end

        classes << merge if merge
        classes.join(' ')
      end
    end
  end
end
