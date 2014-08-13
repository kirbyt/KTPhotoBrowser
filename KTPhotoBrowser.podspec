Pod::Spec.new do |s|
  s.name         = "KTPhotoBrowser"
  s.version      = "0.0.2"
  s.summary      = "A lightweight photo browser library for the iPhone and iPod touch that looks and behaves like the iPhone Photos app."
  s.homepage     = "https://github.com/kirbyt/KTPhotoBrowser"
  s.license      = "MIT"
  s.author       = "Kirby Turner"
  s.source       = { :git => "https://github.com/mtlhd/KTPhotoBrowser.git", :tag => "0.0.2" }
  s.platform     = :ios, "3.0"
  s.source_files  = "src/KTPhotoBrowser/**/*.{h,m}"
  s.requires_arc = false
end
