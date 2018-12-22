Pod::Spec.new do |s|
  s.name             = 'Model2App'
  s.version          = '0.1.1'
  s.summary          = 'Turn your Swift data model into a working CRUD app.'
  s.homepage         = 'https://github.com/q-mobile/model2app'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Karol Kulesza' => 'karol@q-mobile.it' }
  s.source           = { :git => 'https://github.com/q-mobile/Model2App.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/QMobileIT'
  s.ios.deployment_target = '11.0'
  s.source_files = 'Model2App/Source/**/*.{swift,h,m}'
  s.exclude_files = 'Model2App/Source/Frameworks/**/*'
  s.resources = 'Model2App/Source/Resources/**/*'
  s.swift_version = '4.2'
  s.dependency 'RealmSwift', '~> 3.7.5'
end
