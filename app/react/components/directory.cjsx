React = require('react')
_ = require('lodash')

DirectoryForm = require('./directory.form.cjsx')

Directory = React.createClass
    getInitialState: () ->
        return { 
            data: @props.data 
        }

    handleDirectorySubmit: (entry) ->
        data = @state.data

        # Increment and append Id (used for key)
        lastId = _.max data, (entry) ->
            return entry.id

        entry.id = lastId.id++

        # Push to data and set State
        data.push(entry)
        @setState(data: data)


    render: ->
        <h1>My Reaction Directory</h1>
        <div className="Directory">
            <DirectoryList data={ @state.data }></DirectoryList>
            <DirectoryForm onDirectorySubmit={ this.handleDirectorySubmit }></DirectoryForm>
        </div>


DirectoryList = React.createClass
    render: ->
        people = @props.data.map (person) ->
            <DirectoryItem key={ person.id } person={ person }></DirectoryItem>

        return  <table className="DirectoryList">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Position</th>
                        </tr>
                    </thead>
                    <tbody>
                        { people}
                    </tbody>
                </table>


DirectoryItem = React.createClass
    render: ->
        <tr className="DirectoryItem">
            <td className="DirectoryItem__name">{ @props.person.name }</td>
            <td className="DirectoryItem__position">{ @props.person.position }</td>
        </tr>


module.exports = Directory