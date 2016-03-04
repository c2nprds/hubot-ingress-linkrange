# Description:
#   Ingress link range calculation commands for Hubot
#
# Commands:
#   hubot linkrange <levels> <linkamps> - get link range, <levels=[1-8]{8}> <linkamps=VRLA,ULA,LA>, #ingress
#

module.exports = (robot) ->
  robot.respond /linkrange ([1-8]{8})(.*)?$/i, (msg) ->
    levels   = String(msg.match[1]).split('')
    linkamps = if msg.match[2] then msg.match[2].trim().split(',') else ['NONE']
    total    = 0

    return if linkamps.length > 4

    for level in levels
      total += parseInt(level)

    linkamps.sort (a, b) ->
      multiplier(b) - multiplier(a)

    average     = Math.floor(total/8)
    baseRange   = 160*Math.pow(total/8, 4)

    msg.send "PortalLevel: #{average}\n"+
             "MODS: #{linkamps}\n"+
             "BaseRange: #{formatRange baseRange}\n"+
             "RangeMultiplier: #{rangeBoost(linkamps)}\n"+
             "Range: #{formatRange (baseRange)*rangeBoost(linkamps)}"

  formatRange = (range) ->
    if (range >= 10000)
      range = "#{Math.round(range/10)/100}km"
    else if (range >= 1000)
      range = "#{Math.round(range/10)/100}km"
    else
      range = "#{Math.round(range)}m"
    range

  multiplier = (linkamp) ->
    if linkamp == 'VRLA' or linkamp == 'vrla'
      return 7000
    else if linkamp == 'ULA' or linkamp == 'ula'
      return 5000
    else if linkamp == 'LA' or linkamp == 'la'
      return 2000
    else
      return 0

  rangeBoost = (linkamps) ->
    scale = [1.0, 0.25, 0.125, 0.125]
    boost = 0.0
    count = 0
    for mod in linkamps
      if multiplier(mod)
        continue unless scale[count]?
        baseMultiplier = multiplier(mod)/1000
        boost += baseMultiplier*scale[count]
        count++
    return if (count > 0) then boost else 1.0
