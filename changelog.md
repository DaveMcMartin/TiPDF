## Version 2.3.1

* Some ajustments for Titanium SDK 8.X.X

## Version 2.3.0

* Added method `generateFromJSON` too generate PDF from JSON object

## Version 2.2.0

* Added default image to method drawImage

## Version 2.1.2

* More adjustments in the method getTextHeightForRect

## Version 2.1.1

* Deprecated method `sizeWithAttributes` replaced with `boundingRectWithSize` in  getTextHeightForRect since height calculation of the text sometimes was quite wrong

## Version 2.1.0

* drawImage now accepts URL from web
* Added method `getTextHeightForRect` to calculate height for dynamic text

## Version 2.0.0

* Removed event `pdfReady` , now after save, a function is called
* Fixed text vertical position bug where middle was bottom instead of middle
* Few improvements
* Fixed some bugs and added new bugs to fix later

## Version 1.1.0

* Added methods `openPDF`, `cancelPDF`, `deletePage`, `forEachPage`, `getProperties`, `drawEllipse` and `addURL`
* Removed method `getPageNumbers` and improved `getPageCount` (redundant method)
* Changed `savePDF` to accept a string (the name of the pdf) as parameter instead of an object
* Added horizontal and vertical text alignments with the new properties `textAlign` and `textVerticalAlign`
* Fixed text positioning
* Revised all source code and made a lot of adjustments improving comments documentation
* Added input validation to all methods
* Fixed a lot of bugs
* Added new bugs to fix later...

## Version 1.0.0

* First version, needs a lot of improvements and new features.
