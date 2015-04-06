PlayDrone
---------

This repository contains the code used in the following paper:

[![A Measurement Study of Google Play](http://i.imgur.com/ZAuWtry.png)](http://viennot.com/playdrone.pdf)

The talk can be watched on Youtube: [http://youtu.be/xS0lyL\_0OAM](http://youtu.be/xS0lyL_0OAM)

The slides are available here: [http://viennot.com/playdrone-slides.pdf](http://viennot.com/playdrone-slides.pdf)

The paper can be downloaded here: [http://viennot.com/playdrone.pdf](http://viennot.com/playdrone.pdf)


---

November 2014 Market Snapshot
------------------------------

archive.org has deployed PlayDrone to capture a few days worth of data.

Instructions on how to get this dataset can be found on [https://archive.org/details/android_apps](https://archive.org/details/android_apps&tab=about).

PlayDrone Code
--------------

The code is research quality code. It's poorly documented, and have no test suite.

Most of the code lies in
[lib/](https://github.com/nviennot/playdrone/tree/master/lib) and
[app/models/](https://github.com/nviennot/playdrone/tree/master/app/models).

I strongly discourage you to run the code and encourage you to use it only as a
reference, but if you must, here are the basic steps to process an app in dev mode:

1. Make sure you have Ruby and Java installed

2. Make sure you have Elasticsearch and Redis running

3. Run `bundle install`

4. Run `rails c`

5. Add a google account with `Account.create(:email => 'email', :password =>
   'password', :android_id => 'id')`. An android id can be generated with
   [Android Checkin](https://github.com/nviennot/android-checkin).

6. Running `Account.first_usable` should not block, but return something.

7. Run `Stack.process_app(:app_id => 'com.facebook.katana')`.

8. You should see the facebook app repo in the `repos` directory.

---

If you want to go in production and launch the crawler, you can use the
[PlayDrone Kitchen](https://github.com/nviennot/playdrone-kitchen).

Follow the instructions, edit `deploy/settings.rb` and run `cap deploy:setup`
and `cap deploy`.

If everything works out (good luck), you'll be able to kick of jobs from a rails
console. Try `Stack.process_app(:app_id => 'com.facebook.katana')`, and
PlayDrone should discover at least half of the market by looking at related
apps. Note that to increase the throughput, you may need to add more Google accounts.

Here's what you can expect to see once everything is running in the graphite dashboard:

![Dashboard](http://i.imgur.com/8FdxRmo.png)

---

![GET ALL THE APPS!](http://i.imgur.com/r9t8uDx.jpg)

PlayDrone is released under the MIT license.
