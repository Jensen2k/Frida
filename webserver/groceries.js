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

exports.addByEan = function(req, res, callback) {
	if(db.connection)
    {
        var ean = req.body.ean;
        console.log(req.body);

	    // If not
	   db.connection.query('SELECT * from items WHERE ean = ? LIMIT 1', [ean], function(err, rows, fields) {
	       if(err) throw err;

	       var product = {};
	       var prod = rows[0];
	       if(rows.length == 0) {
	       		res.status(404);
	       		res.contentType('application/json');
		    	res.write(JSON.stringify({ "error": "Item with barcode not found" }));
		    	res.end();
		    	return;
	       }

	       product.name = prod.name;
	       product.producer = prod.producer;
	       product.defaultExpire = prod.defaultExpire;

	       db.connection.query('INSERT INTO groceries (fridge_id, item_id) VALUES (1,?)', [prod.id], function(err, row, fields) {
		       if(err) throw err;
		       product.id = row.insertId;
		       res.contentType('application/json');
		       res.write(JSON.stringify({ "success": "Product added" }));
		       res.end();
		       callback(product);
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
	console.log("removing");
	var prod_id = req.params.id;
	console.log(req.params);
    if(db.connection) {
        var queryString = 'DELETE FROM groceries WHERE id = ?';
        db.connection.query(queryString, [prod_id], function(err, rows, fields) {
        	console.log("removed!");
        	console.log("rows: ");
            if (err) throw err;
            res.contentType('application/json');
            res.write(JSON.stringify({"status": "success"}));
            res.end();
              io.sockets.emit("groceries:update");

        });
    }
};