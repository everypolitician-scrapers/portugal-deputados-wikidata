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

# Find all P39s of the 13th Legsislatura
query = <<EOS
  SELECT DISTINCT ?item
  WHERE
  {
    BIND(wd:Q19953703 AS ?membership)
    BIND(wd:Q25379987 AS ?term)

    ?item p:P39 ?position_statement .
    ?position_statement ps:P39 ?membership .
    ?position_statement pq:P2937 ?term .
  }
EOS
p39s = EveryPolitician::Wikidata.sparql(query)

EveryPolitician::Wikidata.scrape_wikidata(ids: p39s, names: { pt: names | by_category_pt, de: by_category_de })


