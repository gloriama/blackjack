class window.CardView extends Backbone.View
  className: 'card'
  tagName: 'img'

  # template: _.template '<%= rankName %> of <%= suitName %>'

  initialize: -> @render()

  render: ->
    @$el.children().detach()
    # @$el.html @template @model.attributes
    rankString = @model.get('rankName').toString().toLowerCase()
    suitString = @model.get('suitName').toLowerCase()

    cardURL = if @model.get('revealed')
      'img/cards/' + rankString + '-' + suitString + '.png'
    else
      'img/card-back.png'

    console.log (rankString + '-' + suitString + '.png')
    @$el.attr('src', cardURL)
    @$el.addClass 'covered' unless @model.get 'revealed'
    @$el.css('opacity', 0)