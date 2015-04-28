Pod::Spec.new do |s|
  s.name             = "HyperComments"
  s.version          = "1.0.1"
  s.summary          = "Shared libary for Rutube projects"
  s.description      = <<-DESC
                       Library allow use HyperComments service
                       DESC
  s.homepage         = "https://github.com/rutube/HyperComments"
  s.license          = 'MIT'
  s.author           = { "Juraldinio" => "juraldinio@gmail.com" }
  s.source           = { :git => "https://github.com/rutube/HyperComments.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'HyperCommentsCore/**/*'
  s.resource_bundles = {
  #  'RutubeSharedUtils' => ['Pod/Assets/*.png']
  }

  s.public_header_files = 'HyperCommentsCore/**/{HCMedia,HCUser,HCCommentsList,HCComment,HCStream,HyperCommentsCore,HyperCommentsConstants}.h'
  s.frameworks = 'Foundation'
  s.dependency 'AFNetworking', '~> 2.5'
end
