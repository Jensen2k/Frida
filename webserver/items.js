var db = require('./db.js');

exports.add = function(req, res) {
    if(db.connection)
    {
        console.log(req.body);
        var name = req.body.name;
        var ean = req.body.ean;

        // Check if it excits
        db.connection.query('SELECT * from items WHERE ean = ?', [ean], function(err, rows, fields) {
            if(err) throw err;
            if(rows.length > 0) {
                res.contentType('application/json');
                res.write(JSON.stringify({ "error": "Product already excist" }));
                res.end();
                return;
            } else {
                // If not
                db.connection.query('INSERT INTO items (name, ean) VALUES (?,?)', [name,ean], function(err, rows, fields) {
                    if(err) throw err;
                    res.contentType('application/json');
                    res.write(JSON.stringify({ "success": "Product added" }));
                    res.end();
                });
            }
        });
    }
};

exports.one = function(req, res) {
    var id = req.params.id;
    if(db.connection) {
        var queryString = 'select * from items where id = ?';
        db.connection.query(queryString, [id], function(err, rows, fields) {
            if (err) throw err;
            res.contentType('application/json');
            res.write(JSON.stringify(rows));
            res.end();
        });
    }
};

exports.ean = function(req, res) {
    var ean = req.params.ean;
    console.log(ean);
    if(db.connection) {
        var queryString = 'select * from items where ean = ?';
        db.connection.query(queryString, [ean], function(err, rows, fields) {
            if (err) throw err;
            res.contentType('application/json');
            res.write(JSON.stringify(rows));
            res.end();
        });
    }
};

exports.remove = function(req, res) {
    var id = req.params.id;
    if(db.connection) {
        var queryString = 'DELETE FROM items where id = ?';
        db.connection.query(queryString, [id], function(err, rows, fields) {
            console.log(err);
            if (err) throw err;
            res.contentType('application/json');
            res.write({"status": "success"}.stringify);
            res.end();
        });
    }
};