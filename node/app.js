var express = require('express'),
    model   = require('./models'),
    http    = require('http'),
    path    = require('path'),
    fs      = require('fs');

var app = express();

var allowCrossDomain = function(req, res, next) {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE, OPTIONS');
    res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');

    next();
}

app.configure(function(){
    app.set('port', 3000);
    app.use(express.logger('dev'));
    app.use(express.bodyParser());
    app.use(allowCrossDomain);
    app.use(express.methodOverride());
    app.use(app.router);
    app.use(express.static(path.join(__dirname, 'public')));
});



io = require('socket.io');
var h = http.createServer(app).listen(app.get('port'), "127.0.0.1", function(){
    console.log("Express server listening on port " + app.get('port'));
});

io = io.listen(h);
var s;

io.sockets.on('connection', function (socket) {
    console.log("Got connection");
    s = socket;
});


app.configure('development', function(){
    app.use(express.errorHandler());
});

// Fridges
app.get('/fridges', model.fridges.get);
app.get('/fridges/:id', model.fridges.one);
app.get('/fridges/name/:fridgeName', model.fridges.titleName);
app.post('/fridges/:id/temp', model.fridges.setTemp);


// Items
app.post('/items', model.items.add);
app.get('/items/:id', model.items.one);
app.get('/items/ean/:ean', model.items.ean);
app.del('/items/:id', model.items.remove);

app.get('/sebastian', function(req, res) {
    console.log("Hello! Someone tried the seb route");
});

app.get('/test', function(req, res) {
    s.send("test");

        s.broadcast.emit("hello2");
                s.broadcast.send("hello3");


  res.write("Hello, world");
  res.end();
});


/*
// Devices
app.put('/devices', model.devices.add);
app.get('/devices/:id', model.devices.get);
app.delete('/devices/:id', model.devices.delete);

// Groceries
*/
app.post('/groceries', function(req, res) {
  model.groceries.add(req, res);
  s.emit("groceries:update");
});

app.get('/groceries', model.groceries.get);
app.del('/groceries/:id', model.groceries.remove);






