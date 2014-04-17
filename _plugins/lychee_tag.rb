# Connects Jekyll with Lychee (http://lychee.electerious.com/)
#
# # Features
#
# * Generate album overview and link to image
# * more may come later
#
# # Usage
#
#   {% lychee_album <album_id> %}
#
# # Example
#
#   {% lychee_album 1 %}
#
# # Default configuration (override in _config.yml)
#
#   lychee:
#     url: http://electerious.com/lychee_demo
#     album_title_tag: h1
#     link_big_to: lychee
#
# Change at least "url" to your own Lychee installation
# album_title_tag: let's you chose which HTML tag to use around the album title
# link_big_to: choose "lychee" or "img".
#   lychee: links the image to the Lychee image view
#   img: links the image to it's original image
#
# # Author and license
#
# Tobias Brunner <tobias@tobru.ch> - https://tobrunet.ch
# License: MIT

require 'json'
require 'net/http'
require 'uri'

module Jekyll
  class LycheeAlbumTag < Liquid::Tag
    def initialize(tag_name, config, token)
      super      

      # get config from _config.yml
      @config = Jekyll.configuration({})['lychee'] || {}
      # set default values
      @config['album_title_tag'] ||= 'h1'
      @config['link_big_to']     ||= 'lychee'
      @config['url']             ||= 'http://electerious.com/lychee_demo'
      @config['columns']         ||= 3
      @config['separator']       ||= '|'

      # params coming from the liquid tag
      @params = config.strip.split(@config['separator'])

      # construct class wide usable variables
      @thumb_url = @config['url'] + "/uploads/thumb/"
      @big_url = @config['url'] + "/uploads/big/"
      @album_id = @params[0]
      @album_description = @params[1]
    end 

    def render(context)
      # initialize session with Lychee
      api_url = @config['url'] + "/php/api.php"
      uri = URI.parse(api_url)
      @http = Net::HTTP.new(uri.host, uri.port)
      @request = Net::HTTP::Post.new(uri.request_uri)
      @request['Cookie'] = init_lychee_session

      album = get_album(@album_id)
      album_content = album['content']

      # write header tag and description
      html = "<#{@config['album_title_tag']}>#{album['title']}</#{@config['album_title_tag']}>\n"
      if @album_description != nil
        html << "<p>\n\t#{@album_description}\n</p>\n"      
      end
      html << "<div class=\"album\">\n"      

      count = 1
      html << "\n<div class=\"row\">\n"

      album_content.each do |photo_id, photo_data|
        big_href = case @config['link_big_to']
          when "img" then @big_url + get_photo(@album_id, photo_id)['url']
          when "lychee" then @config['url'] + "#" + @album_id + "/" + photo_id
          else "#"
        end
        # html << "<a href=\"#{big_href}\" title=\"#{photo_data['title']}\"><img src=\"#{@thumb_url}#{photo_data['thumbUrl']}\"/></a>"
        html << "<div class=\"cell\"><a href=\"#{big_href}\"><img src=\"#{@thumb_url}#{photo_data['thumbUrl']}\"/></a></div>\n"
        if (count % @config['columns'] == 0)
          html << "</div>\n\n<div class=\"row\">\n"
        end
        count += 1
      end

      if (count % 3 == 0)
        html << "<div class=\"cell\"><div class=\"cell\">"
      elsif (count % 3 == 2)
        html << "<div class=\"cell\">"
      end

      return (html << "\n</div>")
    end

    # Lychee API mapping
    def init_lychee_session
      # construct request
      @request.set_form_data({'function' => 'init'})
      # send request now and save cookies
      response = @http.request(@request)
      return response.response['set-cookie']
    end
    def get_albums
      @request.set_form_data({'function' => 'getAlbums'})
      return JSON.parse(@http.request(@request).body)
    end
    def get_album(id)
      @request.set_form_data({'function' => 'getAlbum', 'albumID' => id, 'password' => ''})
      return JSON.parse(@http.request(@request).body)
    end
    def get_photo(album_id, photo_id)
      @request.set_form_data({'function' => 'getPhoto', 'albumID' => album_id, 'photoID' => photo_id, 'password' => ''})
      return JSON.parse(@http.request(@request).body)
    end
  end
end

Liquid::Template.register_tag('lychee_album', Jekyll::LycheeAlbumTag)