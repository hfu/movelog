require 'json'
require 'time'

last = ''
while gets
  r = JSON.parse($_)
  next unless r['class'] == 'TPV'
  pomo = Time.parse(r['time']).to_i / 1800
  f = {
    :type => 'Feature',
    :geometry => {
      :type => 'Point',
      :coordinates => [
        r['lon'], r['lat']
      ]
    },
    :properties => {
      :alt => r['alt'],
      :pomo => pomo
    }
  }
  s = JSON.dump(f)
  if s == last
    print "#{JSON.dump(f)}\n" ##
  else
    print "#{JSON.dump(f)}\n"
    last = s
  end
end

