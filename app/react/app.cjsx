React = require('react')

# Directory
Directory = require('./components/directory.cjsx')

# Count
countStore = require('./stores/countStore.cjsx')
Count = require('./components/count.cjsx')

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
React.render(<Count />, document.getElementById('count'))