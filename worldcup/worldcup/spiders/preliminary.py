



from scrapy.spider import Spider
from scrapy.selector import Selector
from scrapy.contrib.linkextractors.sgml import SgmlLinkExtractor
from scrapy.contrib.spiders.crawl import CrawlSpider, Rule
from scrapy.http import Request

from worldcup.items import MatchResultItem

import re, json, string, datetime, uuid


class PreliminarySpider(Spider):
  name = "preliminary"
  start_urls = ['http://es.fifa.com/worldcup/matches/preliminaries/africa/index.html',
'http://es.fifa.com/worldcup/matches/preliminaries/asia/index.html',
'http://es.fifa.com/worldcup/matches/preliminaries/europe/index.html',
'http://es.fifa.com/worldcup/matches/preliminaries/nccamerica/index.html',
'http://es.fifa.com/worldcup/matches/preliminaries/oceania/index.html',
'http://es.fifa.com/worldcup/matches/preliminaries/southamerica/index.html']


  def parse(self, response):
    sel = Selector(response)

    ret = []

    matches = sel.xpath('//div[@class="mu result"]/a/div[@class="mu-m"]')

    for match in matches:
        try:
            it = MatchResultItem()
            it['home'] = match.xpath('div[@class="t home"]/div[@class="t-n"]/span/text()').extract()[0]
            it['away'] = match.xpath('div[@class="t away"]/div[@class="t-n"]/span/text()').extract()[0]

            ret.append(it)
        except Exception:
            print "No se pudo obtener: %s" % match.extract()

    return ret