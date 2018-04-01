// FIXME this should be managed by whatever js compiler I use

////////////////////////////////////
// Polyfills
////////////////////////////////////


////////////////////////////////////
// Extensions
////////////////////////////////////

window.Http = {
    request: function(options) {
        return new Promise(function (resolve, reject) {
            if (options.async === undefined) { options.async = true }

            var req = new XMLHttpRequest()
            req.open(options.method, options.uri, options.async)
            req.addEventListener("load", function() {
                resolve(req)
            })
            if (options.mimeType !== undefined) {
                req.overrideMimeType(options.mimeType)
            }
            req.send(null)
        })
    }
}

if (Object.prototype.getOwnPropertyNames === undefined) {
    Object.prototype.getOwnPropertyNames = function () {
        return Object.getOwnPropertyNames(this)
    }
}

if (HTMLElement.removeAllChildren === undefined) {
    HTMLElement.prototype.removeAllChildren = function () {
        while (this.hasChildNodes()) { this.removeChild(this.lastChild) }
    }
}

Promise.pure = function (x) {
    return new Promise(function (resolve, _) { resolve(x) })
}
