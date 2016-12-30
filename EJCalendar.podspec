#
#  Be sure to run `pod spec lint Calendar.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

s.name         = "EJCalendar"
s.version      = "0.0.1"
s.summary      = "a calendar for choosing time interval"
s.description  = <<-DESC
    A calendar which you can use to choose a time interval。
DESC
s.homepage     = "https://github.com/xiachengaa/Calendar"
s.license      = "MIT"
s.author       = { "xiacheng" => "15757172115@163.com" }
s.platform     = :ios
s.source       = { :git => "https://github.com/xiachengaa/Calendar.git", :tag => "0.0.1" }
s.source_files  = "CalendarViewController","CalendarViewController/*.{h，m}"
s.public_header_files = "CalendarViewController/CalendarViewController.h","CalendarViewController/CalendarView.h","CalendarViewController/CalendarDelegate.h"
s.requires_arc = true

end
