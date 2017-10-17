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
    ?item p:P39 [ ps:P39 wd:Q19953703 ] .
  }
EOS
p39s = EveryPolitician::Wikidata.sparql(query)

EveryPolitician::Wikidata.scrape_wikidata(ids: p39s, names: { pt: names | by_category_pt, de: by_category_de })


