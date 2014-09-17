
var exec = require("cordova/exec");

var MyConfig = function () {
    this.name = "MyConfig";
};

var allActivityTypes = ["PostToFacebook", "PostToTwitter", "PostToWeibo", "Message", "Mail", "Print", "CopyToPasteboard", "AssignToContact", "SaveToCameraRoll", "AddToReadingList", "PostToFlickr", "PostToVimeo", "TencentWeibo", "AirDrop"];

MyConfig.prototype.config = function (message) {
    if (!message) {
        return;
    }
    if (typeof (message.activityTypes) === "undefined" || message.activityTypes === null || message.activityTypes.length === 0) {
        message.activityTypes = allActivityTypes;
    }
    message.activityTypes = message.activityTypes.join(",");
    exec(null, null, "MyConfig", "config", [message]);
};

module.exports = new MyConfig();