React = require('react')
Reflux = require('reflux')
_ = require('lodash')
MD5 = require('md5')

# Directory
directoryActions = require('../actions/directoryActions.cjsx')
DirectoryForm = require('./directory.form.cjsx')

Directory = React.createClass
    getInitialState: () ->
        return data: @props.data 

    componentDidMount: () ->
        directoryActions.updateCount(@state.data.length)

    handleDirectorySubmit: (entry) ->

        data = @state.data

        # Increment and append Id (used for key)
        lastId = _.max data, (entry) ->
            return entry.id

        entry.id = lastId.id++
        entry.gravatar = ('https://www.gravatar.com/avatar/' + MD5(entry.email))

        # Push to data and set State
        data.push(entry)
        @setState(data: data)

        directoryActions.updateCount(data.length)


    render: ->
        <div>
            <div className="row">
                <div className="small-12 medium-8 large-8 columns">
                    <h5>Directory</h5>
                    <DirectoryList data={ @state.data }></DirectoryList>
                </div>
                <div className="small-12 medium-4 large-4 columns">
                    <h5>Add an Entry</h5>
                    <DirectoryForm onDirectorySubmit={ this.handleDirectorySubmit }></DirectoryForm>
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
                        </tr>
                    </thead>
                    <tbody>
                        { people}
                    </tbody>
                </table>


DirectoryItem = React.createClass
    render: ->
        <tr className="DirectoryItem">
            <td className="DirectoryItem__img"><img src={ @props.person.gravatar or 'https://www.gravatar.com/avatar/913c48bff2a8f2c291231e8fa159b55d' } width="48" /></td>
            <td className="DirectoryItem__name">{ @props.person.name }</td>
            <td className="DirectoryItem__position">{ @props.person.position }</td>
            <td className="DirectoryItem__email"><a href={ 'mailto:' + @props.person.email }>{ @props.person.email }</a></td>
        </tr>


module.exports = Directory