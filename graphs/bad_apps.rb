#!../script/rails runner

$bad_apps = App.index(:latest).search(
  :size => 10,
  :sort => { :star_rating => :asc },
  :query =>  { :range => { :downloads => { :from => 1_000_000, :include_lower => true } } }
).results.map { |app| [app._id, app.title, app.downloads, app.star_rating] }

$good_apps = App.index(:latest).search(
  :size => 10,
  :sort => { :star_rating => :desc },
  :query =>  { :range => { :downloads => { :from => 1_000_000, :include_lower => true } } }
).results.map { |app| [app._id, app.title, app.downloads, app.star_rating] }
