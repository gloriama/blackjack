assert = chai.assert
expect = chai.expect

describe 'app', ->
  app = null

  beforeEach ->
    app = new App()
    sinon.spy app, 'endGame'
    sinon.spy app, 'dealerTurn'
    sinon.spy app, 'trigger'
    sinon.spy app.get('dealerHand'), 'hit'
    sinon.spy app.get('dealerHand'), 'stand'

  # three adds:
  describe 'initialize', ->
    it 'should appropriately call endGame on playerHand add', ->
      app.get('playerHand').reset() # start by emptying the playerHand
      app.get('playerHand').add {rank: 5, suit: 0}
      (expect app.endGame).to.not.have.been.called.once
      app.get('playerHand').add {rank: 10, suit: 0}
      (expect app.endGame).to.not.have.been.called.once
      app.get('playerHand').add {rank: 9, suit: 1}
      (expect app.endGame).to.have.been.called.once
    it 'should appropriately call endGame on dealerHand add', ->
      app.get('dealerHand').reset() # start by emptying the dealerHand
      app.get('dealerHand').add {rank: 5, suit: 0}
      (expect app.endGame).to.not.have.been.called.once
      app.get('dealerHand').add {rank: 10, suit: 0}
      (expect app.endGame).to.not.have.been.called.once
      app.get('dealerHand').add {rank: 9, suit: 1}
      (expect app.endGame).to.have.been.called.once
    it 'should call dealerTurn on playerHand stand', ->
      app.get('playerHand').stand()
      (expect app.dealerTurn).to.have.been.called.once
    it 'should call endGame on dealerHand stand', ->
      app.get('dealerHand').stand()
      (expect app.endGame).to.have.been.called.once

  describe 'dealerTurn', ->
    it 'should flip dealer\'s first card', ->
      app.dealerTurn()
      assert.strictEqual app.get('dealerHand').at(0).get('revealed'), true
    it 'should call dealer hit until minScore is 16 or greater', ->
      app.get('dealerHand').reset()
      app.get('dealerHand').add({rank: 5, suit: 0})
      app.dealerTurn()
      (expect app.get('dealerHand').hit).to.have.been.called.twice # (at least twice)
      assert.strictEqual app.get('dealerHand').minScore() >= 16, true
    it 'should call dealer stand when dealer has not bust', ->
      app.get('dealerHand').reset([{rank: 6, suit: 0}, {rank: 10, suit: 0}])
      app.dealerTurn()
      (expect app.get('dealerHand').stand).to.have.been.called.once
    it 'should not call dealer stand when dealer has bust', ->
      app.get('dealerHand').reset([{rank: 6, suit: 0}, {rank: 10, suit: 0}])
      app.get('dealerHand').add({rank: 6, suit: 1})
      (expect app.get('dealerHand').stand).to.not.have.been.called.once

  describe 'endGame', ->
    it 'should not trigger endGame event if gameOn is false', ->
      app.set 'gameOn', false
      (expect app.trigger).to.not.have.been.calledWith('endGame')

    it 'should be able to see dealer\'s first card if player has bust', ->
      app.get('playerHand').reset([{rank: 6, suit: 0}, {rank: 10, suit: 0}])
      app.get('playerHand').add {rank: 6, suit: 1}
      assert.strictEqual app.get('dealerHand').at(0).get('revealed'), true

    it 'should be able to see dealer\'s first card if player has not bust', ->
      app.endGame()
      assert.strictEqual app.get('dealerHand').at(0).get('revealed'), true
      
    it 'should alert player win correctly if dealer does not bust', ->
      # neither player busts and player has higher
      app.get('playerHand').reset([{rank: 8, suit: 0}, {rank: 10, suit: 0}])
      app.get('dealerHand').reset([{rank: 6, suit: 0}, {rank: 10, suit: 0}])
      app.endGame()
      (expect app.trigger).to.have.been.calledWith 'endGame', 'Player wins!'

    it 'should alert player win correctly if dealer busts', ->
      # neither player busts and player has higher
      app.get('playerHand').reset([{rank: 8, suit: 0}, {rank: 10, suit: 0}])
      app.get('dealerHand').reset([{rank: 6, suit: 0}, {rank: 10, suit: 0}])
      app.get('dealerHand').add {rank: 6, suit: 1}
      (expect app.trigger).to.have.been.calledWith 'endGame', 'Player wins!'

    it 'should alert dealer win correctly if player does not bust', ->
      app.get('playerHand').reset([{rank: 6, suit: 0}, {rank: 10, suit: 0}])
      app.get('dealerHand').reset([{rank: 8, suit: 0}, {rank: 10, suit: 0}])
      app.endGame()
      (expect app.trigger).to.have.been.calledWith 'endGame', 'Dealer wins!'

    it 'should alert dealer win correctly if player busts', ->
      app.get('playerHand').reset([{rank: 8, suit: 0}, {rank: 10, suit: 0}])
      app.get('playerHand').add {rank: 6, suit: 1}
      (expect app.trigger).to.have.been.calledWith 'endGame', 'Dealer wins!'

    it 'should alert tie correctly', ->
      app.get('dealerHand').reset([{rank: 9, suit: 0}, {rank: 9, suit: 1}])
      app.get('playerHand').reset([{rank: 9, suit: 2}, {rank: 9, suit: 3}])
      app.endGame()
      (expect app.trigger).to.have.been.calledWith 'endGame', 'Tied!'


















