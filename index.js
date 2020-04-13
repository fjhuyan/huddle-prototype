var mysql = require('mysql');
const http = require('http');

const hostname = '127.0.0.1';
const port = 3000;

var con = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "password",
  database: "Huddle"
});

con.connect(function(err) {
  if (err) throw err;
  console.log("Connected to Database!");
});

http.createServer((req, res) => {
  if(req.method === 'GET' && req.url === '/GET_EVENTS') {
    con.query("SELECT * FROM Events", function (err, result) {
      if (err) throw err;
      res.end(JSON.stringify(result));
    });
  }else if (req.method === 'POST' && req.url === '/ADD_USER') {
    let body = [];
    req.on('data', (chunk) => {
      body.push(chunk);
    }).on('end', () => {
      body = Buffer.concat(body).toString();
    });
    body = JSON.parse(body);
    con.query("INSERT INTO Events VALUES(" + body.eid + ", " + body.eventname + ", " + body.x + ", " + body.y + ")",
    function (err, result) {
      if (err) res.statusCode(400);
      res.statusCode(200);
      res.end();
    });
  }
}).listen(port);

