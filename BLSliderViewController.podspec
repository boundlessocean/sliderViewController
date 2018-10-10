Pod::Spec.new do |s|
s.name = 'BLSliderViewController'
s.version = '1.0.2'
s.license = { :type => "MIT", :file => "LICENSE"}
s.summary = 'A BLSliderViewController on iOS.'
s.homepage = 'https://github.com/boundlessocean/sliderViewController'
s.authors = { 'ocean' => 'boundlessocean@icloud.com' }
s.source = { :git => 'https://github.com/boundlessocean/sliderViewController.git',  :tag => s.version.to_s }
s.ios.deployment_target = '8.0'
s.source_files = 'BLSliderViewController/*.{h,m}'
end

