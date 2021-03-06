allYears = [1960 to 2012]
class Country
  (@id, @name, @dates, @years) ->
    @firstYears = {}
    for type, year of @dates
      index = allYears.indexOf year
      @firstYears[type] = @years[index]
    if @id == \Slovakia
      @isSlovakia = yes
    else if @id == "Czech Republic"
      @isCzech = yes
    for year in @years
      year.country = @

    @searchable = if @name
      that
        .replace "Á" "Az"
        .replace "Č" "Cz"
        .replace "Ř" "Rz"
        .replace "Š" "Sz"
    else
      ""

ig.processData = ->
  dates = processDates!
  lines = ig.data.stats.split "\n"
    ..shift!
  allMetrics =
    "abortions-total"
    "abortions-teen"
    "births-outside-marriage"
    "fertility-rate"
    "age-at-first-child"
    "pregnancies-total"
    "pregnancies-teen"
    "divorce-rate"
    "marriage-rate"
    "hiv-rate"
    "family-incomplete"

  countries = for line in lines
    [id, countryName, god, lifeForce, noGod, teenFemales, ...years] = line.split "\t"
    teenFemales = parseInt teenFemales, 10
    years .= map (d, i) ->
      year = allYears[i]
      yearData = {year}
      for cell, index in  d.split "|"
        metric = allMetrics[index]
        [value, footnotes] = cell.split "&"
        value = if value.length
          parseFloat value
        else
          null
        yearData[metric] = {value, footnotes}
      abortionsRate = if yearData['abortions-total'].value and yearData['pregnancies-total'].value
        yearData['abortions-total'].value / (yearData['pregnancies-total'].value + yearData['abortions-total'].value) * 100
      else
        null
      yearData['abortions-rate'] = value: abortionsRate
      teenPregRate = if yearData['pregnancies-teen'].value and yearData['abortions-teen'].value
        (yearData['pregnancies-teen'].value + yearData['abortions-teen'].value) / teenFemales * 100
      else
        null
      yearData['pregnancies-teen-rate'] = value: teenPregRate
      yearData
    country = new Country id, countryName, dates[id], years
      ..god       = parseFloat god
      ..noGod     = parseFloat noGod
      ..lifeForce = parseFloat lifeForce
  countries

processDates = ->
  lines = ig.data.dates.split "\n"
    ..shift!
    ..pop!
  countryDates = {}
  for line in lines
    [country, ...dates] = line.split "\t"
    dates .= map ->
      if it.length
        parseInt do
          it.split "-" .0
          10
      else
        9999
    [civil, marriage, adoption, marriageBan] = dates
    countryDates[country] = {civil, marriage, adoption, marriageBan}
  countryDates


