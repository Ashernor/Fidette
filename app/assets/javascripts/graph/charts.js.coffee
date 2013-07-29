# Taken from admin/graph/graphs.js

momentInHash = (_moment, hash) ->
  for strDate, number of hash
    # Because the key is a string we convert it to a date.
    # moment(strDate) is a moment, we get a native JS date by calling toDate() on it (cf. momentjs doc).
    realDate = moment(strDate).toDate()
    momentDate = moment(_moment).startOf('day').toDate()
    return number if momentDate.getTime() == realDate.getTime()
  false

getWeekRangeForChart = (chartElement) ->
  start = moment(chartElement.data('start'))
  end = moment(chartElement.data('end'))
  range = moment().range(start, end)
  nextWeek = start.clone().add('days', 7)

  # This is a one week long range
  oneWeekRange = moment().range(start, nextWeek)

  [range, oneWeekRange]

getRangeForChart = (chartElement) ->
  start = moment(chartElement.data('start'))
  end = moment(chartElement.data('end'))
  range = moment().range(start, end)
  nextDay = start.clone().add('days', 1)

  # This is a one day long range
  oneDayRange = moment().range(start, nextDay)

  [range, oneDayRange]

# # # # # # # # # # # # # # # #

window.initCharts = (chartList, mode = 'day') ->
  google.load("visualization", "1", {packages:["corechart"]})
  google.setOnLoadCallback(-> drawCharts(chartList, mode))

  $statsContent = $('#stats-content')
  $statsContent.click -> window.location = $statsContent.data('url')

graphOptions = (titlesAndValues) ->
  valuesWithDates = (e[1] for e in titlesAndValues)[0]
  values = (parseInt(v) for date, v of valuesWithDates)
  maxValue = Math.max(values...) # Only accepts a list of arguments... So we use a splat.

  options =
    min: 0
    pointSize: 6
    lineSize: 2
    backgroundColor: '#F9F9F9'
    vAxis:
      maxValue: maxValue
      gridlines:
        count: (1 if maxValue >= 0) # Prevents a bug if there are no values
    legend:
      position: 'bottom'
    chartArea:
      top:30
      width:"90%"

extractValuesFromData = (data, titlesOrTitle) ->
  titlesAndValues = []

  if data instanceof Array && titlesOrTitle instanceof Array && data.length == titlesOrTitle.length
    titles = titlesOrTitle
    for e in data
      index = data.indexOf(e)
      title = titles[index]
      titlesAndValues.push([title, e])

  else if (data not instanceof Array) && (titlesOrTitle not instanceof Array)
    titlesAndValues.push [titlesOrTitle, data]

  else
    console.log 'Error missing titles or values or they do not have the same size'

  titlesAndValues

drawCharts = (chartList, mode) ->
  for chartId in chartList
    $chart = $("##{chartId}")
    values = $chart.data('values')
    titlesAndValues = extractValuesFromData($chart.data('values'), $chart.data('titles') || $chart.data('title'))

    if (chartId == "chart-2")
      chart = new google.visualization.PieChart($chart[0])
      chart.draw(populatePieChart($chart.data('values'), $chart), graphOptions(titlesAndValues))
    else
      chart = new google.visualization.AreaChart($chart[0])
      chart.draw(populateChart(titlesAndValues, mode, $chart), graphOptions(titlesAndValues))

# Makes an array from queries according to params and fills empty dates with "0" and returns it
populateChart = (listOfTitlesAndValues, mode, chartElement) ->
  data = new google.visualization.DataTable()
  values = []

  data.addColumn('date', 'Date')

  for e in listOfTitlesAndValues
    values.push e[1] # Hash of values
    data.addColumn('number', e[0]) # Column title

  [range, oneWeekRange] =
    if mode == 'week'
      getRangeForChart(chartElement)
    else
      getWeekRangeForChart(chartElement)

  # Browse the range day by day
  range.by oneWeekRange, (d) -> # d is a moment
    rowValues = []

    for hashOfValues in values
      rowValues.push momentInHash(d, hashOfValues) || 0

    date = moment(d).startOf('day').toDate()
    data.addRow([date, rowValues...])

  data

populatePieChart = (listOfTitlesAndValues, chartElement) ->
  listOfTitlesAndValues = JSON.parse("[" + listOfTitlesAndValues  + "]")
  data = new google.visualization.DataTable()

  data.addColumn('string', 'Type');
  data.addColumn('number', 'Montant');
  for e in listOfTitlesAndValues
    data.addRow([e[0],e[1]])

  data

window.setChartForElements = (stats_type = 'week') ->
  list = $(".chart")
  charts = (c_num.id for c_num in list)
  initCharts(charts, stats_type)
