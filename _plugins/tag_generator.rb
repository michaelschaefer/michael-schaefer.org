module Jekyll

	class TagPage < Page
		def initialize(site, base, dir, tag, posts, lang)
			@site = site
			@base = base
			@dir = dir
			@name = File.join(CGI.escape(tag), 'index.html')

			self.process(@name)
			self.read_yaml(File.join(base, '_layouts'), 'listPage.html')
			self.data['title'] = tag
			self.data['type'] = 'tag'
			self.data['posts'] = posts			
			self.data['lang'] = lang
			
		end
	end


	class TagPageGenerator < Generator
		safe true

		def generate(site)			
			site.tags.each do |tag, postList|							
				posts = {}
				postList.each do |post|
					post.categories.each do |locale|
						if posts[locale] == nil
							posts[locale] = []
						end
						posts[locale] << post
					end
				end

				posts.each do |locale, postList|
					dir = File.join(locale, 'tags')
					if locale == 'de'
						dir = 'tags'
					end					
					site.pages << TagPage.new(site, site.source, dir, tag.downcase, postList, locale)
				end
			end
		end
	end

end
