
Pod::Spec.new do |spec|
  spec.name         = "AdeonaSDK"
  spec.version      = "1.0.1"
  spec.summary      = "A short description of AdeonaSDK."
  spec.description  = "AdeonaADK is an advertisement framework"
  spec.homepage     = "http://EXAMPLE/AdeonaSDK"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "nirav vavadiya" => "nirav@muve.com.au" }
   spec.platform     = :ios, "10.0"
  spec.source       = { :git => "https://github.com/UnikworkEmp/AdeonaSDK.git", :tag => "1.0.1" }
  spec.source_files  = "AdeonaSDK/*"
  spec.swift_version = "5.0"
end
