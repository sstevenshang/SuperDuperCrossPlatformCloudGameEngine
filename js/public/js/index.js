var canvas, components = [], dict = {}
var socket

/**
 * Main entry.
 */
function main() {
    canvas = document.getElementById('canvas')
    ctx = canvas.getContext('2d')

    document.body.addEventListener('click', (evt) => {

        console.log('Clicking on (%d ,%d)', evt.offsetX, evt.offsetY)
        components.forEach((elem) => {
            if (elem.isClicked(evt.offsetX, evt.offsetY)) {
                console.log(elem.id, "is clicked!")
                var data = {
                    'class': 'COMPONENT',
                    'target': elem.id,
                    'operation' : 'UPDATE',
                    'ax_data' :{
                        "action": "click"
                    }
                }
                socket.emit('update', data)
            }
        })
    })

    init()
    loop()
}

/**
 * Main loop for drawing and update.
 */
function loop() {
    draw()
    // keep track and send reponse to server
    window.requestAnimationFrame(loop, canvas);
}

/**
 * Draw function. Call draw on each components.
 */
function draw() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    components.forEach((elem) => {
        elem.draw()
    })
}

/**
 * Conenct with server to fetch canvas, initial data.
 */
function init() {
    connectTo('35.196.154.247', 8081, (data) => {
        data.forEach((d) => {
            processRes(d)
        })
    })
}

/**
 * Open up a socket to the server the first time to read initial commands.
 * Keep the socket open.
 * @param {URL} url The URL to read data from.
 * @param {function} cb Callback function to process the data.
 */
function connectTo(sock, port, cb) {
    var data = {'sock' : sock, 'port' : port}
    socket = io()
    socket.on('connect', () => {
        socket.emit('join', data)
    })
    socket.on('message', function(message) {
        console.log(message)
        cb(message)
    })
}

/**
 * Testing purpose. Read requset file from local. 
 * @param {String} fileName The file name to read Json data from.
 * @param {function} cb Callback function after the file is read in.
 */
function readFile(fileName, cb) {
    var data = '';
    var xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange = function(){
        if(xmlhttp.status == 200 && xmlhttp.readyState == 4){
            data = xmlhttp.responseText;
            cb(data)
        }
    };
    xmlhttp.open("GET", fileName, true);
    xmlhttp.send();
}

/**
 * Process the command.
 * @param {JSON} data Command.
 */
function processRes(data) {
    if (data.class == 'CANVAS') {
        canvas.width = data.ax_data.size[0]
        canvas.height = data.ax_data.size[1]
        // ctx.transform(1, 0, 0, -1, 0, canvas.height)
    }
    if (data.class == 'COMPONENT') {
        if (data.operation == 'INIT') {
            addComp(data)
        }
        if (data.operation == 'UPDATE') {
            updateComp(data)
        }
    }
}

/**
 * An INIT command.
 * @param {JSON} data Command.
 */
function addComp(data) {
    ax = data.ax_data
    if (ax.shape == 'circle') {
        circle = new Circle(data.target, ax.loc, ax.size, ax.texture, ctx)
        dict[data.target] = circle
        components.push(circle)
    }
    console.log("A new component %s is created:", data.target, components)
}

/**
 * And UPDATE command.
 * @param {JSON} data Command.
 */
function updateComp(data) {
    comp = dict[data.target]
    ax = data.ax_data
    if (ax.action == 'change_texture') {
        console.log(data.target, 'color change', ax.texture)
        comp.color = ax.texture
    }
    if (ax.action == 'change_size') {
        console.log(data.target, 'size change', ax.factor)
        comp.resize(ax.factor)
    }
}

window.onload = main()