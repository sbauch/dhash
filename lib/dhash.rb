require 'dhash/version'
require 'RMagick'

module Dhash extend self
  def hamming(a, b)
    (a^b).to_s(2).count('1')
  end

  def calculate(image, hash_size = 8)
    unless image.is_a? Magick::Image
      image = Magick::Image.read(file).first
    end
    image = image.quantize(256, Magick::Rec601LumaColorspace, Magick::NoDitherMethod, 8)
    image = image.resize!(hash_size + 1, hash_size)

    difference = []

    hash_size.times do |row|
      hash_size.times do |col|
        pixel_left  = image.pixel_color(col, row).intensity
        pixel_right = image.pixel_color(col + 1, row).intensity
        difference << (pixel_left > pixel_right)
      end
    end

    difference.map {|d| d ? 1 : 0 }.join('').to_i(2)
  end
end
