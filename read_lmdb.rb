require 'lmdb'

$db = LMDB.new('lmdb', :mapsize => 100 * 1024 * 1024).database
$db.each {|k, v|
  print "#{k}: #{v}\n"
}
