cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [
    {
        "file": "plugins/com.rockmobile.myconfig/www/myconfig.js",
        "id": "com.rockmobile.myconfig.MyConfig",
        "clobbers": [
            "myconfig"
        ]
    }
];
module.exports.metadata = 
// TOP OF METADATA
{
    "com.rockmobile.myconfig": "0.0.2"
}
// BOTTOM OF METADATA
});