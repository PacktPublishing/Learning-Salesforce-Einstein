var server = require('express');
var jwt = require('jsonwebtoken');
var request = require('request');
var PORT = process.env.PORT || 5000;
var pvsUrl = process.env.EINSTEIN_VISION_URL;
var accountId = process.env.EINSTEIN_VISION_ACCOUNT_ID;
var privateKey = process.env.EINSTEIN_VISION_PRIVATE_KEY;

var app = server();

// Require Routes js
var routesHome = require('./routes/home');
// Serve static files
app.use(server.static(__dirname + '/public'));
// Set the Roue to Heroku Home
app.use('/home', routesHome);
//Set the View Engine to EJS
app.set('view engine', 'ejs');
//Set the Port 
app.set('port', (process.env.PORT || 5000));

app.get('/', function(req, res) {
    var reqUrl = pvsUrl+'v1/oauth2/token';
    console.log(reqUrl);
    // JWT payload
    var rsa_payload = {
        "sub": accountId,
        "aud": reqUrl
    }
    var rsa_options = {
        header: {
            "alg": "RS256",
            "typ": "JWT"
        },
        expiresIn: '1h'
    }

    // Sign the JWT payload
    var assertion = jwt.sign(
        rsa_payload,
        privateKey,
        rsa_options
    );

    //console.log(assertion);

    var options = {
        url: reqUrl,
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'accept': 'application/json'
        },
        body: 'grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion='+encodeURIComponent(assertion)
    }

    // Make the OAuth call to generate a token
    request.post(options, function(error, response, body) {
        if (!error && response.statusCode == 200) {
            var data = JSON.parse(body);
            console.log(data["access_token"]);
            app.locals.oauthtoken = data["access_token"];
            res.redirect('/home');
        }else{
            console.log("error",error);
            console.log(response.statusCode);
        }
    });

});

app.listen(app.get('port'), function() {
    console.log('Node app is running on port', app.get('port'));
});