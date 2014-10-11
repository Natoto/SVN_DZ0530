var exec = require("cordova/exec");

var IDOApp = function () {
    this.name = "IDOApp";
};
 
IDOApp.prototype.exitApp = function (message) {
    message ="hello world";
    console.log(message);
    exec(null, null, "IDOApp", "exitApp", [message]);
};
module.exports = new IDOApp();