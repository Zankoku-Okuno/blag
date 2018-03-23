////////////////////////////////////
// Main
////////////////////////////////////

document.addEventListener('DOMContentLoaded', function () {
    var thePinout = pinout()
    var theResources = resources()
    thePinout.article_view.content = md.render(thePinout.article_view._elem.textContent)

})


////////////////////////////////////
// Pinout
////////////////////////////////////

function pinout() {
    var article_view = {
        _elem: document.querySelector("#here"),
        set content(text) {
            article_view._elem.innerHTML = md.render(text)
        },
    }
    
    return {
        article_view: article_view,
    }
}


////////////////////////////////////
// Requests
////////////////////////////////////

function resources() {
    function article(href) {
        return Http.request({
            method: "GET",
            uri: "/article/" + href,
            mimeType: "text/markdown; charset=utf-8",
        })
    }

    return {
        article: article
    }
}
