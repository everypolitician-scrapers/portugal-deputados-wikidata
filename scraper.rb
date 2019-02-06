#!/bin/env ruby
# encoding: utf-8

require 'wikidata/fetcher'

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

EveryPolitician::Wikidata.scrape_wikidata(ids: p39s | ppids)
