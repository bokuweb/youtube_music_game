class @Game
  YOUTUBE_ID = 'HNYkOJ-T63k'
  _game = null
  _yt = null
  _judge = null
  _timing = [6.14,7.486,8.155,9.977,10.377,11.611,12.062,12.765,13.583,13.945,14.223,14.707,15.059,16.241,16.577,17.425,20.186,20.917,21.593,22.313,22.449,23.123,24.297,24.965,25.113,25.464,26.148,26.635,27.294,28.103,30.910,31.601,32.305,33.024,34.054,34.786,35.360,36.140,37.028,38.402,38.829,39.129,40.354,41.051,41.553,42.233,43.043,43.729,44.261,45.705,46.448,47.416,48.407,50.158,51.310,52.363,53.031,54.417,55.288,55.640,56.472,57.190,58.110,59.095,59.648,60.776, 61.993, 62.370, 63.072, 63.808, 64.493, 65.111, 65.688, 66.414, 67.192, 68.891, 69.209, 69.918, 70.056, 71.111, 71.744, 72.428, 72.861, 73.263, 73.755, 74.099, 74.639, 75.090, 75.426, 75.941, 76.472, 76.992]
  _timingIndex = 0
  _status = "stop"
  _endTime = 80

  constructor : (parms)->
    enchant()
    _game = new Core(800, 600)
    _game.fps = 30
    _game.preload("icon.png", "shadow.png")
    _game.start()
    _game.onload = ->
      _game.rootScene.addEventListener "touchstart", (e)->
        if _yt.isReady()
          _game.rootScene.addEventListener "enterframe", _proccesRootSceneFrame
          _status = "playing"
          _yt.play()
      video = new Entity()
      video._element = document.createElement('div')
      video.x = 500
      video.y = 300
      video._element.innerHTML = '<iframe src="https://www.youtube.com/embed/'+YOUTUBE_ID+'?enablejsapi=1&controls=0&showinfo=0&autoplay=0&rel=0&vq=small"  width="300" height="200" frameborder="0" id="player"></iframe>'
      _game.rootScene.addChild(video)
      _yt = new Yt()
      _judge = new Label()
      _judge.font = "36px Arial"
      _judge.x = 100
      _judge.y = 100
      _game.rootScene.addChild(_judge)
      shadow = new Sprite(80, 80)
      shadow.image = _game.assets["shadow.png"]
      shadow.x = 100
      shadow.y = 380
      _game.rootScene.addChild(shadow)

  _isNoteGenerateTiming = ->
    if _timing[_timingIndex]?
      if _yt.getCurrentTime() > _timing[_timingIndex] - 1
        return true
    return false
  _generateNote = (number)->
    note = new Sprite(80, 80)
    note.image = _game.assets["icon.png"]
    note.number = number
    note.x = 100
    note.y = -100
    note.timing = _timing[number]
    _game.rootScene.addChild(note)
    note.tl.setTimeBased()
    note.tl.moveY(380, (_timing[number] - _yt.getCurrentTime()) * 1000)
    note.addEventListener "touchstart", (e)->
      @clearTime = _yt.getCurrentTime()
      @clear = true
    note.addEventListener "enterframe", ->
      if _yt.getCurrentTime() > _timing[@number] + 1 then _game.rootScene.removeChild(@)
      if @clear
        @opacity -= 0.2
        @scale(@scaleX + 0.05, @scaleY + 0.05)
        if @opacity <= 0
          _game.rootScene.removeChild(@)
          if -0.2 <= @clearTime - _timing[@number] <= 0.2 then _judge.text = "COOL"
          else if -0.4 <= @clearTime - _timing[@number] <= 0.4 then _judge.text = "GOOD"
          else _judge.text = "BAD"
  _proccesRootSceneFrame = ->
    if _status is "playing"
      if _isNoteGenerateTiming()
        _generateNote(_timingIndex)
        _timingIndex++
      if _yt.getCurrentTime() >= _endTime
        _yt.setVolume(_youtube.getVolume() - 1)
        if _yt.getVolume() <= 0
          _yt.stop()
          _status = "end"

class @Yt
  _player = null
  _isReady = false
  _state = null
  constructor : (parms)->
    tag = document.createElement('script')
    tag.src = 'https://www.youtube.com/iframe_api'
    firstScriptTag = document.getElementsByTagName('script')[0]
    firstScriptTag.parentNode.insertBefore(tag, firstScriptTag)
  play : -> _player.playVideo()
  getCurrentTime : -> _player.getCurrentTime()
  setVolume : (volume)-> _player.setVolume(volume)
  getVolume : -> _player.getVolume()
  isReady : -> _isReady
  onPlayerReady = -> _isReady = true
  window.onYouTubeIframeAPIReady = ->
    _player = new YT.Player 'player',
      events:
        'onReady': onPlayerReady

new Game()