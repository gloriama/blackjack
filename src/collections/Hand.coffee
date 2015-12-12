class window.Hand extends Backbone.Collection
  model: Card

  initialize: (array, @deck, @isDealer) ->

  hit: ->
    @add(@deck.pop())
    @last()


  hasAce: -> @reduce (memo, card) ->
    memo or card.get('value') is 1
  , 0

  minScore: -> @reduce (score, card) ->
    score + if card.get 'revealed' then card.get 'value' else 0
  , 0

  scores: ->
    # The scores are an array of potential scores.
    # Usually, that array contains one element. That is the only score.
    # when there is an ace, it offers you two scores - the original score, and score + 10.
    [@minScore(), @minScore() + 10 * @hasAce()]

  stand: ->
    # console.log('got here')
    # trigger stand event
    @trigger('stand', @)

  isBust: -> @minScore() > 21
    # simply returns if minScore is > 21
  
  bestScore: ->
    # returns the max non-bust score
    # maxScore = -1
    # for score in scores
      # maxScore = score if score < 21
    # maxScore
    maxScore = -1
    for score in scores
      maxScore = score if score < 21
    maxScore