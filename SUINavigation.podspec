Pod::Spec.new do |s|
  s.name        = 'SUINavigation'
  s.version     = '1.11.0'
  s.summary     = 'Simple navigation framework for SwiftUI'
  s.homepage    = 'https://github.com/ozontech/SUINavigation'
  s.license     = {:type => "Attribution", :file => "LICENSE"}
  s.authors     = { 'Ozon Tech' => 'https://ozon.tech/' }

  s.swift_version = '5.7'
  s.ios.deployment_target = '12.0'

  s.source = {
    git: 'https://github.com/ozontech/SUINavigation.git',
    tag: s.version
  }
  s.source_files = [
     'Sources/**/*.swift'
  ]
end
