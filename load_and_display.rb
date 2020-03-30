require 'opencv'
include OpenCV

if ARGV.size.zero?
  puts "Usage: ruby #{__FILE__} ImageToLoadAndDisplay"
  exit
end

begin
  # 画像のロードに OpenCV::CvMat クラスを使用する
  # see: https://www.rubydoc.info/gems/ruby-opencv/OpenCV/CvMat
  image = CvMat.load(ARGV[0], CV_LOAD_IMAGE_COLOR)
  # image = CvMat.load(ARGV[0], 0)
  # CV_LOAD_IMAGE_COLOR == 1
  # 第2引数に0を指定した場合 -> Return a grayscale image.
rescue
  puts 'Could not open or find the image.'
end

# GUI操作に OpenCV::GUI を使用
# https://www.rubydoc.info/gems/ruby-opencv/OpenCV/GUI

# Create a window for display.
window = GUI::Window.new("OpenCV sample")

# Show our image inside it.
window.show(image)

# Wait for a keystroke in the window.
GUI::wait_key
