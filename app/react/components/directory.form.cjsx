React = require('react')

DirectoryForm = React.createClass
    handleSubmit: (e) ->
        e.preventDefault()       

        data =
            name: this.refs.name.getDOMNode().value.trim()
            position: this.refs.position.getDOMNode().value.trim()
            email: this.refs.email.getDOMNode().value.trim()

        if (data.name && data.position)
            this.props.onDirectorySubmit(data)

            # Reset field values after submit
            this.refs.name.getDOMNode().value = ''
            this.refs.position.getDOMNode().value = ''
            this.refs.email.getDOMNode().value = ''

    render: ->
        <form className="commentForm" onSubmit={ this.handleSubmit }>
            <input type="text" name="name" placeholder="Name" ref="name" />
            <input type="text" name="position" placeholder="Position" ref="position" />
            <input type="email" name="email" placeholder="E-mail" ref="email" />
            <input type="submit" value="Add" className="small button" />
        </form>

module.exports = DirectoryForm