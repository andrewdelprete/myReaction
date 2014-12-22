Reflux = require('reflux')

directoryActions = require('../actions/directoryActions.cjsx')

# Creating a Data Store
directoryStore = Reflux.createStore 
    init: () ->
        @listenTo(directoryActions.addEntry, @output)

    output: (person) ->
        # Triggers a change in this store which will alert any listeners
        @trigger(person)    


module.exports = directoryStore