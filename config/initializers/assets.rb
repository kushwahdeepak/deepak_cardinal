Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w(
  jquery_init.js
)
Rails.application.config.assets.precompile << /\.(?:svg|eot|woff|ttf)\z/
%w(eot svg ttf woff woff2).each do |ext|
Rails.application.config.assets.precompile += %w( rails_admin/fontawesome-webfont.woff2 )
end
