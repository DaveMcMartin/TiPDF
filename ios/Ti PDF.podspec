
Pod::Spec.new do |s|

    s.name         = "Ti PDF"
    s.version      = "2.3.2"
    s.summary      = "Titanium module to handle PDF generation/edition on iOS using Quartz 2D for fast rendering and good quality."
  
    s.description  = <<-DESC
                     The Ti PDF Titanium module.
                     DESC
  
    s.homepage     = "https://example.com"
    s.license      = { :type => "MIT", :file => "LICENSE" }
    s.author       = 'Dave McMartin'
  
    s.platform     = :ios
    s.ios.deployment_target = '9.0'
  
    s.source       = { :git => "https://github.com/DaveKun/TiPDF" }
    
    s.ios.weak_frameworks = 'UIKit', 'Foundation'

    s.ios.dependency 'TitaniumKit'
  
    s.public_header_files = 'Classes/*.h'
    s.source_files = 'Classes/*.{h,m}'
  end