React = require('react')
countStore = require('../stores/countStore.cjsx')

Count = React.createClass
    getInitialState: () ->
        count: 0

    componentDidMount: () ->
        countStore.listen (count) =>
            @setState({ count: count })

        return

    render: ->
        <span className="success round label">{ @state.count } entries</span>

module.exports = Count