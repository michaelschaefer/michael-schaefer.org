#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals

AUTHOR = u'Michael Schaefer'
SITENAME = u'www.michael-schaefer.org'
SITEURL = 'https://www.michael-schaefer.org'

PATH = 'content'
STATIC_PATHS = ['./files/']

TIMEZONE = 'Europe/Paris'

DATE_FORMATS = {
    'de': '%d.%m.%Y',
    'en': '%m/%d/%Y'
}

DEFAULT_LANG = u'de'

THEME = './theme'
DIRECT_TEMPLATES = ['index', 'archives']

data = {
        'de': {
                'archives': {
                        'text': 'Die folgenden Artikel sind bereits in diesem Blog veröffentlicht worden:',
                        'title': 'Archiv',
                        'url': '/de/archiv/'
                },

                'article': {
                        'latest': 'Aktuelle Artikel',
                        'newer': 'neuere Artikel',
                        'older': 'ältere Artikel',
                        'read_entire': 'ganzen Artikel lesen',
                        'title': 'Artikel'
                },

                'aside': {
                        'notes': {
                                'text': 'Dieser Blog wird mit <a href=\"http://docs.getpelican.com/en/3.5.0/index.html#\">Pelican</a> generiert. Das Design ist inspiriert von <a href=\"http://colorlib.com/sparkling/\">Sparkling</a>.',
                                'title': 'Hinweise'
                        },

                        'profile': {
                                'gpg_text': 'Öffentlicher GnuPG Schlüssel',
                                'text': 'Diplom-Mathematiker und wissenschaftlicher Mitarbeiter an der Universität Münster. Verfolgt schwerpunktmäßig Computer- und naturwissenschaftliche Themen, kocht gerne, spielt Klavier. Benutzt Sublime Text 3 und Emacs.',
                                'title': 'Kurzprofil'
                        }
                },

                'tag': {
                        'text': 'Die folgenden Artikel sind mit diesem Tag markiert:',
                        'title': 'Tag',
                        'title_plural': 'Tags'
                }
        },

        'en': {
                'archives': {
                        'text': 'The following articles have already been published on this blog:',
                        'title': 'Archive',
                        'url': '/en/archive/'
                },

                'article': {
                        'latest': 'Latest articles',
                        'newer': 'newer article',
                        'older': 'older article',
                        'read_entire': 'read entire article',
                        'title': 'Article'
                },

                'aside': {
                        'notes': {
                                'text': 'This blog is powered by <a href=\"http://docs.getpelican.com/en/3.5.0/index.html#\">Pelican</a>. The design is inspired from <a href=\"http://colorlib.com/sparkling/\">Sparkling</a>.',
                                'title': 'Notes'
                        },

                        'profile': {
                                'gpg_text': 'GnuGP public key',
                                'text': 'Mathematician and scientific assistent at Münster University. Has a focus on computer and science related stuff, enjoys cooking and playing the piano. Uses Sublime Text 3 and Emacs.',
                                'title': 'Short profile'
                        }
                },

                'tag': {
                        'text': 'The following articles are marked with this tag:',
                        'title': 'Tag',
                        'title_plural': 'Tags'
                }
        }
}


def extract_paragraph(content):
	pos = content.find('\n')
	if pos == -1:
		return content
	else:
		return content[:pos]


def extract_string(lang, varargs):
        if lang not in data:
                return ''
        item = data[lang]
        for key in varargs:
                if key not in item:
                        return ''
                else:
                        item = item[key]
        return item


JINJA_FILTERS = { 
	'extract_paragraph': extract_paragraph,
	'extract_string': extract_string,
}

# urls
ARCHIVES_SAVE_AS = 'archiv/index.html'
ARTICLE_URL = '{date:%Y}/{date:%m}/{slug}'
ARTICLE_SAVE_AS = '{date:%Y}/{date:%m}/{slug}/index.html'
AUTHOR_SAVE_AS = ''
CATEGORY_SAVE_AS = ''
DRAFT_SAVE_AS = ''
DRAFT_LANG_SAVE_AS = ''
PAGE_URL = '{url}'
PAGE_SAVE_AS = '{url}/index.html'

# Plugins
PLUGIN_PATHS = ['/home/mscha_08/local/pelican-plugins']
PLUGINS = ['i18n_subsites']

# i18n_subsites
I18N_SUBSITES = {
    'de': {
    'ARCHIVES_SAVE_AS': 'archiv/index.html'
    },

    'en': {
    'ARCHIVES_SAVE_AS': 'archive/index.html'
    }
}

# Feed generation is usually not desired when developing
FEED_ATOM = 'atom.xml'
FEED_RSS = 'rss.xml'
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

DEFAULT_PAGINATION = 5

# Uncomment following line if you want document-relative URLs when developing
RELATIVE_URLS = True
