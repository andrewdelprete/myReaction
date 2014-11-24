React = require('react')
Directory = require('./components/directory.cjsx')

data = [
    {
        id: 1
        name: "John Doe"
        position: "Front-end Developer"
    }
    {
        id: 2
        name: "Jane Doe"
        position: "Product Manager"
    }
]

React.render(<Directory data={ data } />, document.getElementById('directory'))