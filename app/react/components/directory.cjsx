React = require('react')
Reflux = require('reflux')
_ = require('lodash')
MD5 = require('md5')

# Directory
directoryActions = require('../actions/directoryActions.cjsx')
DirectoryForm = require('./directory.form.cjsx')

Directory = React.createClass
    mixins: [Reflux.ListenerMixin]

    getInitialState: () ->
        return data: @props.data 

    componentDidMount: () ->
        directoryActions.updateCount(@state.data.length)
        @listenTo(directoryActions.trashEntry, (person) -> @_handleTrashEntry(person))
        @listenTo(directoryActions.addEntry, (person) -> @_handleAddEntry(person))

        return

    _handleTrashEntry: (person) ->
        data = @state.data

        # Remove Person
        _.remove(data, person)

        # Set State to render changes
        @setState(data: data)

        # Update Count
        directoryActions.updateCount(data.length)


    _handleAddEntry: (person) ->

        data = @state.data

        # Increment and append Id (used for key)
        lastId = _.max data, (person) ->
            return person.id

        person.id = lastId.id++
        person.gravatar = ('https://www.gravatar.com/avatar/' + MD5(person.email))

        # Push to data and set State
        data.push(person)
        @setState(data: data)

        directoryActions.updateCount(data.length)

    render: ->
        <div>
            <div className="row">
                <div className="medium-8 columns">
                    <h5>Directory</h5>
                    <DirectoryList data={ @state.data }></DirectoryList>
                </div>
                <div className="medium-4 columns">
                    <h5>Add an Entry</h5>
                    <DirectoryForm></DirectoryForm>
                </div>
            </div>
        </div>


DirectoryList = React.createClass
    render: ->
        people = @props.data.map (person) ->
            <DirectoryItem key={ person.id } person={ person }></DirectoryItem>

        return  <table className="DirectoryList">
                    <thead>
                        <tr>
                            <th></th>
                            <th>Name</th>
                            <th>Position</th>
                            <th>Email</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        { people}
                    </tbody>
                </table>


DirectoryItem = React.createClass
    _handleTrashEntry: () ->
        directoryActions.trashEntry(@props.person)


    render: ->
        <tr className="DirectoryItem">
            <td className="DirectoryItem__img"><img src={ @props.person.gravatar or 'https://www.gravatar.com/avatar/913c48bff2a8f2c291231e8fa159b55d' } width="48" /></td>
            <td className="DirectoryItem__name">{ @props.person.name }</td>
            <td className="DirectoryItem__position">{ @props.person.position }</td>
            <td className="DirectoryItem__email"><a href={ 'mailto:' + @props.person.email }>{ @props.person.email }</a></td>
            <td className="DirectoryItem__action"><a className="trash" onClick={ @_handleTrashEntry }></a></td>
        </tr>


module.exports = Directory