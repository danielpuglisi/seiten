module Seiten
  class SlugBuilder

    def self.call(page_options, prefix_url='')
      page_options = page_options.with_indifferent_access
      title = page_options['title']
      url   = page_options['url']
      root  = page_options['root']

      # if url is nil parameterize title otherwise just use url
      slug = url.nil? ? title.parameterize : url

      # prepend prefix_url if slug is not root or external url
      unless slug[0] == "/" || !!(slug.match(/^https?:\/\/.+/)) || !prefix_url.present?
        slug = "#{prefix_url}/#{slug}"
      end

      # return empty string if page slug is /
      if slug == "/" || root == true
        slug = ""
      end

      # remove leading slash if present
      if slug
        slug = slug[1..-1] if slug[0] == "/"
      end

      slug
    end

  end
end
