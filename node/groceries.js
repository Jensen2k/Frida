var db = require('./db.js');

exports.add = function(req, res) {
    if(db.connection)
    {
    	console.log(req.body);
        var item_id = req.body.item_id;

        // Check if it excits

	    // If not
	   db.connection.query('INSERT INTO groceries (fridge_id, item_id) VALUES (1,?)', [item_id], function(err, rows, fields) {
	       if(err) throw err;
	       res.contentType('application/json');
	       res.write(JSON.stringify({ "success": "Product added" }));
	       res.end();
	   });
    }
};

exports.addByEan = function(req, res) {
	if(db.connection)
    {
        var ean = req.body.ean;
        console.log(req.body);
	    // If not
	   db.connection.query('SELECT * from items WHERE ean = ? LIMIT 1', [ean], function(err, rows, fields) {
	       if(err) throw err;
	       console.log(rows);


	       if(rows.length == 0) {

	       		res.status(404);
	       		res.contentType('application/json');
		    	res.write(JSON.stringify({ "error": "Item with barcode not found" }));
		    	res.end();
		    	return;
	       }
	       var prod = rows[0];


	       db.connection.query('INSERT INTO groceries (fridge_id, item_id) VALUES (1,?)', [prod.id], function(err, rows, fields) {
		       if(err) throw err;
		       res.contentType('application/json');
		       res.write(JSON.stringify({ "success": "Product added" }));
		       res.end();
		   });
	   });
    }
};


exports.get = function(req, res) {
	if(db.connection) {
        var queryString = 'SELECT g.id, g.item_id, g.expiration, i.name, i.producer from groceries as g INNER JOIN items as i on g.item_id = i.id ORDER BY g.id DESC';
        db.connection.query(queryString, function(err, rows, fields) {
            if (err) throw err;
            res.contentType('application/json');
            res.write(JSON.stringify({"groceries" : rows }));
            res.end();
        });

	}
};

exports.remove = function(req, res) {
	var id = req.params.id;
    if(db.connection) {
        var queryString = 'DELETE FROM groceries where id = ?';
        db.connection.query(queryString, [id], function(err, rows, fields) {
            console.log(err);
            if (err) throw err;
            res.contentType('application/json');
            res.write({"status": "success"}.stringify);
            res.end();
        });
    }



};