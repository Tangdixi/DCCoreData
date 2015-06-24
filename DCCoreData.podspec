Pod::Spec.new do |s|

  s.name         = "DCCoreData	"
  s.version      = "1.0"
  s.summary      = "Use Core Data Simply"

  s.homepage     = "https://github.com/Tangdixi/DCCoreData" 

  s.license      = { 
	:type => 'MIT', 
	:text => 'The DCCoreData use the MIT license' 
  }

  s.author             = { "Tangdixi" => "Tangdixi@gmail.com" }

  s.platform     = :ios, '7.0'

  s.source       = { 
	:git => "https://github.com/Tangdixi/DCCoreData.git", 
	:tag => "1.0"
  }

  s.source_files  = 'DCCoreData/*.{h,m}'

  s.frameworks = 'Foundation','UIKit','CoreData'

  s.requires_arc = true

end
