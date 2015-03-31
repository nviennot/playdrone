Playdrone snapshots on archive.org
==================================

We worked with the archive.org team to provide snapshots of the Google Play
Android market.
We crawled the market 13 days, from 2014-10-19 to 2014-10-31, and released the
data on archive.org for public use.

For each day, a file
`https://archive.org/download/playdrone-snapshots/2014-10-{19..31}.json`
contains the list of all applications present on the market for that specific day.

These daily snapshots contain a list of applications as an array of json
objects. The following show an example of an application object:

```
{
  "app_id":"com.google.android.youtube",
  "title":"YouTube",
  "developer_name":"Google Inc.",
  "category":"MEDIA_AND_VIDEO",
  "free":true,
  "version_code":51405300,
  "version_string":"5.14.5",
  "installation_size":10191835,
  "downloads":1000000000,
  "star_rating":4.08009,
  "snapshot_date":"2014-10-31",
  "metadata_url":"https://archive.org/download/playdrone-metadata-2014-10-31-c9/com.google.android.youtube.json",
  "apk_url":"https://archive.org/download/playdrone-apk-c9/com.google.android.youtube-51405300.apk"
}
```

Notes:

* Applications are sorted by download counts.
* The provided metadata in the snapshot files only contains a subset of
  available metadata for a given application. To fetch additional metadata, the
  `metadata_url` link can be fetched. Its content is the Google API response
  in JSON format when asked for the application full metadata.
  To interpret the raw metadata, you may use this [reference](https://github.com/nviennot/playdrone/blob/master/app/models/app.rb#L98-L128).
* The `apk_url` link can be fetch to retrieve the corresponding APK binary.
* Overall, Playdrone failed to download the APK for 0.1% of the free
  applications. For these applications, no `apk_url` property is provided.

If you need a single snapshot of the market, we recommend you use the latest
snapshot:
[https://archive.org/download/playdrone-snapshots/2014-10-31.json](https://archive.org/download/playdrone-snapshots/2014-10-31.json).
It contains 1,402,894 applications.

To quickly download 1000 APKs starting from the most popular,
the following can be used to download APKs in 12-way to speed things up:

```
wget https://archive.org/download/playdrone-snapshots/2014-10-31.json
grep apk_url 2014-10-31.json | head -n 1000 | sed -e 's/"apk_url":"\(.*\)"$/\1/' | xargs -L1 -P12 wget -q
```
