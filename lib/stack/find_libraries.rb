class Stack::FindLibraries < Stack::Base
  class << self
    attr_accessor :lib_tree, :rev_map
  end
  self.lib_tree = {}
  self.rev_map = {}

  def self.lib(libname, paths=nil)
    paths = libname unless paths
    paths = [*paths]

    paths.each do |path|
      components = path.split('.')[0..-2]
      last_component = path.split('.')[-1]

      components = ['src', *components] # quick hack

      last = components.reduce(self.lib_tree) do |tree, component|
        raise "Lib conflict: #{path} on #{component} (#{tree})" unless tree.is_a? Hash
        tree[component] ||= {}
      end
      raise "Lib conflict: #{path} on #{last_component} (#{last})" unless last.is_a? Hash
      raise "Lib conflict: #{path} on #{last_component} (#{last[last_component]})" if last[last_component]
      last[last_component] = libname
    end

    rev_map[libname] = paths
  end

  def match(libs, repo, src_tree, lib_hash) src_tree.each_tree do |tree| name = tree[:name]
      next unless lib_hash[name]

      if lib_hash[name].is_a? Hash
        match(libs, repo, repo.lookup(tree[:oid]), lib_hash[name])
      else
        libs << lib_hash[name]
      end
    end
  end

  def call(env)
    libs = []
    match(libs, env[:src_git].repo, env[:src_git].committed_tree, self.class.lib_tree)
    env[:app].library = libs.uniq

    @stack.call(env)
  end

  def self.matchers_for(lib)
    ([*rev_map[lib]] + [lib]).compact.uniq
  end

  lib 'Google Ads',                             %w(com.google.ads
                                                   com.admob
                                                   com.adwhirl)
  lib 'Android SDK Lint',                       %w(android.annotation)
  lib 'Android Support',                        %w(android.support)
  lib 'Facebook SDK',                           %w(com.facebook.android)
  lib 'Apache Commons',                         %w(org.apache.commons)
  lib 'PhoneGap',                               %w(com.phonegap)
  lib 'Twitter4J',                              %w(twitter4j)
  lib 'Google Analytics',                       %w(com.google.android.apps.analytics
                                                   com.google.analytics
                                                   com.google.android.gms.analytics)
  lib 'Flurry',                                 %w(com.flurry)
  lib 'Apache HttpComponents',                  %w(org.apache.http)
  lib 'Millennial Media Ads',                   %w(com.millennialmedia.android)
  lib 'Gson',                                   %w(com.google.gson)
  lib 'BugSense',                               %w(com.bugsense.trace)
  lib 'Apache Cordova',                         %w(org.apache.cordova)
  lib 'Google InApp Billing',                   %w(com.android.vending.billing)
  lib 'Google Cloud to Device',                 %w(com.google.android.c2dm)
  lib 'ZXing barcode',                          %w(com.google.zxing)
  lib 'Mobclix',                                %w(com.mobclix.android)
  lib 'Acra',                                   %w(org.acra)
  lib 'AirPush',                                %w(com.airpush.android)
  lib 'InMobi',                                 %w(com.inmobi)
  lib 'Apache James',                           %w(org.apache.james)
  lib 'Google Data Lib',                        %w(com.google.gdata)
  lib 'Jackson',                                %w(org.codehaus.jackson)
  lib 'OAuth Signpost',                         %w(oauth.signpost)
  lib 'Google Cloud Messaging',                 %w(com.google.android.gcm)
  lib 'MobFox',                                 %w(com.mobfox
                                                   com.adsdk.sdk)
  lib 'Jsoup',                                  %w(org.jsoup)
  lib 'Paypal',                                 %w(com.paypal.android)
  lib 'LeadBolt',                               %w(com.Leadbolt)
  lib 'LeadBolt stuff?',                        %w(com.pad.android)
  lib 'ActionBarSherlock',                      %w(com.actionbarsherlock)
  lib 'Protocol Buffer',                        %w(com.google.protobuf)
  lib 'Urban Airship Push',                     %w(com.urbanairship
                                                   src.com.urbanairship)
  lib 'Adobe Air',                              %w(com.adobe.air)
  lib 'Jumptap',                                %w(com.jumptap)
  lib 'Android Picker widget',                  %w(kankan.wheel)
  lib 'JSON.org',                               %w(org.json)
  lib 'Adfonic',                                %w(com.adfonic)
  lib 'Guava Core Libs',                        %w(com.google.common)
  lib 'OrmLite',                                %w(com.j256.ormlite)
  lib 'Google stuff',                           %w(com.google.android.googleapps
                                                   com.google.android.googlelogin
                                                   com.google.android.providers)
  lib 'HuntMads',                               %w(com.huntmads.admobadaptor)
  lib 'ViewPagerIndicator (ActionBarSherlock)', %w(com.viewpagerindicator)
  lib 'W3C DOM',                                %w(org.w3c.dom)
  lib 'Jaxen',                                  %w(org.jaxen)
  lib 'Apperhand (Malware)',                    %w(com.apperhand)
  lib 'Google Play License',                    %w(com.android.vending.licensing)
  lib 'Android ActionBar',                      %w(com.markupartist.android.widget)
  lib 'PushWoosh',                              %w(com.arellomobile.android.push)
  lib 'Appcelerator Titanium (private)',        %w(android.widget)
  lib 'SendDroid',                              %w(com.senddroid)
  lib 'SLF4J',                                  %w(org.slf4j)
  lib 'Appcelerator Titanium',                  %w(org.appcelerator.titanium
                                                   ti.modules.titanium)
  lib 'Appcelerator Titanium (engine?)',        %w(org.appcelerator.kroll)
  lib 'AndEngine Live-Wallpaper ??',            %w(net.rbgrn)
  lib 'XML Pull',                               %w(org.xmlpull.v1)
  lib 'XML Pull Parser',                        %w(org.kxml2)
  lib 'GNU Kawa',                               %w(kawa gnu.kawa gnu.mapping gnu.lists gnu.xml
                                                   gnu.text gnu.bytecode gnu.commonlisp gnu.expr
                                                   gnu.q2.lang gnu.ecmascript gnu.math)
  lib 'App Inventor',                           %w(com.google.youngandroid
                                                   com.google.appinventor.components)
  lib 'FMOD',                                   %w(org.fmod)
  lib 'Bizness Apps',                           %w(com.biznessapps)
  lib 'libGDX',                                 %w(com.badlogic.gdx)
  lib 'Unity3D',                                %w(com.unity3d.player)
  lib 'PushWoosh (tests)',                      %w(com.pushwoosh.test.plugin.pushnotifications)
  lib 'Android MapView Balloons',               %w(com.readystatesoftware.mapviewballoons)
  lib 'AndEngine',                              %w(org.anddev.andengine
                                                   org.andengine)

  lib 'kSOAP 2',                                %w(org.ksoap2 org.kobjects)
  lib 'OpenFeint',                              %w(com.openfeint)
  lib 'Andromo',                                %w(com.andromo.widget)
  lib 'Google API',                             %w(com.google.api.client)
  lib 'Smaato',                                 %w(com.smaato.SOMA)
  lib 'Mobile by Conduit',                      %w(www.conduit.app)
  lib 'Scoreloop',                              %w(com.scoreloop.client.android)
  lib 'RestClient',                             %w(com.roobit.restkit)

  lib 'com.google.mygson'
  lib 'jp.Adlantis.Android'
  lib 'com.appbrain'
  lib 'cmn'
  lib 'com.loopj.android.http'
  lib 'iBuildApp', %w(com.appbuilder)

  lib 'TapJoy', %w(com.tapjoy)
  lib 'RevMob', %w(com.revmob)

  lib 'com.inneractive.api.ads'
  lib 'com.google.myjson'
  lib 'Authorize.net', %w(net.authorize)
  lib 'com.mobclick.android'
  lib 'org.apache.harmony'
  lib 'jp.co.nobot.libAdMaker'
  lib 'com.chartboost.sdk'
  lib 'TapIt', %w(com.tapit)
  lib 'com.pontiflex.mobile'
  lib 'MoPub', %w(com.mopub.mobileads)
  lib 'com.ring.basic'
  lib 'org.mozilla.javascript'
  lib 'org.mozilla.classfile'
  lib 'com.adobe.flashplayer'
  lib 'android.opengl'
  lib 'com.commonsware.cwac'
  lib 'com.google.i18n.phonenumbers'
  lib 'mediba.ad.sdk.android'
  lib 'AppLovin', %w(com.applovin)
  lib 'javax.activation'
  lib 'com.google.android.vending.licensing'
  lib 'Corona SDK', %w(com.ansca.corona)
  lib 'jp.co.imobile.android'
  lib 'com.qbiki'
  lib 'com.sun.activation.registries'
  lib 'com.sun.mail'
  lib 'javax.mail'
  lib 'com.skyd.core'
  lib 'com.LogiaGroup.PayCore'
  lib 'com.conduit.app.pgplugins.purchase'
  lib 'com.skyd.bestpuzzle'
  lib 'com.cauly.android.ad'
  lib 'net.nend.android'
  lib 'com.onbarcode.barcode.android'
  lib 'com.jasonkostempski.android.calendar'
  lib 'myjava.awt.datatransfer'
  lib 'zongfuscated'
  lib 'com.zong.android.engine'
  lib 'com.adknowledge.superrewards'
  lib 'com.google.devtools.simple'
  lib 'com.andfor.basic'
  lib 'com.appmakr'
  lib 'com.zestadz.android'
  lib 'net.sourceforge.zbar'
  lib 'anywheresoftware.b4a'
  lib 'com.dreamstep.webWidget'
  lib 'winterwell.jtwitter'
  lib 'com.mdotm.android.ads'
  lib 'nl.siegmann.epublib'
  lib 'com.greystripe.android.sdk'
  lib 'org.anddev.progressmonitor'
  lib 'com.crittercism'
  lib 'org.achartengine'
  lib 'org.mcsoxford.rss'
  lib 'com.adobe.fre'
  lib 'jp.co.cyberagent'
  lib 'crittercism.android'
  lib 'lgpl.haustein'
  lib 'com.feedback'
  lib 'com.adobe.flashruntime.air'
  lib 'com.adobe.flashruntime.shared'
  lib 'com.android.vending.expansion'
  lib 'com.google.android.vending.expansion'
  lib 'com.androidplot'
  lib 'com.github.droidfu'
  lib 'com.handmark.pulltorefresh.library'
  lib 'com.everbadge.uprise'
  lib 'com.prime31'
  lib 'com.vdopia.client.android'
  lib 'com.bcfg.adsclient'
  lib 'pdftron'
  lib 'com.appmk.book'
  lib 'net.daum.adam.publisher'
  lib 'android.net'
  lib 'com.nostra13.universalimageloader'
  lib 'net.youmi.android'
  lib 'org.cocos2d'
  lib 'cn.domob.android'
  lib 'com.google.iap'
  lib 'com.omniture'
  lib 'com.papaya'

  # TODO merge to com.umeng
  lib 'Umeng', %w(com.umeng.common
                  com.umeng.analytics
                  com.umeng.fb)

  lib 'com.heyzap.sdk'
  lib 'com.androidquery'
  lib 'org.simpleframework.xml'
  lib 'com.quipper.a'
  lib 'com.google.inject'
  lib 'com.naef.jnlua'
  lib 'com.esotericsoftware'
  lib 'org.metalev.multitouch'
  lib 'javax.microedition'
  lib 'org.joda.time'
  lib 'org.htmlcleaner'
  lib 'de.madvertise.android.sdk'
  lib 'org.scribe'
  lib 'net.daum.mobilead'
  lib 'com.admarvel.android.ads'
  lib 'com.tapfortap'
  lib 'com.sms.basic'
  lib 'greendroid'
  lib 'roboguice'
  lib 'net.wigle.wigleandroid'
  lib 'org.osmdroid'
  lib 'com.baidu'
  lib 'org.jdom'
  lib 'com.wooboo.adlib_android'
  lib 'org.cocos2dx'
  lib 'com.nullwire.trace'
  lib 'com.socialize'
  lib 'com.android.internal.telephony'
  lib 'org.vudroid.pdfdroid'
  lib 'com.vercoop'
  lib 'microsoft.mappoint'
  lib 'org.dom4j'
  lib 'com.appmk.magazine'
  lib 'com.polites.android'
  lib 'Amazon In-App Purchasing', %w(com.amazon.inapp.purchasing)
  lib 'android.webkit'
  lib 'com.poqop.document'
  lib 'org.ccil.cowan.tagsoup'
  lib 'com.spoledge.aacdecoder'
  lib 'com.AmaxSoftware.lwpEngine'
  lib 'net.robotmedia.billing'
  lib 'com.madhouse.android.ads'
  lib 'com.localytics.android'
  lib 'com.readystatesoftware.maps'
  lib 'com.restfb'
  lib 'com.moolah'
  lib 'com.cyrilmottier.android.greendroid'
  lib 'android.util'
  lib 'javax.annotation'
  lib 'com.ngigroup'
  lib 'org.ormma'
  lib 'com.qwapi.adclient'
  lib 'org.apache.thrift'
  lib 'com.milkmangames.extensions.android'
  lib 'com.adwo.adsdk'
  lib 'com.eightbitmage.gdxlw'
  lib 'com.livestream'
  lib 'com.comscore'
  lib 'com.mobileroadie'
  lib 'biz.source_code'
  lib 'com.parse'
  lib 'com.playhaven'
  lib 'com.vpon.adon.android'
  lib 'com.googlecode.autoandroid'
  lib 'com.qualcomm.QCAR'
  lib 'fix.android.opengl'
  lib 'com.fasterxml.jackson'
  lib 'com.mixpanel.android'
  lib 'rajawali'
  lib 'com.Localytics.android'
  lib 'yuku.ambilwarna'
  lib 'de.actsmartware.appcreator'
  lib 'junit'
  lib 'com.kuguo'
  lib 'com.sonyericsson.zoom'
  lib 'it.sephiroth.android.library.imagezoom'
  lib 'net.londatiga.android'
  lib 'com.sonicnotify.sdk'
  lib 'mono'
  lib 'opentk'
  lib 'org.springframework'
  lib 'com.appyet.mobile'
  lib 'com.adserver'
  lib 'net.oauth'
  lib 'com.bitzio.wrapper'
  lib 'com.thoughtworks.xstream'
  lib 'com.medialets'
  lib 'com.appsgeyser'
  lib 'com.wooboo.download'
  lib 'com.wiyun.ad'
  lib 'com.amazonaws'
  lib 'org.junit'
  lib 'javazoom.jl'
  lib 'com.ibuildapp.romanblack.WebPlugin'
  lib 'com.sun.lwuit'
  lib 'com.appexpress'
  lib 'com.qualcomm.ar.pl'
  lib 'com.subsplash'
  lib 'org.jboss.netty'
  lib 'com.admogo'
  lib 'com.adnotify'
  lib 'org.apache.log4j'
  lib 'com.tristit'
  lib 'com.gamesalad'
  lib 'com.google.checkout.sdk'
  lib 'android.runtime'
  lib 'com.devsmart.android.ui'
  lib 'com.harrison.lee.twitpic4j'
  lib 'com.bumptech.bumpapi'
  lib 'au.com.bytecode.opencsv'
  lib 'com.couxin.CouXinEngine'
  lib 'org.hamcrest'
  lib 'com.waps'
  lib 'com.tencent.mobwin'
  lib 'fi.harism.curl'
  lib 'com.rosaloves.bitlyj'
  lib 'net.openudid.android'
  lib 'com.drew'
  lib 'com.trid.tridad'
  lib 'MobWin'
  lib 'com.adview'
  lib 'net.adways.appdriver.sdk'
  lib 'org.xmlrpc.android'
  lib 'ru.perm.kefir.bbcode'
  lib 'com.vbulletin'
  lib 'com.dropbox'
  lib 'com.keyes.youtube'
  lib 'com.sellaring.sdk'
  lib 'net.sourceforge.jtpl'
  lib 'com.twitterapime'
  lib 'com.rtst.widget.actionbar'
  lib 'com.tencent.lbsapi'
  lib 'impl.android.com.twitterapime'
  lib 'com.zemariamm.appirater'
  lib 'com.twmacinta.util'
  lib 'jp.co.microad.smartphone.sdk'
  lib 'com.axhive'
  lib 'LBSAPIProtocol'
  lib 'net.htmlparser.jericho'
  lib 'com.qq.jce.wup'
  lib 'com.nexage.android'
  lib 'com.twitter.android'
  lib 'org.apache.android.mail'
  lib 'com.twmacinta.io'
  lib 'mobi.vserv.android.adengine'
  lib 'com.feelingk.iap'
  lib 'com.shoutem'
  lib 'com.airkast'
  lib 'com.janrain.android.engage'
  lib 'com.smaato.soma'
  lib 'org.taptwo.android.widget'
  lib 'opentk_1_0'
  lib 'com.qq.taf.jce'
  lib 'com.borismus.webintent'
  lib 'net.sf.jtpl'
  lib 'com.innerActive.ads'
  lib 'com.ibm.mqtt'
  lib 'com.weibo'
  lib 'com.mobisage.sns'
  lib 'weibo4android'
  lib 'fi.foyt.foursquare'
  lib 'com.joelapenna.foursquare'
  lib 'com.attrecto.eventmanager'
end
