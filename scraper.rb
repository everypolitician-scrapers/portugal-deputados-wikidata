#!/bin/env ruby
# encoding: utf-8

require 'wikidata/fetcher'

names = EveryPolitician::Wikidata.wikipedia_xpath(
  url: 'https://pt.wikipedia.org/wiki/Lista_de_deputados_de_Portugal',
  after: '//span[@id="A"]',
  xpath: '//table//td[1]//a[not(@class="new")]/@title',
)

by_category_pt = WikiData::Category.new( 'Categoria:Deputados da Assembleia da República Portuguesa', 'pt').member_titles
by_category_de = WikiData::Category.new( 'Kategorie:Mitglied der Assembleia da República', 'de').member_titles

# Find all P39s of the Legislature
query = <<EOS
  SELECT DISTINCT ?item WHERE {
    VALUES ?position { wd:Q19953703 wd:Q43185266 }
    ?item p:P39/ps:P39 ?position .
  }
EOS
p39s = EveryPolitician::Wikidata.sparql(query)

# anyone with a Portuguese parliament ID
idquery = 'SELECT DISTINCT ?item WHERE { ?item wdt:P6199 [] }'
ppids = EveryPolitician::Wikidata.sparql(idquery)

EveryPolitician::Wikidata.scrape_wikidata(ids: p39s | ppids, names: { pt: names | by_category_pt, de: by_category_de })
