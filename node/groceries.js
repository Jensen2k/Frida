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



exports.get = function(req, res) {
	if(db.connection) {
        var queryString = 'SELECT g.id, g.item_id, g.expiration, i.name from groceries as g INNER JOIN items as i on g.item_id = i.id';
        db.connection.query(queryString, function(err, rows, fields) {
            if (err) throw err;
            res.contentType('application/json');
            res.write(JSON.stringify(rows));
            res.end();
        });

	}
};

exports.remove = function(req, res) {

};