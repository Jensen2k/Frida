var connection = require('./db.js');

exports.test = function(req, res) {
    if (connection) {
        connection.query('select * from users order by name', function(err, rows, fields) {
            console.log(rows);
        });
    }
};


