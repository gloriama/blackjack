# TODO: Refactor this model to use an internal Game Model instead
# of containing the game logic directly.
class window.App extends Backbone.Model
  initialize: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()

    # set app property gameOn to be true;

    # listen to either hand on change,
      # if thishand.isBust, call this.endgame

    # listen to player stand event, 
      # this.dealerTurn

    # listen to dealer stand event,
      # this.endGame

    # dealerTurn method:
      # while (dealer.score < 16 and gameOn)
        # dealer.hit()
      # if gameOn, dealer.stand()

    # endGame method:
      # for each card in dealer, make sure revealed is true (by calling flip)
      # determine winner
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
      # alert to announce the winner