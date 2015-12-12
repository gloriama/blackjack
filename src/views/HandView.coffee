class window.HandView extends Backbone.View
  className: 'hand'

  template: _.template '<h2><% if(isDealer){ %>Dealer<% }else{ %>You<% } %> (<span class="score"></span>)</h2>'

  initialize: ->
    @collection.on 'add remove', (card) => @renderCard(card)
    @collection.on 'change', => @render()
    @render()

  render: ->
    @$el.children().detach()
    @$el.html @template @collection
    @$el.append @collection.map (card) ->
      (new CardView(model: card).$el).css('opacity': 1)
    @$('.score').text @collection.scores()[0]

  renderCard: (card) ->
    console.log 'rendering card'
    @$el.append(new CardView(model: card).$el.animate('opacity': 1))

    @$('.score').text @collection.scores()[0]