//Script creado a partir del ejemplo de http://alexmarandon.com/articles/web_widget_jquery/

//TODO obtener la url de otra manera
var urlWidget = "http://192.168.1.20:3000/";
var jsonController = "widgets/";
var magImagePath = "images/widgets/lupa.png";
var stylesPath = "stylesheets/widget.css";
// Debug
// var myhost="http://atn.pymeprivee.com";
var myhost = "http://localhost:8080/atn";
var saleUrl;
var $divDialog;

(function() {
	var $;

	/** ****** Load jQuery if not present ******** */
	if (window.jQuery === undefined || window.jQuery.fn.jquery !== '1.5.1') {
		var script_tag = document.createElement('script');
		script_tag.setAttribute("type", "text/javascript");
		script_tag
				.setAttribute("src",
						"http://ajax.googleapis.com/ajax/libs/jquery/1.5.1/jquery.min.js");
		script_tag.onload = scriptLoadHandler;
		script_tag.onreadystatechange = function() { // Same thing but for IE
			if (this.readyState == 'complete' || this.readyState == 'loaded') {
				scriptLoadHandler();
			}
		};
		// Try to find the head, otherwise default to the documentElement
		(document.getElementsByTagName("head")[0] || document.documentElement)
				.appendChild(script_tag);
	} else {
		// The jQuery version on the window is the one we want to use
		$ = window.jQuery;
		main();
	}

	/** ****** Called once jQuery has loaded ***** */
	function scriptLoadHandler() {
		// Call our main function
		main();
	}

	/** ****** Our main function ******* */
	function main() {
		jQuery(document).ready(function() {
			loadCss();
			renderAllWidgets();
		});
	}

	function loadJQueryUI() {
		jQuery.getScript(urlWidget + "javascripts/jquery-ui-1.8.11.min.js", function() {
			// Restore $ and window.jQuery to their previous values and store
			// the
			// new jQuery in our local jQuery variable
			$ = window.jQuery.noConflict(true);
			var $zooms = $('div.zoom-control');
			// console.log($zooms);
			$.each($zooms, function(index, zoom) {
				// console.log(zoom);
				$zoom = $(zoom);
				$zoom.click(clickEvent);
			});
		});
	}

	function clickEvent() {
		$divDialog.dialog({
			width: "70%",
			dialogClass: ''
		});
	}

	function getJQuery(){
		return $ || jQuery;
	}
	
	function loadCss() {
		var css_link = jQuery("<link>", {
			rel : "stylesheet",
			type : "text/css",
			href : urlWidget + "stylesheets/widget.css"
		});
		css_link.appendTo('head');
		var jquery_ui_css = jQuery("<link>", {
			rel : "stylesheet",
			type : "text/css",
			href : urlWidget + "stylesheets/jquery-ui-1.8.11.custom.css"
		});
		jquery_ui_css.appendTo('head');

	}

	function renderAllWidgets() {
		var $widgets = jQuery('div.pyme-privee-widget');
		jQuery.each($widgets, function(index, widget) {
			var $widget = jQuery(widget);
			loadData($widget);

		});
	}

	function loadData($widget) {
		var widgetId = $widget.attr("id");
		var divIdProcessor = new DivIdProcessor(widgetId);
		var entity = divIdProcessor.entity();
		var id = divIdProcessor.id();
		var urlBuilder = new UrlBuilder(entity, id);
		var jsonpUrl = urlBuilder.url();
		jQuery.getJSON(jsonpUrl, function(data) {
			saleUrl=data.sale_url;
			$widget.html(renderWidget(data, entity, id));
			
			saleUrl = saleUrl + "?callback=?";
			jQuery.getJSON(saleUrl, function(data) {
				console.log(data.html);
				$divDialog = getJQuery()('<div id="dialog-html-container" title="'
						+ data.shop_name + '"></div>');
				$divDialog.appendTo("body");
				$divDialog.html(data.html);
				$divDialog.hide();
				
			}).error(function(data){
				console.log(data);
			});
			loadJQueryUI();
		});
	}

})(); // We call our anonymous function immediately
/*
 * 
 */

function renderWidget(data, entity, id) {
	return new WidgetRenderer(data, entity, id).render();
}

/* class DivIdProcessor */

DivIdProcessor = function(divId) {
	var divIdParts = divId.split("-");
	this.entityValue = divIdParts[0];
	this.idValue = divIdParts[1];

	this.entity = function() {
		return this.entityValue;
	};

	this.id = function() {
		return this.idValue;
	};
};

/* class UrlBuilder */

UrlBuilder = function(entity, id) {
	this.urlValue = urlWidget + jsonController + entity + "/" + id
			+ "/current.json?callback=?";

	this.url = function() {
		return this.urlValue;
	};
};

/* class DescriptionRenderer */

DescriptionRenderer = function(description, url, price) {
	this.description = description;
	var linkRenderer = new LinkRenderer(url, price);

	this.render = function() {
		return "<div class='description-layer ui-corner-all'><table border='0' height='100%' width='100%' cellspacing='0' cellpadding='0'><tr><td valign='top'>"
				+ this.description
				+ "</td></tr><tr height='10px'><td valign='bottom' class='ui-widget-header ui-icon-closethick'>"
				+ linkRenderer.render() + "</td></tr></table></div>";
	};
};

/* class LinkRenderer */

LinkRenderer = function(url, price) {
	this.url = url;
	this.price = price;
	var that = this;
	var renderInternalLink = function() {
		return "<a href='" + that.url
				+ "' target='_blank'>C&oacute;mprelo por " + that.price
				+ " euros</a>";
	};

	this.render = function() {
		return "<div class='controls-layer ui-corner-bottom'>"
				+ renderInternalLink() + "</div>";
	};
};

/* class ZoomRenderer */

ZoomRenderer = function(entity, id) {
	this.render = function() {
		return "<div class='zoom-control ui-state-default ui-corner-all' id='open_window_widget-" + entity
				+ "-" + id + "'>"
				+ "<div class='ui-icon ui-icon-circle-plus'></div>"
				+ "</div>";
	};
};

/* class ImageRenderer */

ImageRenderer = function(url) {
	this.url = url;
	this.render = function() {
		return "<img width='100%' src= '" + this.url + "'>";
	};
};

/* class WidgetRenderer */

WidgetRenderer = function(product, entity, id) {
	var descriptionRenderer = new DescriptionRenderer(product.description,
			product.buy_url, product.price);
	var zoomRenderer = new ZoomRenderer(entity, id);
	var imageRenderer = new ImageRenderer(product.image);

	this.render = function() {
		return "<div id='id_div_container-layer-" + entity + "-" + id
				+ "' class='ui-corner-all container-layer'>"
				+ descriptionRenderer.render() + zoomRenderer.render()
				+ imageRenderer.render() + "</div>";
	};
};