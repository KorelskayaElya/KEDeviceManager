Pod::Spec.new do |s|
  s.name = 'KEDeviceManager'
  s.version = '1.0.0'
  s.license = 'MIT'
  s.summary = 'KEDeviceManager'
  s.homepage = 'https://github.com/KorelskayaElya/KEDeviceManager'
  s.authors = { 'KorelskayaElya' => 'korelskaya2000@mail.ru' }

  s.source = { :git => 'https://github.com/KorelskayaElya/KEDeviceManager', :tag => s.version.to_s }
  s.source_files = 'Sources/*.swift'
  s.swift_version = '5.0'
  s.platform = :ios, '12.0'


end