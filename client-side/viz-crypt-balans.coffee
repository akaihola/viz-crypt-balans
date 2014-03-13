getBalance = (address) ->
  $.get "https://blockchain.info/q/addressbalance/#{address}"

getRate = ->
  $.getJSON 'https://api.bitcoinaverage.com/ticker/global/EUR/'

DENOMINATIONS = [50000, 20000, 10000, 5000, 2000, 1000, 500,
                 200, 100, 50, 20, 10, 5, 2, 1]

getChange = (target) ->
  total = 0
  result = {}
  for denomination in DENOMINATIONS
    while total + denomination <= target
      result[denomination] ?= 0
      result[denomination] += 1
      total += denomination
  return result

getParameterByName = (name) ->
  name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]")
  regex = new RegExp "[\\?&]" + name + "=([^&#]*)"
  results = regex.exec location.search
  if results is null then "" else decodeURIComponent(results[1].replace(/\+/g, " "))

display = (balance, rate) ->
  eurocents = Math.floor(rate * balance / 1000000)
  notesAndCoins = getChange eurocents
  for denomination in DENOMINATIONS
    if denomination of notesAndCoins
      for counter in [1..notesAndCoins[denomination]]
        extension = if denomination <= 200 then 'gif' else 'jpg'
        $('<img/>', {'src': "../static/images/#{denomination}.#{extension}"}).appendTo('body')

$(document).ready ->
  address = getParameterByName 'address'
  $.when(
    getBalance(address)
    getRate()
  ).done (balanceResponse, rateResponse) ->
    balance = balanceResponse[0]
    rate = rateResponse[0].bid
    display balance, rate