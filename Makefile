move:
	gpspipe -w | ruby togeojsons.rb | uniq >> move.geojsons


