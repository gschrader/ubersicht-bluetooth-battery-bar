width        = '367px'
barHeight    = '36px'
labelColor   = '#fff'
usedColor    = '#d7051d'
freeColor    = '#525252'
bgColor      = '#fff'
borderRadius = '3px'
bgOpacity    = 0.9

command: """
kbatt=`ioreg -n "AppleBluetoothHIDKeyboard" | grep BatteryPercent | tail -1 | awk -F"=" {'print $2'}` &&
if [ ${#kbatt} -gt 0 ]; then echo "Keyboard$kbatt%"; fi &&
tbatt=`ioreg -c BNBTrackpadDevice | grep BatteryPercent | tail -1 | awk -F"=" {'print $2'}` &&
if [ ${#tbatt} -gt 0 ]; then echo "Trackpad$tbatt%"; fi &&
mbatt=`ioreg -c BNBMouseDevice | grep BatteryPercent | tail -1 | awk -F"=" {'print $2'}` &&
if [ ${#mbatt} -gt 0 ]; then echo "Mouse$mbatt%"; fi;
"""

refreshFrequency: 20000

style: """
  // Change bar height
  bar-height = 6px

  // Align contents left or right
  widget-align = left

  // Position this where you want
  top 700px
  left 10px

  color #fff
  font-family Helvetica Neue
  background rgba(#000, .5)
  padding 10px 10px 15px
  border-radius 5px

  .container
    width: 300px
    text-align: widget-align
    position: relative
    clear: both

  .container:not(:first-child)
    margin-top: 20px

  .widget-title
    text-align: widget-align

  .widget-title, p
    font-size 10px
    text-transform uppercase
    font-weight bold

  .label
    float: right

  .bar-container
    width: 100%
    height: bar-height
    border-radius: bar-height
    float: widget-align
    clear: both
    background: rgba(#fff, .5)
    position: absolute
    margin-bottom: 5px

  .bar
    height: bar-height
    float: widget-align
    transition: width .2s ease-in-out

  .bar:first-child
    if widget-align == left
      border-radius: bar-height 0 0 bar-height
    else
      border-radius: 0 bar-height bar-height 0

  .bar:last-child
    if widget-align == right
      border-radius: bar-height 0 0 bar-height
    else
      border-radius: 0 bar-height bar-height 0

  .bar-used
    background: rgba(#c00, .5)
"""

renderInfo: (name, pctg) -> """
  <div class="container">
    <div class="widget-title">#{name} <span class="label">#{pctg}</span></div>
    <div class="bar-container">
      <div class="bar bar-used" style="width: #{pctg}"></div>
    </div>
  </div>
"""

update: (output, domEl) ->
  devices = output.split('\n')
  $(domEl).html ''

  for device, i in devices
    args = device.split(' ')
    if (args[1])
      args[1] = args[1..].join(' ')
      $(domEl).append @renderInfo(args...)

  $(domEl).append ''
