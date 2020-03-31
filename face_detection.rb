require 'opencv'

if ARGV.length < 2
  puts "Usage: ruby #{__FILE__} [input image path] [output image path]"
  exit 1
end

input_filename = ARGV[0]
output_filename = ARGV[1]

image = OpenCV::CvMat.load input_filename
# IplImage is subclass of CvMat. IplImageも使える
# see: https://www.rubydoc.info/gems/ruby-opencv/OpenCV/IplImage
# image = OpenCV::IplImage::load input_filename

# https://github.com/opencv/opencv/tree/master/data/haarcascades からコピー
# data/haarcascade_frontalface_alt.xml だと load error になる
# The node does not represent a user object (unknown type?) in function cvRead (OpenCV::CvStsError)　
# haar_xml_file = File.expand_path File.dirname(__FILE__), 'data/haarcascade_frontalface_alt.xml'
haar_xml_file = File.expand_path File.dirname(__FILE__), 'data/haarcascade_frontalface_default.xml'
detector = OpenCV::CvHaarClassifierCascade::load haar_xml_file

detector.detect_objects(image).each do |rect|
  # rect is OpenCV::CvAvgComp class (inherit CvRect)
  puts "detect!! : #{rect.top_left}, #{rect.top_right}, #{rect.bottom_left}, #{rect.bottom_right}"
  image.rectangle! rect.top_left, rect.bottom_right, :color => OpenCV::CvColor::Red
end

# 画像を保存する
image.save output_filename
