// For more info, see documentation


// open a single window
var win = Ti.UI.createWindow({
	backgroundColor:'white'
});

var button = Ti.UI.createButtonBar({
	labels : ["Generate", "Generate from JSON"],
	font : {
		fontSize : 18
	},
	top: 20,
	left: 20,
	right: 20,
	height: 40
});
win.add(button);

button.addEventListener("click", function(e){
	if(e.index == 0) {
		generate();
	} else {
		generateUsingJSON();
	}
});

var webview = Ti.UI.createWebView({
	top: button.top + button.height + 20,
	left: 20,
	right: 20
});
win.add(webview);

win.open();

function generate() {
	// Module loaded
	var ti_pdf = require('net.davidmartins.tipdf');
	var pdfGenerator = ti_pdf.createPDF();
	
	button.disabled = true;
	
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
	
	/* the image file must be in documents directory
	var file = Ti.Filesystem.getFile(Titanium.Filesystem.getApplicationDataDirectory(), "yourFileName.jpg");
	
	pdfGenerator.drawImage(file.nativePath, 500, 80, 16, 16);*/
	
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
	    Ti.API.info("PDF url: " + e.url);
	    
	    var file = Ti.Filesystem.getFile(e.url);
	    webview.data = file;
	    button.disabled = false;
	});
}

function generateUsingJSON() {
	// Module loaded
	var ti_pdf = require('net.davidmartins.tipdf');
	var pdfGenerator = ti_pdf.createPDF();
	
	button.disabled = true;
	
	// This json can come from any source you want, like a web service
	// or making it from database data
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
		/* the image file must be in documents directory
		{
		    action: "drawImage",
		    args: [Ti.Filesystem.getFile(Titanium.Filesystem.getApplicationDataDirectory(), "yourFileName.jpg").nativePath, 500, 80, 16, 16]
		},*/
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
	// the json approach is the better choice as it has better performance
	pdfGenerator.generateFromJSON(json, function(e){
	    Ti.API.info("PDF url: " + e.url);
	
	    var file = Ti.Filesystem.getFile(e.url);
	    webview.data = file;
	    button.disabled = false;
	});
}

