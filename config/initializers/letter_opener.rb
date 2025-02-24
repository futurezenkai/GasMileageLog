# config/initializers/letter_opener.rb
if Rails.env.development?
  LetterOpener.configure do |config|
    if config.respond_to?(:open_externally=)
      config.open_externally = false
    else
      Rails.logger.warn("LetterOpener configuration: open_externally option is not available, skipping setting.")
    end
  end
end
