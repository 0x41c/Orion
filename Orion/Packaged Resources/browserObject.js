// NOTE: this is extremely cude, and honestly not exactly how I usually would do it...
// Ended up having to rush this


const browserHandler = {
    get: function(obj, prop) {
        return obj[prop];
    },
    set: function(obj, prop, value) {
        // TODO: handle error for setting window object
    }
}


const swapHandler = {
    get: function(obj, prop) {
        return obj[prop] // TODO: Limit access to swap
    },
    set: function (obj, prop, value) {
        obj[prop] = value
    }
}


const browser = new Proxy({
    topSites: (() => {
        const handlerNames = [
            "topSites.get",
            "topSites.MostVisitedURL"
        ]
        const topSites = function () {}
        
        topSites.prototype['get'] = (options = {
            includeSearchShortcuts: false,
            includeBlocked: false,
            includeFavicon: false,
            includePinned: false,
            onePerDomain: true,
            newtab: false,
            limit: 12,
        }) => {
            console.log(window.webkit)
        };
        
        topSites.prototype.MostVisitedURL = (() => {
            return topSites.get()[0].url
        })();
        return new topSites();
    })(),
}, browserHandler);
