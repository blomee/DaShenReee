# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'
use_frameworks!
inhibit_all_warnings!   #解决忽略引入库的所有警告

# pod update --verbose --no-repo-update

target 'DaShen' do

  # Swfit网络请求
  pod 'Alamofire'
  # OC
  pod 'AFNetworking'
  
  # 布局
  pod 'SnapKit'   #swift版本
  pod 'JXSegmentedView'   #swift 版本

  # 上下拉刷新
  pod 'MJRefresh'
  
  # 模型
  pod 'KakaJSON'
  pod 'Kingfisher'
  pod 'Then'
  pod 'Toast-Swift'
  pod 'SDWebImage'
  
  
#  pod 'MBProgressHUD', '~> 1.2.0'
#pod 'MBProgressHUD+JDragon'

  pod 'LookinServer', :configurations => ['Debug']



end







# ********** 一份Cocoapods支持多个target **********
# ********** https://www.jianshu.com/p/6c13813b8beb **********

#source 'https://github.com/CocoaPods/Specs.git'
#platform :ios, '9.0'
##use_frameworks!     #动态库 和 静态库区别 Swift 必须使用
#
#targetsArray = ['A项目', 'B项目', 'C项目', 'D项目']
#
#targetsArray.each do |t|
#    target t do
#        pod 'AFNetworking'
#        pod 'Masonry'
#
#    end
#end

