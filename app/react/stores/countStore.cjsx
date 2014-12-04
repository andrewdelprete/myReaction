Reflux = require('reflux')

directoryActions = require('../actions/directoryActions.cjsx')

# Creating a Data Store - Listening to updateCount action
countStore = Reflux.createStore 
    init: () ->
        @listenTo(directoryActions.updateCount, @output)

    output: (count) ->
        # Triggers a change in this store which will alert any listeners
        @trigger(count)    


module.exports = countStore