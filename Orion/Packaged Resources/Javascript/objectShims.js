// NOTE: this is extremely cude, and honestly not exactly how I usually would do it...
// Ended up having to rush this


if (!window.browser) {
    Object.defineProperty(window, 'browser', {
        enumerable: false,
        writeable: false,
        configurable: false,
        value: new (class ObjectShim {
            
        })
    })
}
