assert = chai.assert
expect = chai.expect

describe 'hand', ->
  deck = null
  hand = null


  beforeEach ->
    deck = new Deck()
    hand = deck.dealPlayer()

  describe 'hit', ->
    it 'should give the last card from the deck', ->
      assert.strictEqual deck.length, 50
      assert.strictEqual deck.last(), hand.hit()
      assert.strictEqual deck.length, 49

  describe 'methods', ->
    it 'should have stand, isBust, and maxScore methods', ->
      (expect hand.stand).to.be.a('function')
      (expect hand.isBust).to.be.a('function')
      (expect hand.maxScore).to.be.a('function')

  describe 'stand', ->
    it 'should trigger a stand event', ->
      hand.stand()