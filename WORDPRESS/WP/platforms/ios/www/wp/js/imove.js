// 封装动画
(function ($) {
    //Slide方式，扩展jquery,zepto
    var isAndroid = (/android/gi).test(navigator.appVersion),
        isIDevice = (/iphone|ipad/gi).test(navigator.appVersion),
        isPlaybook = (/playbook/gi).test(navigator.appVersion),
        has3d = 'WebKitCSSMatrix' in window && 'm11' in new WebKitCSSMatrix(),
        hasTouch = 'ontouchstart' in window,
        hasTransitionEnd = isAndroid || isIDevice || isPlaybook || (window.navigator.userAgent.indexOf("Chrome") !== -1);
    // 辅助
    var trnOpen = 'translate' + (has3d ? '3d(' : '('),
        trnClose = has3d ? ',0)' : ')';

    var get_trans_pos = function (elem) {
        var matrix = getComputedStyle(elem, null)['webkit' + 'Transform']
            .replace(/[^0-9-.,]/g, '').split(',');
        return {'x':matrix[4] * 1 || 0, 'y':matrix[5] * 1 || 0 }
    };

    $.fn.imove = function (stopX, stopY, duration, cb) {
        var that = this, elem = that[0], matrix, origX, origY;
        if (hasTransitionEnd) {
            var orig_pos = get_trans_pos(elem);
            elem.style['webkittransitionTimingFunction'] = 'ease-in-out';
            elem.style['webkitTransitionProperty'] = '-webkit-transform';
            $(elem).css({
                "-webkit-transition-timing-function":"ease-in-out"
//                "position":"absolute"
            });
            //$(elem).css( "-webkit-transition-property",'-webkit-transform' );
            elem.style['webkitTransitionDuration'] = duration + 'ms';
            elem.style['webkitTransform'] = trnOpen +
                stopX + 'px,' +
                stopY + 'px' + trnClose;
            if (!cb) {
                return;
            }
            var f = function () {
                cb();
                elem.removeEventListener('webkitTransitionEnd', f);
            };

            elem.addEventListener('webkitTransitionEnd', f, false);
        }
        else {
            console.log('trans not support');
        }
		
		
        return that;
    };
})(Zepto);