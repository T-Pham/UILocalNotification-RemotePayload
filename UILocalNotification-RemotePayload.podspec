Pod::Spec.new do |s|
s.name             = 'UILocalNotification-RemotePayload'
s.version          = '1.0.3'
s.summary          = 'Gmail & Facebook Messenger-like notifications.'
s.description      = <<-DESC
UILocalNotification-RemotePayload provides a method to create UILocalNotification from remote notification payload. It is helpful because you have more control over local notifications than remote notifications. Please see the README for the details.
DESC
s.homepage         = 'https://github.com/T-Pham/UILocalNotification-RemotePayload'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Thanh Pham' => 'minhthanh@me.com' }
s.source           = { :git => 'https://github.com/T-Pham/UILocalNotification-RemotePayload.git', :tag => s.version.to_s }
s.ios.deployment_target = '8.2'
s.watchos.deployment_target = '2.0'
s.source_files = 'UILocalNotification-RemotePayload/*.swift'
s.frameworks = 'UIKit'
end
