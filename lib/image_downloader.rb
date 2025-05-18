# frozen_string_literal: true

require "open-uri"
require "tempfile"
require "openssl"

module ImageDownloader
  # Downloads an image from a URL and attaches it to a record's ActiveStorage association
  def self.attach_image_from_url(record, url, attachment_name = :avatar)
    file = URI.open(url, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE)
    record.send(attachment_name).attach(
      io: file,
      filename: File.basename(URI.parse(url).path),
      content_type: file.content_type
    )
  rescue => e
    puts "Failed to attach image: #{e.message}"
  end
end
