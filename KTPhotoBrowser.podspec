Pod::Spec.new do |s|
  s.name         = "KTPhotoBrowser"
  s.version      = "0.0.1"
  s.summary      = "A lightweight photo browser library for the iPhone and iPod touch that looks and behaves like the iPhone Photos app."
  s.homepage     = "https://github.com/kirbyt/KTPhotoBrowser"
  s.license      = "MIT"
  s.author       = "Kirby Turner"
  s.source       = { :git => "https://github.com/kirbyt/KTPhotoBrowser.git", :commit => "8da811aa1e6b153315334e98abb345a3a67126ad" }
  s.platform     = :ios, "3.0"
  s.source_files  = "KTPhotoBrowser/**/*.{h,m}"
  s.requires_arc = false
end
