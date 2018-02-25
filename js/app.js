var express = require('express')
var request = require('request')
var net = require('net')

var app = express()

var server = require('http').createServer(app);  
var io = require('socket.io')(server);

app.use(express.static(__dirname + '/public'))

io.on('connection', function(sock){
    console.log('A user connected!')
    var client

    sock.on('join', (data) => {
        console.log(data)

        var param = data
        client = new net.Socket()
        client.connect(param.port, param.sock, function() {
            console.log('CONNECTED TO: ' + param.sock + ':' + param.port)
        })
        client.on('data', (data) => {
            console.log('DATA: ' + data)
            sock.emit('message', JSON.parse(data))
        })
        client.on('close', function() {
            console.log('Connection closed')
        })
    })
    sock.on('update', (data) => {
        console.log(data)
        client.write(JSON.stringify(data))
    })
})

app.get('/fake_data/init.json', (req, res) => {
    res.sendFile('fake_data/init.json')
})

app.get('/fake_data/cat.json', (req, res) => {
    res.sendFile('fake_data/cat.json')
})

server.listen(3000, function(){
    console.log('listening on *:3000');
  });