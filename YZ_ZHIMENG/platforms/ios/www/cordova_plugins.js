cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [
    {
        "file": "plugins/uk.co.ilee.socialmessage/www/socialmessage.js",
        "id": "uk.co.ilee.socialmessage.SocialMessage",
        "clobbers": [
            "socialmessage"
        ]
    },
    {
        "file": "plugins/com.rockmobile.zmconfig/www/zmconfig.js",
        "id": "com.rockmobile.zmconfig.ZMConfig",
        "clobbers": [
            "zmconfig"
        ]
    }
];
module.exports.metadata = 
// TOP OF METADATA
{
    "uk.co.ilee.socialmessage": "0.2.6",
    "com.rockmobile.zmconfig": "0.0.1"
}
// BOTTOM OF METADATA
});