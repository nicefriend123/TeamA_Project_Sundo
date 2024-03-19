/**
 * Elements that make up the popup.
 */
var container1 = document.getElementById('popup');
var content1 = document.getElementById('popup-content');
var closer1 = document.getElementById('popup-closer');

/**
 * Create an overlay to anchor the popup to the map.
 */
var overlay = new ol.Overlay({
	element : container1,
	autoPan : true,
	autoPanAnimation : {
		duration : 250,
	},
});

/**
 * Add a click handler to hide the popup.
 * @return {boolean} Don't follow the href.
 */
closer1.onclick = function () {
	overlay.setPosition(undefined);
	closer1.blur();
	return false;
};

var wmsSource = new ol.source.TileWMS({
    url: 'http://localhost/geoserver/testhere/wms',
    params: {
  	  'layers':'testhere:tl_bjd',
  	  'BBOX' : [1.3873946E7, 3906626.5, 1.4428045E7, 4670269.5], 
	  'SRS' : 'EPSG:3857', 
  	  'FORMAT' : 'image/png',
  	  'TILED':true},
    serverType: 'geoserver',
    transition: 0,
    projection: 'EPSG:3857',
});

var layers = [
	new ol.layer.Tile({
		source : new ol.source.XYZ({
			url : 'http://api.vworld.kr/req/wmts/1.0.0/1C6740EE-D23E-3A90-8F40-1D342D80666C	/Satellite/{z}/{y}/{x}.jpeg'
		})
	}),
	new ol.layer.Tile({
		source : wmsSource,
	}) 
];

var view = new ol.View({
	center: [14128579.82, 4512570.74],
	zoom: 11
}); 

var map = new ol.Map({
  layers: layers,
  overlays: [overlay],
  target: 'map',
  view: view,
});


map.on('singleclick', function (evt) {
	var viewResolution = /** @type {number} */(view.getResolution());
	var url = wmsSource.getGetFeatureInfoUrl(evt.coordinate, viewResolution,
			'EPSG:3857', {
				'INFO_FORMAT' : 'text/html',
				'QUERY_LAYERS' : 'tl_bjd'
			});
	
	if (url) {
		fetch(url).then(function(response) {
			return response.text();
		}).then(function(html) {
			document.getElementById('info').innerHTML = html;
			content1.innerHTML = html;
			overlay.setPosition(evt.coordinate);
		});
	}
});