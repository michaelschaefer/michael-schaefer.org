---
layout: staticPage
title: Search
type: static
permalink: /en/search/
---

{% include language.html %}

<p>
  Please note that the search will also include the german part of the website
</p>

<div id="search">
  <form action="/en/search/" method="get">
    <input type="text" id="searchQuery" name="q" placeholder="search query" autocomplete="off">
  </form>
</div>

<h2>Results:</h2>
<div id="searchResults" style="display: none;">
  <ul class="entries">
  </ul>
</div>
<noscript>
  The search is only working with activated JavaScript. Alternatively, archive
  and tag list can be used.
</noscript>

{% raw %}
<script id="searchResultsTemplate" type="text/mustache">
  {{#entries}}
    <li>      
      <a href="{{url}}">{{title}}</a>
    </li>
  {{/entries}}
</script>
{% endraw %}

<script src="/js/search.min.js" type="text/javascript" charset="utf-8"></script>

{% raw %}
<script type="text/javascript">
  $(function() {
    $('#searchQuery').lunrSearch({
      indexUrl: '/js/index.json',   // Url for the .json file containing search index data
      results : '#searchResults',  // selector for containing search results element
      entries : '.entries',         // selector for search entries containing element (contained within results above)
      template: '#searchResultsTemplate',  // selector for Mustache.js template
      empty: 'Nothing found'
    });
  });
</script>
{% endraw %}

