#!/bin/env ruby
# encoding: utf-8

require 'wikidata/fetcher'
require 'pry'

names = EveryPolitician::Wikidata.wikipedia_xpath( 
  url: 'https://pt.wikipedia.org/wiki/Lista_de_deputados_de_Portugal',
  after: '//span[@id="A"]',
  xpath: '//table//td[1]//a[not(@class="new")]/@title',
) 

EveryPolitician::Wikidata.scrape_wikidata(names: { pt: names })
warn EveryPolitician::Wikidata.notify_rebuilder


