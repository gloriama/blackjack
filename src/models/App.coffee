# TODO: Refactor this model to use an internal Game Model instead
# of containing the game logic directly.
class window.App extends Backbone.Model
  # set app property gameOn to be true
  defaults:
    gameOn: true

  initialize: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()


    # listen to either hand on change,
      # if thishand.isBust, call this.endgame
    @get('playerHand').on 'add', =>
      console.log 'added a card to player'
      console.log @get('playerHand').minScore()
      if @get('playerHand').isBust()
        console.log('realized player bust')
        console.log @
        @endGame()

    @get('dealerHand').on 'add', =>
      console.log 'added a card to dealer'
      console.log @get('dealerHand')
      if @get('dealerHand').isBust() then @endGame()

    # listen to player stand event, 
      # this.dealerTurn
    @get('playerHand').on 'stand', => 
      console.log 'player hit stand'
      @dealerTurn()

    # listen to dealer stand event,
      # this.endGame
    @get('dealerHand').on 'stand', =>
      console.log 'dealer hit stand'
      @endGame()

  # dealerTurn method:
    # while (dealer.score < 16 and gameOn)
      # dealer.hit()
    # if gameOn, dealer.stand()
  dealerTurn: -> 
    @get('dealerHand').at(0).flip() # flip first card
    console.log @get('dealerHand').minScore(), @get('gameOn')
    while @get('dealerHand').minScore() < 16 and @get('gameOn')
      @get('dealerHand').hit()
    console.log 'calling dealer stand'
    @get('dealerHand').stand() if @get('gameOn')

  # endGame method:
    # for each card in dealer, make sure revealed is true (by calling flip)
    # determine winner and alert who it is
      # if player.isBust
        # alert dealer wins
      # else if dealer.isBust
        # alert player wins
      # else 
        # playerBestScore = player.bestScore()
        # dealerBestScore = dealer.bestScore()
        # if playerBestScore > dealerBestScore then alert playerWins
        # else if playerBestScore < dealerBestScore then alert dealerWins
        # else alert tie
    # set gameOn to false

  endGame: ->
    if !@get 'gameOn'
      console.log @get('gameOn')
      return

    console.log 'calling end game'
    # flip first card if it's not already revealed (via player bust)
    @get('dealerHand').at(0).flip() if not @get('dealerHand').at(0).get('revealed')
    # determine winner and alert message
    alertMessage = ''
    if @get('playerHand').isBust() then alertMessage = 'Dealer wins!'
    else if @get('dealerHand').isBust() then alertMessage = 'Player wins!'
    else
      playerBestScore = @get('playerHand').bestScore()
      dealerBestScore = @get('dealerHand').bestScore()
      if playerBestScore > dealerBestScore then alertMessage = 'Player wins!'
      else if playerBestScore < dealerBestScore then alertMessage = 'Dealer wins!'
      else alertMessage = 'Tied!'
    # call alert on the alert message
    # setTimeout -> alert alertMessage
    @trigger('endGame', alertMessage)

    @set 'gameOn', false
