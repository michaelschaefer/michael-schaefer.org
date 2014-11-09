module Jekyll

	class ArchivePage < Page
		def initialize(site, base, dir, year, month, postList)
			@site = site
			@base = base
			@dir = dir
			@name = 'index.html'

			self.process(@name)
			self.read_yaml(File.join(base, '_layouts'), 'archive.html')
			self.data['title'] = month + '/' + year
			self.data['posts'] = postList
		end
	end	


	class ArchiveGenerator < Generator
		safe true

		def generate(site)

			posts = {}
			site.posts.each do |post|				

				date = post.date
				month = date.strftime("%m")
				year = date.strftime("%Y")

				post.categories.each do |locale|
					if posts[locale] == nil
						posts[locale] = {}
					end

					if posts[locale][year] == nil
						posts[locale][year] = {}
					end

					if posts[locale][year][month] == nil
						posts[locale][year][month] = []
					end

					posts[locale][year][month] << post
				end				

			end

			posts.each do |locale, archive|
				archive.each do |year, monthList|
					monthList.each do |month, postList|
						dir = File.join(locale, 'archive', year, month)
						if locale == 'de'
							dir = File.join('archiv', year, month)
						end
						site.pages << ArchivePage.new(site, site.source, dir, year, month, postList)
					end
				end
			end			
			
		end
	end

end