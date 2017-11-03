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


////////////////////////////////////
// Main
////////////////////////////////////

document.addEventListener('DOMContentLoaded', function () {
    listeners(pinout(), resources())
})

function listeners(pinout, resources) {
    pinout.section_select._elem.addEventListener("change", function (e) {
        resources.blog_map.then(function (sections) {
            pinout.article_select.options = sections[e.target.value]
        })
    })

    pinout.article_select._elem.addEventListener("change", function (e) {
        var href = pinout.article_select.value
        if (href != null) {
            resources.article(href).then(function (request) {
                pinout.article_view.content = request.responseText
            })
        }
    })

    resources.blog_map.then(function (sections) {
        pinout.section_select.options = sections.getOwnPropertyNames()
    })
}


////////////////////////////////////
// Pinout
////////////////////////////////////

function pinout() {
    var section_select = {
        _elem: document.querySelector("#nav"),
        set options(section_names) {
            section_names.forEach(function (section_name) {
                var option = document.createElement("option")
                option.textContent = section_name
                section_select._elem.appendChild(option)
            })
            section_select._elem.selecedIndex = 0
            section_select._elem.dispatchEvent(new Event('change'))
        },
    }

    var article_select = {
        _elem: document.querySelector("#article"),
        set options(options) {
            article_select._elem.removeAllChildren()
            options.forEach(function (option) {
                var optionElem = document.createElement("option")
                optionElem.textContent = option.title
                optionElem.setAttribute("value", option.href)
                article_select._elem.appendChild(optionElem)
            })
            article_select._elem.selecedIndex = 0
            article_select._elem.dispatchEvent(new Event('change'))
        },
        get value() {
            var value = article_select._elem.value
            return (value === undefined || value === "") ? null : value
        },
    }
    
    var article_view = {
        _elem: document.querySelector("#here"),
        set content(text) {
            article_view._elem.innerHTML = md.render(text)
        },
    }
    
    return {
        section_select: section_select,
        article_select: article_select,
        article_view: article_view,
    }
}


////////////////////////////////////
// Requests
////////////////////////////////////

function resources() {
    var blog_map = Http.request({
            method: "GET",
            uri: "published.json",
            mimeType: "text/json; charset=utf-8",
        }).then(function (request) {
            return JSON.parse(request.responseText)
        }).catch(function (exn) {
            console.error(exn)
            throw exn
        })

    function article(href) {
        return Http.request({
            method: "GET",
            uri: href,
            mimeType: "text/plain; charset=utf-8",
        })
    }

    return {
        blog_map: blog_map,
        article: article
    }
}
