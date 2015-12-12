assert = chai.assert
expect = chai.expect
# sinon

describe 'hand', ->
  deck = null
  hand = null


  beforeEach ->
    deck = new Deck()
    hand = deck.dealPlayer()
    # create sinon spy for hand, 'trigger'
    sinon.spy hand, 'trigger'

  describe 'hit', ->
    it 'should give the last card from the deck', ->
      assert.strictEqual deck.length, 50
      assert.strictEqual deck.last(), hand.hit()
      assert.strictEqual deck.length, 49

  describe 'methods', ->
    it 'should have stand, isBust, and bestScore methods', ->
      (expect hand.stand).to.be.a('function')
      (expect hand.isBust).to.be.a('function')
      (expect hand.bestScore).to.be.a('function')

  describe 'stand', ->
    it 'should trigger a stand event', ->
      hand.stand()
      # expect that hand.trigger to have been called with 'stand', hand
      (expect hand.trigger).to.have.been.calledWith('stand', hand)

  describe 'isBust', ->
    it 'should return true if minScore is over 21', ->
      hand.hit()
      hand.hit()
      hand.hit()
      hand.hit()
      hand.hit() # (pretty much) ensure that hand will have a bust score
      (expect hand.isBust()).to.equal(true)
    it 'should return false if minScore is less than or equal to 21', ->
      (expect hand.isBust()).to.equal(false)


  describe 'bestScore', ->
    # case 1: non-bust hand with no ace, should return minScore
    #    2, 3
    #  --> bestScore should be minScore
    # case 2: hand with ace that has not bust, but whose maxScore should be the answer
    #    1, 2
    #  --> bestScore should be scores()[1]
    # case 3: hand with ace that has not bust, but whose minScore should be the answer
    #    1,9,3
    #          (refresh as necessary if we accidentally bust)
    # case 4: bust hand, should return -1
    it 'should return minScore for a non-bust hand with no ace', ->
      hand = new Hand([{rank: 2, suit: 0}, {rank: 3, suit: 0}])
      assert.strictEqual hand.bestScore(), hand.minScore()
    it 'should return a number larger than minScore for a non-bust hand with an ace', ->
      hand = new Hand([{rank: 1, suit: 0}, {rank: 2, suit: 0}])
      assert.strictEqual hand.bestScore() > hand.minScore(), true
    it 'should return minScore for a non-bust hand with an ace that would bust if counted as 11', ->
      hand = new Hand([{rank: 1, suit: 0}, {rank: 3, suit: 0}, {rank: 9, suit: 0}])
      assert.strictEqual hand.bestScore(), hand.minScore()
    it 'should return -1 for a bust hand', ->
      hand = new Hand([{rank: 9, suit: 0}, {rank: 4, suit: 0}, {rank: 9, suit: 0}])
      assert.strictEqual hand.bestScore(), -1
      hand = new Hand([{rank: 1, suit: 0}, {rank: 3, suit: 0}, {rank: 9, suit: 0}, {rank: 9, suit: 0}])
      assert.strictEqual hand.bestScore(), -1
