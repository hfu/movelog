require 'json'
require 'time'
require 'h3'
require 'lmdb'

RESOLUTION = 12

$db = LMDB.new('lmdb', :mapsize => 100 * 1024 * 1024).database

while gets
  r = JSON.parse($_)
  next unless r['class'] == 'TPV'
  lng = r['lon']
  next if lng.nil?
  lat = r['lat']
  next if lat.nil?
  alt = r['alt']
  next if alt.nil?
  pomo = Time.parse(r['time']).to_i / 1800
  h3 = H3.from_geo_coordinates([lat, lng], RESOLUTION).to_s(16)
  f = {
    :type => 'Feature',
    :geometry => {
      :type => 'Point',
      :coordinates => [lng, lat]
    },
    :properties => {
      :alt => alt,
      :pomo => pomo,
      :h3 => h3
    }
  }
  s = JSON.dump(f)
  print "#{JSON.dump(f)}\n"
  r = $db[h3]
  if r 
    (count, alt_, pomo_) = r.split(',')
    count = count.to_i
    $db[h3] = [count + 1, alt, pomo].join(',')
  else
    $db[h3] = [1, alt, pomo].join(',')
  end
end

