DST_DIR = docs
PMTILES_FILENAME = move.pmtiles
LAYER = move
MAPLIBRE_JS_URL = 'https://unpkg.com/maplibre-gl/dist/maplibre-gl.js'
MAPLIBRE_CSS_URL = 'https://unpkg.com/maplibre-gl/dist/maplibre-gl.css'
PMTILES_JS_URL = 'https://unpkg.com/pmtiles/dist/pmtiles.js'
OPTIMAL_BVMAP_URL = 'https://cyberjapandata.gsi.go.jp/xyz/optimal_bvmap-v1/optimal_bvmap-v1.pmtiles'
PORT = 8080

move:
	gpspipe -w | ruby togeojsons.rb | uniq >> move.geojsons

pmtiles:
	head -n -1 move.geojsons |\
	tippecanoe -f -l ${LAYER} -o ${DST_DIR}/${PMTILES_FILENAME}

download:
	curl -L -o ${DST_DIR}/maplibre-gl.js ${MAPLIBRE_JS_URL}
	curl -L -o ${DST_DIR}/maplibre-gl.css ${MAPLIBRE_CSS_URL}
	curl -L -o ${DST_DIR}/pmtiles.js ${PMTILES_JS_URL}
	curl -L -o ${DST_DIR}/optimal_bvmap-v1.pmtiles ${OPTIMAL_BVMAP_URL}

serve: 
	ruby -run -e httpd docs -p 8000
