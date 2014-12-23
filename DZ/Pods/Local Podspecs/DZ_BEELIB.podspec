Pod::Spec.new do |s|
  s.name         = "DZ_BEELIB"
  s.version      = "0.0.2"
  s.summary      = "DZ Bee Framework is a rapid developemnt framework for iOS."
  s.description  = <<-DESC
    Bee Framework is a MVC Framework to develop iOS application. 
    It has pretty clear hieracy and signal based mechanism, also with cache and asynchonized networking methods in it.
  DESC
  s.homepage     = "https://github.com/Natoto/DZ_BEELIB.git"
  s.license      = 'MIT'
  s.platform     = :ios
  s.author       = { "nonato" => "huang_bo_2011@163.com"}
  s.source       = { :git => "https://github.com/Natoto/DZ_BEELIB.git", :tag => "0.0.1"}
  s.frameworks = 'CoreMedia', 'CoreVideo', 'AVFoundation', 'Security', 'SystemConfiguration', 'QuartzCore', 'MobileCoreServices', 'CFNetwork'
  s.vendored_libraries = 'services/**/*.a'
  s.library = 'z', 'xml2', 'sqlite3'

  s.subspec 'Core' do |sp|
    sp.resource  = 'services/**/*.{xml, bundle}'
    sp.source_files = 'framework/**/*.{h,m,mm}', 'services/**/*.{h,m,mm}', 'framework/vendor/*.{h,m}'
	sp.exclude_files = 'framework/vendor/{ASI,ZipArchive,FMDB,JSONKit,OpenUDID,Reachability,TouchXML}/**/*'
    sp.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libz, $(SDKROOT)/usr/include/libxml2', 'CLANG_CXX_LANGUAGE_STANDARD' => 'gnu++0x', 'CLANG_CXX_LIBRARY' => 'libstdc++', 'CLANG_WARN_DIRECT_OBJC_ISA_USAGE' => 'YES'}
    sp.requires_arc = false
    sp.dependency 'ASIHTTPRequest'
    sp.dependency 'Reachability'
    sp.dependency 'OpenUDID'
    sp.dependency 'ZipArchive'
    sp.dependency 'FMDB'
    sp.dependency 'TouchXML'
    sp.dependency 'JSONKit-NoWarning'
  end
  
end
