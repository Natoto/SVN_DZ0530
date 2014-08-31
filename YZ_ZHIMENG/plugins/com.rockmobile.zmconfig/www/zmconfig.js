
var exec = require("cordova/exec");

var ZMConfig = function () {
    this.name = "ZMConfig";
};

var allActivityTypes = ["PostToFacebook", "PostToTwitter", "PostToWeibo", "Message", "Mail", "Print", "CopyToPasteboard", "AssignToContact", "SaveToCameraRoll", "AddToReadingList", "PostToFlickr", "PostToVimeo", "TencentWeibo", "AirDrop"];

ZMConfig.prototype.getZMConfigInfo = function (message) {
    if (!message) {
        return;
    }
    if (typeof (message.activityTypes) === "undefined" || message.activityTypes === null || message.activityTypes.length === 0) {
        message.activityTypes = allActivityTypes;
    }
    message.activityTypes = message.activityTypes.join(",");
    exec(null, null, "ZMConfig", "getZMConfigInfo", [message]);
};

module.exports = new ZMConfig();