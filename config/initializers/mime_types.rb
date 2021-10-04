# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
Mime::Type.register "text/richtext", :rtf
Mime::Type.register "application/msword", :doc
Mime::Type.register "application/msword", :dot
Mime::Type.register "application/vnd.openxmlformats-officedocument.wordprocessingml.document", :docx
Mime::Type.register "application/vnd.openxmlformats-officedocument.wordprocessingml.template", :dotx
Mime::Type.register "application/vnd.ms-word.document.macroEnabled.12", :docm
Mime::Type.register "application/vnd.ms-word.template.macroEnabled.12", :dotm
Mime::Type.register "application/pdf", :pdf
Mime::Type.register_alias 'text/html', RailsAmp.default_format
