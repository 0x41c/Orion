# Orion Challenge  

### Corban Amouzou

___

### Initial thoughts

Honestly, it feels a bit daunting! I've never created a browser before, and never one in such a short time. However, I am thrilled to be doing so. I feel like I'll learn a lot about problem-solving on the fly, creating readable code, documentation standards, and other people's views through healthy and constructive criticism. Thank you for giving my friend and me the chance to do something like this. Your community is amazing, and I'm happy to know that other people I know have been saying good things about this startup. With formalities out of the way, let's get into the process of developing this thing.


... *time passes*


### How did I do?

Well, not as well as I had hoped, but I learned a lot along the way. If I were to do all of that again, I would definitely have gotten it done a lot faster, as I now know potential issues that I might face along the way. How many of the five things did I get done? Well, I've gotten questions 3-5 covered, and the other two are partially completed. I struggled with the toolbar the most. It took more time than I'd like to admit to getting familiar with it (3 of the two days), but now I can say that I won't struggle with it anymore. I also struggled with figuring out how I would implement focus contexts with the search fields, but finally, on the last day, something clicked! I completely understand it now. I'm a little baffled by how I was having issues with it before. I can't go back in time and fix that, so "such is life" I guess. I made it with the purpose of being compatible with macOS 10.13. I can't guarantee, however, that it is completely compatible. The only thing I *can* guarantee is that it will compile for that version. I am so happy about the extension downloader and installer. That works like a charm. The only issue I have with it is that I had to rush the popup for the extension action. There is an issue with loading the WKWebView resources that I didn't have the time to figure out yet. My biggest challenge of all was getting the toolbar to stretch... It was a simple fix. I had to remove three lines of code because it was setting up unwanted constraints on the stack view. These lines in particular:

```swift
if #available(macOS 11, *) {
  window!.toolbar!.centeredItemIdentifier = .tabs
}
```

Once again, I wish I could have gone back in time and saved myself the hassle of spending so many days on that, but yeah, you live, and you learn.

Anyways, in conclusion, the app is essentially a basic browser. At the time of writing, the tabs work but don't animate or appear like the safari tabs **yet.** The search history is not saved, and the tabs don't have restoration **yet.** (and neither do windows). The extension toolbar action has issues loading resources. The thing to take away from this is that these will be fixed.

### Screenshots

> Main window
![Main Window](images/Main%20window.png)

> Adding an extension
![Adding an Extension](images/Adding%20an%20Extension.png)

> The popover shown by an extension (note, the icon in the toolbar is still WIP)
![Extension Popover](images/Extension%20Popover.png)

> How it looks with multiple tabs (for now)
![Multiple Tabs](images/Multiple%20Tabs.png)
