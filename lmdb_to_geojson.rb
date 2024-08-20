require 'lmdb'
require 'h3'
require 'json'

$db = LMDB.new('lmdb', :mapsize => 100 * 1024 * 1024).database
$fc = { :type => 'FeatureCollection', :features => [] }

$db.each {|k, v|
  h3 = k
  (count, alt, pomo) = v.split(',') 
  coordinates = H3.to_boundary(h3.to_i(16))
  $fc[:features].push({
    :type => 'Feature',
    :properties => {
      :count => count,
      :alt => alt,
      :pomo => pomo
    },
    :geometry => JSON.parse(H3.coordinates_to_geo_json([coordinates]))
  })
}

print JSON.pretty_generate($fc)
