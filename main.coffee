class @Game
  FPS = 30
  _game = null
  _yt = null
  _judge = null
  _timing = [6.14,7.486,8.155,8.870,9.977,10.377,10.513,11.611,11.745,12.062,12.396,12.765,13.583,13.945,14.223,14.359,14.707,15.059,15.409,16.241,16.577,16.908,17.425,20.186,20.917,21.593,22.313,22.449,22.806,23.123,23.491,24.297,24.626,24.965,25.113,25.464,25.813,26.148,26.635,26.967,27.294,27.641,28.103,30.910,31.601,32.305,33.024,34.054,34.334,34.786,35.360,35.688,36.140,37.028,37.476,38.402,38.540,38.829,39.129,39.514,40.354,40.672,41.051,41.219,41.553,41.886,42.233,43.043,43.729,44.261,44.777,45.705,46.448,47.416,47.767,48.407,48.987,50.158,51.310,52.363,53.031,53.766,54.417,55.288,55.640,56.472,57.190,58.110,58.466,59.095,59.648,60.776, 61.993, 62.370, 63.072, 63.808, 64.493, 65.111, 65.514, 65.688, 65.991, 66.414, 67.192, 68.891, 69.209, 69.527, 69.918, 70.056, 70.413, 71.111, 71.744, 72.428, 72.861, 73.263, 73.605, 73.755, 74.099, 74.639, 74.941, 75.090, 75.426, 75.941, 76.472, 76.992]
  _index = 0
  _status = "stop"
  _endTime = 88

  constructor : (parms)->
    enchant()
    _game = new Core(800, 600)
    _game.fps = FPS
    _game.preload("icon.png", "shadow.png")
    _game.start()

    _game.onload = ->
      _game.rootScene.addEventListener "touchstart", (e)->
        if _yt.isReady()
          _game.rootScene.addEventListener "enterframe", _proccesRootSceneFrame
          _status = "playing"
          _yt.play()

      # youtube embeded
      video = new Entity()
      video._element = document.createElement('div')
      video.x = 500
      video.y = 300
      video._element.innerHTML = '<iframe src="https://www.youtube.com/embed/HNYkOJ-T63k?enablejsapi=1&controls=0&showinfo=0&autoplay=0&rel=0&vq=small"  width="300" height="200" frameborder="0" id="player"></iframe>'
      _game.rootScene.addChild(video)
      _yt = new Yt()

      _judge = new Label()
      _judge.color = 'rgba(0, 0, 0, 1)'
      _judge.font = "36px Arial"
      _judge.x = 100
      _judge.y = 100
      _game.rootScene.addChild(_judge)

      shadow = new Sprite(80, 80)
      shadow.image = _game.assets["shadow.png"]
      shadow.x = 100
      shadow.y = 380
      _game.rootScene.addChild(shadow)

  _isNoteGenerateTiming = ()->
    if _timing[_index]?
      if _yt.getCurrentTime() > _timing[_index] - 1
        return true
    return false

  _proccesRootSceneFrame = ()->
    if _status is "playing"
      if _isNoteGenerateTiming()
        _generateNote(_index)
        _index++
      
      if _yt.getCurrentTime() >= _endTime
        _yt.setVolume(_youtube.getVolume() - 1)

        if _yt.getVolume() <= 0
          _yt.stop()
          _status = "end"

  _generateNote = (number)->
    note = new Sprite(80, 80)
    note.image = _game.assets["icon.png"]
    note.number = number
    note.destinationY = 380
    note.x = 100
    note.y = -100
    note.timing = _timing[number]
    note.clear = false
    _game.rootScene.addChild(note)
    note.tl.setTimeBased()
    note.tl.moveY(380, (_timing[number] - _yt.getCurrentTime()) * 1000)
    note.addEventListener "enterframe", ->
      if _yt.getCurrentTime() > _timing[@number] + 1 then _game.rootScene.removeChild(@)

      # noteヒット時アクション
      if @clear
        @opacity -= 0.2
        @scale(@scaleX + 0.05, @scaleY + 0.05)

        if @opacity <= 0
          _game.rootScene.removeChild(@)
          if -0.2 <= @clearTime - _timing[@number] <= 0.2 then _judge.text = "COOL"
          else if -0.4 <= @clearTime - _timing[@number] <= 0.4 then _judge.text = "GOOD"
          else _judge.text = "BAD"

    note.addEventListener "touchstart", (e)->
      @clearTime = _yt.getCurrentTime()
      @clear = true


  document.addEventListener "keydown", (e)->
    if e.keyCode is 13
      if _status is "stop" and _yt.isReady()
        _game.rootScene.addEventListener "enterframe", _proccesRootSceneFrame
        _status = "playing"
        _yt.play()

class @Yt
  _player = null
  _isReady = false
  _state = null
  constructor : (parms)->
    tag = document.createElement('script')
    tag.src = 'https://www.youtube.com/iframe_api'
    firstScriptTag = document.getElementsByTagName('script')[0]
    firstScriptTag.parentNode.insertBefore(tag, firstScriptTag)

  play : ()->
    _player.playVideo()

  getCurrentTime : ()->
    _player.getCurrentTime()

  setVolume : (volume)->
    _player.setVolume(volume)

  getVolume : ()->
    _player.getVolume()    

  isReady : ()->
    _isReady

  onPlayerReady = ()->
    _isReady = true

  window.onYouTubeIframeAPIReady = ()->
    _player = new YT.Player 'player',
      events:
        'onReady': onPlayerReady

new Game()