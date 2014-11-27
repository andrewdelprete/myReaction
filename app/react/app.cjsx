React = require('react')
Directory = require('./components/directory.cjsx')

data = [
    {
        id: 1
        name: "John Doe"
        position: "Front-end Developer"
        email: 'fake-email@address.com'
    }
    {
        id: 2
        name: "Jane Doe"
        position: "Product Manager"
        email: 'fake-email2@address.com'
    }
]

React.render(<Directory data={ data } />, document.getElementById('directory'))