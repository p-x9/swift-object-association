Pod::Spec.new do |s|

  s.name         = "ObjectAssociation"
  s.version      = "0.1.0"
  s.summary      = "A swift library for associating objects as properties with reference type objects."

  s.description  = <<-DESC
  A swift library for associating objects as properties with reference type objects.

  It works in the same way as objc_getAssociatedObject/objc_setAssociatedObject. However, this library can also be used on Linux platforms and other platforms that do not run the Objective-C runtime.
                   DESC

  s.homepage     = "https://github.com/p-x9/swift-object-association"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "p-x9" => "https://github.com/p-x9" }

  s.ios.deployment_target = "12.0"
  s.tvos.deployment_target = "12.0"
  s.osx.deployment_target = "10.13"
  s.watchos.deployment_target = "4.0"

  s.source       = { :git => "https://github.com/p-x9/swift-object-association.git", :tag => "#{s.version}" }

  #s.source_files  = 'Sources/ObjectAssociation/**/*.{c,h,m,swift}'
  s.swift_versions = "5.9"
  s.compiler_flags = '-std=c++17'


  s.subspec 'ObjectAssociation' do |ss|
    ss.dependency "#{s.name}/ObjectAssociationRuntime"
    ss.source_files  = 'Sources/ObjectAssociation/**/*.{c,h,m,swift}'
  end


  s.subspec 'ObjectAssociationRuntime' do |ss|
    ss.dependency "#{s.name}/ObjectAssociationRuntimeC"
    ss.source_files  = 'Sources/ObjectAssociationRuntime/**/*.{c,h,m,swift}'
  end


  s.subspec 'ObjectAssociationRuntimeC' do |ss|
    ss.dependency "#{s.name}/SwiftRetain"
    ss.source_files  = 'Sources/ObjectAssociationRuntimeC/**/*.{c,h,cpp,hpp,m,swift}'
    ss.private_header_files = 'Sources/ObjectAssociationRuntimeC/include/*.hpp'
  end


  s.subspec 'SwiftRetain' do |ss|
    ss.source_files  = 'Sources/SwiftRetain/**/*.{c,h,m,swift}'
  end


end
