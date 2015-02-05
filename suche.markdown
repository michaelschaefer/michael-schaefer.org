---
layout: staticPage
title: Suche
type: static
permalink: /suche/
---

{% include language.html %}

<p>
  Die Suche beinhaltet auch den englischen Teil dieser Webseite
</p>

<div id="search">
  <form action="/suche/" method="get">
    <input type="text" id="searchQuery" name="q" placeholder="Suchbegriff" autocomplete="off">
  </form>
</div>

<h2>Ergebnisse:</h2>
<div id="searchResults" style="display: block;">
  <ul class="entries">
  </ul>
</div>
<noscript>
  Die Suche funktioniert nur bei aktiviertem JavaScript. Alternativ stehen 
  das Archiv und die Tag-Liste zur Verfügung.
</noscript>

{% raw %}
<script id="searchResultsTemplate" type="text/mustache">
  {{#entries}}
    <li>      
      {{#date}}Beitrag:&nbsp;{{/date}}{{^date}}Seite:&nbsp;{{/date}}
      <a href="{{url}}">{{title}}</a>
    </li>
  {{/entries}}  
</script>
{% endraw %}

<script src="/js/search.js" type="text/javascript" charset="utf-8"></script>

{% raw %}
<script type="text/javascript">
  $(function() {
    $('#searchQuery').lunrSearch({
      indexUrl: '/js/index.json',   // Url for the .json file containing search index data
      results : '#searchResults',  // selector for containing search results element
      entries : '.entries',         // selector for search entries containing element (contained within results above)
      template: '#searchResultsTemplate',  // selector for Mustache.js template
      empty: 'Nichts gefunden'
    });
  });
</script>
{% endraw %}

