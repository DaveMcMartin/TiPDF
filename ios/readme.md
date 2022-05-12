# Ti PDF

Titanium module to handle PDF generation/edition on iOS using Quartz 2D for fast rendering and good quality.

# Installing

1. Download this project and open the .zip file in /ios/dist folder, then copy it's content to your project in the correct folder structure. The path will look like the following: `modules/iphone/net.davidmartins.tipdf/2.3.2`
2. Open Studio, and the `tiapp.xml` file for the project in question.
3. Switch to the `tiapp.xml` tab.
4. In the application's `tiapp.xml`, find the `<modules/>` node, and replace it with the new `<modules>` content. If you already have modules, just add a new node for the Ti PDF module. Note that the "version" and "platform" attributes are optional. When "version" is not specified, the latest version of the module will be used (as of Titanium SDK 2.0.0).
```xml
<modules>
    <module version="2.3.2" platform="iphone">net.davidmartins.tipdf</module>
</modules>
```
5. Use the require function to load the module in the app's code, for example:
```javascript
var pdfGenerator = require('net.davidmartins.tipdf').createPDF();
```
6. The next time the app is launched or built, Ti PDF should be included with the application.

## Prerequisites

* Mac OS X
* Axway Appcelerator Titanium
* XCode

# API

First of all, load the module.

```javascript
var pdfGenerator = require('net.davidmartins.tipdf').createPDF();
```

Then set the properties of your PDF and start drawing. To save call the savePDF function.

## Methods

All parameters with `*` are required.

### setProperties(obj`*`)
```javascript
pdfGenerator.setProperties({
    pdfName: "output",
    title: "",
    author: "",
    subject: "",
    keywords: "",
    creator: ""
});
```
Sets the properties of the PDF, *must* be called before everything if you want the properties to be setted properly.

| Name | Type | Description |
| --- |:---:| --- |
| obj | `Object` | property_name-to-property_value object structure |

### getProperties
```javascript
var props = pdfGenerator.getProperties();
```
Returns `Object` - PDF properties.

### openPDF(path`*`)
```javascript
var file = Ti.Filesystem.getFile(Ti.Filesystem.getApplicationDataDirectory(), "my_awesome_pdf.jpg");

pdfGenerator.openPDF(file.nativePath);
```
Opens a PDF where you can add new pages (`addNewPage`), delete pages (` deletePage`) and draw/write something `forEachPage`. Keep in mind that PDF is read-only, so you can not, for example, edit shapes, change texts or such things on pages that have already been finished.

| Name | Type | Description |
| --- |:---:| --- |
| path | `String` | The PDF file URL, it *must* be in the application folders. |

### addNewPage()
```javascript
pdfGenerator.addNewPage();
```
Adds a new page to the PDF.

### deletePage(page`*`)
```javascript
pdfGenerator.deletePage(3);
```
Deletes a page from the PDF.

| Name | Type | Description |
| --- |:---:| --- |
| page | `Number` | Index of the page to be deleted, starts with 1 and must be an Integer |

### forEachPage(fnc`*`)
```javascript
pdfGenerator.forEachPage(function(e){
    var pageIndex = e.page;
    var total = e.total;
    
    // Drawing functions here, you can draw the header and footer, example:
    pdfGenerator.drawText("Page " + pageIndex + " of " + total, 20, 700, 572, 30);

    // More drawing function as you wish
});
```
Executes a function for each page of the PDF where you can draw into.

| Name | Type | Description |
| --- |:---:| --- |
| fnc | `Function` | Function which will be executed for each page receiving an object with the parameters index and total, both `Number`s |

### setTextColor(R`*`, G`*`, B`*`, A)
```javascript
pdfGenerator.setTextColor(27, 27, 27, 1.0);
```
Sets the text color in RGBA notation or RGB if A is omitted.

| Name | Type | Description |
| --- |:---:| --- |
| R | `Number` | Color channel value, must be a value in the range from 0 (solid red) to 255 (white) |
| G | `Number` | Color channel value, must be a value in the range from 0 (solid green) to 255 (white) |
| B | `Number`| Color channel value, must be a value in the range from 0 (solid blue) to 255 (white) |
| A | `Number` | Alpha channel value, must be a value in the range from 0.0 (transparent) to 1.0 (solid color) |

### setDrawColor(R`*`, G`*`, B`*`, A)
```javascript
pdfGenerator.setDrawColor(27, 27, 27, 1.0);
```
Sets the draw color in RGBA notation or RGB if A is omitted.

| Name | Type | Description |
| --- |:---:| --- |
| R | `Number` | Color channel value, must be a value in the range from 0 (solid red) to 255 (white) |
| G | `Number` | Color channel value, must be a value in the range from 0 (solid green) to 255 (white) |
| B | `Number`| Color channel value, must be a value in the range from 0 (solid blue) to 255 (white) |
| A | `Number` | Alpha channel value, must be a value in the range from 0.0 (transparent) to 1.0 (solid color) |

### setFillColor(R`*`, G`*`, B`*`, A)
```javascript
pdfGenerator.setFillColor(255, 255, 255, 0.0);
```
Sets the fill color in RGBA notation or RGB if A is omitted. This property applies only for shapes.

| Name | Type | Description |
| --- |:---:| --- |
| R | `Number` | Color channel value, must be a value in the range from 0 (solid red) to 255 (white) |
| G | `Number` | Color channel value, must be a value in the range from 0 (solid green) to 255 (white) |
| B | `Number`| Color channel value, must be a value in the range from 0 (solid blue) to 255 (white) |
| A | `Number` | Alpha channel value, must be a value in the range from 0.0 (transparent) to 1.0 (solid color) |

### setLineWidth(width`*`)
```javascript
pdfGenerator.setLineWidth(0.1);
```
Sets line width for upcoming lines and shapes.

| Name | Type | Description |
| --- |:---:| --- |
| width | `Number` | Line width, must be a float/double |

### getLineWidth()
```javascript
pdfGenerator.getLineWidth();
```
Returns `Number` - Line width.

### setFontName(fontName`*`)
```javascript
pdfGenerator.setFontName("Helvetica");
```
Sets text font for upcoming text elements.

| Name | Type | Description |
| --- |:---:| --- |
| fontName | `String` | Font name or family. Style or variant must be included in the fontName, example: `Helvetica-Bold` |

### getFontName()
```javascript
pdfGenerator.getFontName();
```
Returns `String` - Current font name.

### setTextSize(size`*`)
```javascript
pdfGenerator.setTextSize(14);
```
Sets text size for upcoming text elements.

| Name | Type | Description |
| --- |:---:| --- |
| size | `Number` | Font name or family. Style or variant must be included in the fontName, example: `Helvetica-Bold` |

### getTextSize()
```javascript
pdfGenerator.getTextSize();
```
Returns `Number` - Current size of text.

### setTextAlign(alignment`*`)
```javascript
pdfGenerator.setTextAlign("center");
```
Sets text horizontal alignment for upcoming text elements.

| Name | Type | Description |
| --- |:---:| --- |
| alignment | `String` | Horizontal text alignment, available values are `left`, `center`, `right`, `justified` |

### getTextAlign()
```javascript
pdfGenerator.getTextAlign();
```
Returns `String` - Current text horizontal alignment.

### setTextVerticalAlign(alignment`*`)
```javascript
pdfGenerator.setTextVerticalAlign("middle");
```
Sets text vertical alignment for upcoming text elements.

| Name | Type | Description |
| --- |:---:| --- |
| alignment | `String` | Vertical text alignment, available values are `top`, `middle`, `bottom` |

### getTextVerticalAlign()
```javascript
pdfGenerator.getTextVerticalAlign();
```
Returns `String` - Current text vertical alignment.

### setPdfName(pdfName`*`)
```javascript
pdfGenerator.setPdfName("my_awesome_pdf");
```
Sets the file name of the generated PDF.

| Name | Type | Description |
| --- |:---:| --- |
| pdfName | `String` | The name of the PDF without file extension |

### getPdfName()
```javascript
pdfGenerator.getPdfName();
```
Returns `String` - PDF filename.

### drawText(text`*`, x`*`, y`*`, width`*`, height`*`)
```javascript
pdfGenerator.drawText("The fox jumps over the lazy dog", 20, 20, 572, 30);
```
Writes text to the PDF.

| Name | Type | Description |
| --- |:---:| --- |
| text | `String` | The text to be drawn |
| x | `Number` | Top-down horizontal coordinate where 0 is the start point at top, must be an Integer |
| y | `Number` | Left-right vertical coordinate where 0 is the start point at left, must be an Integer |
| width | `Number` | Width of the rect where the text will be drawn, must be an Integer |
| height | `Number` | Height of the rect where the text will be drawn, must be an Integer |

### getTextHeightForRect(text`*`, width`*`)
```javascript
pdfGenerator.getTextHeightForRect("The fox jumps over the lazy dog", 200);
```
Calculates the height of the text in the specified width

| Name | Type | Description |
| --- |:---:| --- |
| text | `String` | The text that will have its calculated height |
| width | `Number` | The max width for the line break of the text |

Returns `Number` - height for the text in the specified width

### drawLine(startX`*`, startY`*`, endX`*`, endY`*`)
```javascript
pdfGenerator.drawLine(20, 20, 500, 500);
```
Draws a line from one point to other.

| Name | Type | Description |
| --- |:---:| --- |
| startX | `Number` | Top-down vertical coordinate for the start point, must be an Integer |
| startY | `Number` | Left-right horizontal coordinate for the start point, must be an Integer |
| endX | `Number` | Top-down vertical coordinate for the end point, must be an Integer |
| endY | `Number` | Left-right horizontal coordinate for the end point, must be an Integer |

### drawRect(x`*`, y`*`, width`*`, height`*`)
```javascript
pdfGenerator.drawRect(10, 10, 582, 35);
```
Draws a rectangle.

| Name | Type | Description |
| --- |:---:| --- |
| x | `Number` | Top-down horizontal coordinate where 0 is the start point at top, must be an Integer |
| y | `Number` | Left-right vertical coordinate where 0 is the start point at left, must be an Integer |
| width | `Number` | Width of the rectangle, must be an Integer |
| height | `Number` | Height of the rectangle, must be an Integer |

### drawImage(url`*`, x`*`, y`*`, width`*`, height`*`,defaultImage)
```javascript
pdfGenerator.drawImage("\mypath\to\my\awesome\image.jpg", 20, 80, 100, 100);
```
Draws an image from documents or web link.

| Name | Type | Description |
| --- |:---:| --- |
| url | `String` | Image path location (must be in documents folder) or image link (from web)|
| x | `Number` | Top-down horizontal coordinate where 0 is the start point at top, must be an Integer |
| y | `Number` | Left-right vertical coordinate where 0 is the start point at left, must be an Integer |
| width | `Number` | Width of the rectangle, must be an Integer |
| height | `Number` | Height of the rectangle, must be an Integer |
| defaultImage | `String` | Image path location (must be in documents folder), can not be a link|

### drawEllipse(x`*`, y`*`, width`*`, height`*`)
```javascript
pdfGenerator.drawEllipse(10, 10, 90, 90);
```
Draws an ellipse.

| Name | Type | Description |
| --- |:---:| --- |
| x | `Number` | Top-down horizontal coordinate where 0 is the start point at top, must be an Integer |
| y | `Number` | Left-right vertical coordinate where 0 is the start point at left, must be an Integer |
| width | `Number` | Width of the ellipse, must be an Integer |
| height | `Number` | Height of the ellipse, must be an Integer |

### addURL(url`*`, x`*`, y`*`, width`*`, height`*`)
```javascript
pdfGenerator.addURL("https://davidmartins.net/", 20, 620, 572, 30);
```
Adds a clickable area into a rectangle which opens a link on click.

| Name | Type | Description |
| --- |:---:| --- |
| url | `String` | The link |
| x | `Number` | Top-down horizontal coordinate where 0 is the start point at top, must be an Integer |
| y | `Number` | Left-right vertical coordinate where 0 is the start point at left, must be an Integer |
| width | `Number` | Width of the rectangle for the clickable area, must be an Integer |
| height | `Number` | Height of the rectangle for the clickable area, must be an Integer |

### cancelPDF()
```javascript
pdfGenerator.cancelPDF();
```
Cancels the PDF drawing.

### savePDF(callback`*`)
```javascript
pdfGenerator.savePDF(function(e){
    Ti.API.info("My Awesome PDF is located at: " + e.url);
});
```
Saves the PDF file, calling callback when the file is ready.

| Name | Type | Description |
| --- |:---:| --- |
| pdfName | `Function` | A callback function which will be called when PDF is ready returning a dictionary with the file url |

### generateFromJSON(json`*`, callback`*`)
```javascript
var pageHeight = pdfGenerator.pageHeight;
var pageWidth = pdfGenerator.pageWidth;

pdfGenerator.generateFromJSON([
        {
            action: "setDrawColor",
            args: [63, 63, 63]
        },
        {
            action: "drawRect",
            args: [5, 5, pageWidth - 10, 40]
        },
        {
            action: "setTextColor",
            args: [45, 45, 45]
        },
        {
            action: "setTextSize",
            args: [9]
        },
        {
            action: "drawText",
            args: ["Fone:", 8, 19, (pageWidth / 2) - 10, 12]
        },
        {
            action: "drawText",
            args: ["E-mail:", 8, 31, (pageWidth / 2) - 10, 12]
        },
        {
            action: "drawText",
            args: ["Company Name", Math.floor(pageWidth / 2) - 8, 7, (pageWidth / 2) - 10, 12]
        },
        {
            action: "drawText",
            args: ["Phone:", Math.floor(pageWidth / 2) - 8, 19, (pageWidth / 2) - 10, 12]
        },
        {
            action: "drawText",
            args: ["E-mail:", Math.floor(pageWidth / 2) - 8, 31, (pageWidth / 2) - 10, 12]
        },
        {
            action: "setFontName",
            args: ["Helvetica-Bold"]
        },
        {
            action: "drawText",
            args: ["999-999-999", Math.floor(pageWidth / 2) + 25, 19, (pageWidth / 2) - 10, 12]
        },
        {
            action: "drawText",
            args: ["company@email.com", Math.floor(pageWidth / 2) + 27, 31, (pageWidth / 2) - 10, 12]
        },
        {
            action: "forEachPage",
            args: [function(e) {
                var index = e.page;
                var total = e.total;
                
                pdfGenerator.drawText("by Dave McMartin", 7, pageHeight - 15, 200, 10);
                pdfGenerator.addURL("https://davidmartins.net/", 7, pageHeight - 15, 200, 10);
                
                pdfGenerator.setTextAlign("right");
                pdfGenerator.drawText("Page " + index + " of " + total, pageWidth - 80, pageHeight - 15, 73, 10);
                pdfGenerator.setTextAlign("left");
            }]
        }
    ], 
    function(e){
        Ti.API.info("PDF location: " + e.url);
    }
);
```
Generates the PDF from JSON array.

| Name | Type | Description |
| --- |:---:| --- |
| json | `Array` | Array of objects with 2 properties: action and args. Action is the drawing method name and args is an array containing all arguments for the drawing function. All drawing methods can be used except `cancelPDF`,`savePDF`,`generateFromJSON`(of course) and `openPDF`  |
| callback | `Function` | Callback function to be executed after all drawing commands. Is the same callback as for savePDF  |

### setPageWidth(width`*`)
```javascript
pdfGenerator.setPageWidth(620);
```
Sets PDF page width.

| Name | Type | Description |
| --- |:---:| --- |
| width | `Number` | Width of the PDF page, must be an Integer |

### getPageWidth()
```javascript
pdfGenerator.getPageWidth();
```
Returns `Number` - Page width (default is 612).

### setPageHeight(height`*`)
```javascript
pdfGenerator.setPageHeight(800);
```
Sets PDF page height.

| Name | Type | Description |
| --- |:---:| --- |
| height | `Number` | Height of the PDF page, must be an Integer |

### getPageHeight()
```javascript
pdfGenerator.getPageHeight();
```
Returns `Number` - Page height (default is 792).

### getPageCount()
```javascript
pdfGenerator.getPageCount();
```
Returns `Number` - Number of pages.

## Examples

The follwing example illustrates the usage of Ti PDF with multiple over-the-bridge calls.

```javascript
var docViewer = Ti.UI.iOS.createDocumentViewer();
var pdfGenerator = require("net.davidmartins.tipdf").createPDF();

// The PDF name doesn't need extension .pdf, only the name
// setProperties only works if used before everything else
pdfGenerator.setProperties({
    pdfName: "pdfOutputName",
    title: "The title of the PDF",
    author: "The author of the PDF",
    subject: "A subject if you want",
    keywords: "Keyworkds of the PDF",
    creator: "PDF Creator"
});

pdfGenerator.addNewPage();

pdfGenerator.drawText("The fox jumps over the lazy fox.", 100, 40, 200, 40);
pdfGenerator.drawLine(10, 10, 60, 60);

pdfGenerator.drawRect(5, 520, 100, 20);

// the image file must be in documents directory
var file = Ti.Filesystem.getFile(Titanium.Filesystem.getApplicationDataDirectory(), "yourFileName.jpg");

pdfGenerator.drawImage(file.nativePath, 500, 80, 16, 16);

// the image can be a link
pdfGenerator.drawImage('http://grupow2abrasil.com.br/wp-content/themes/grupow2abrasil/img/logo-grupo-horizontal.png', 300, 80, 267, 67);

pdfGenerator.setTextSize(12);
pdfGenerator.drawText("I'm a text with different font size", 10, 220, 300, 40);
pdfGenerator.setTextColor(158, 67, 89);
pdfGenerator.drawText("I'm a text with different color", 10, 120, 300, 40);

pdfGenerator.setLineWidth(5.0);
pdfGenerator.drawRect(50, 80, 25, 60);

pdfGenerator.drawEllipse(200, 300, 25, 60);

pdfGenerator.forEachPage(function(pageIndex, total){
    // Drawing functions here, you can draw the header and footer, example:
    pdfGenerator.drawText("Page " + pageIndex + " of " + total, 20, 700, 572, 30);
});

pdfGenerator.savePDF(function(e){
    Ti.API.info("url: " + e.url);
    
    var file = Ti.Filesystem.getFile(e.url);
    docViewer.setUrl(file.resolve());
    docViewer.show();
});
```

The follwing example illustrates the usage of Ti PDF with JSON.

```javascript
var docViewer = Ti.UI.iOS.createDocumentViewer();
var pdfGenerator = require("net.davidmartins.tipdf").createPDF();

var json = [
    // The PDF name doesn't need extension .pdf, only the name
    // setProperties only works if used before everything else
    {
        action: "setProperties",
        args: [{
            pdfName: "pdfOutputName",
            title: "The title of the PDF",
            author: "The author of the PDF",
            subject: "A subject if you want",
            keywords: "Keyworkds of the PDF",
            creator: "PDF Creator"
        }]
    },
    {
        action: "addNewPage"
    },
    {
        action: "drawText",
        args: ["The fox jumps over the lazy fox.", 100, 40, 200, 40]
    },
    {
        action: "drawLine",
        args: [10, 10, 60, 60]
    },
    {
        action: "drawRect",
        args: [5, 520, 100, 20]
    },
    // the image file must be in documents directory
    {
        action: "drawImage",
        args: [Ti.Filesystem.getFile(Titanium.Filesystem.getApplicationDataDirectory(), "yourFileName.jpg").nativePath, 500, 80, 16, 16]
    },
    // the image can be a link
    {
        action: "drawImage",
        args: ['http://grupow2abrasil.com.br/wp-content/themes/grupow2abrasil/img/logo-grupo-horizontal.png', 300, 80, 267, 67]
    },
    {
        action: "setTextSize",
        args: [12]
    },
    {
        action: "drawText",
        args: ["I'm a text with different font size", 10, 220, 300, 40]
    },
    {
        action: "setTextColor",
        args: [158, 67, 89]
    },
    {
        action: "drawText",
        args: ["I'm a text with different color", 10, 120, 300, 40]
    },
    {
        action: "setLineWidth",
        args: [5.0]
    },
    {
        action: "drawRect",
        args: [50, 80, 25, 60]
    },
    {
        action: "drawEllipse",
        args: [200, 300, 25, 60]
    },
    {
        action: "forEachPage",
        args: [function(e){
            var pageIndex = e.page;
            var total = e.total;
            // Drawing functions here, you can draw the header and footer, example:
            pdfGenerator.drawText("Page " + pageIndex + " of " + total, 20, 700, 572, 30);
        }]
    }
];

// is always better do everything in one module call, so
// the json approach is the better choice
pdfGenerator.generateFromJSON(json, function(e){
    Ti.API.info("url: " + e.url);

    var file = Ti.Filesystem.getFile(e.url);
    docViewer.setUrl(file.resolve());
    docViewer.show();
});
```

# Built With

* [Axway Appcelerator Titanium](https://www.appcelerator.com/) - Mobile Development Platform
* [XCode](https://developer.apple.com/xcode/) - iOS IDE
* [Quartz 2D](https://developer.apple.com/library/content/documentation/GraphicsImaging/Conceptual/drawingwithquartz2d/Introduction/Introduction.html) - iOS 2D Native Rendering Framework

Happy Coding!

# License

Ti PDF is licensed under MIT.

```
 Copyright (c) 2018-2020 David Martins dos Anjos

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
```
