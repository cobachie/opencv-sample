require 'opencv'
require './display_window'

include OpenCV
include DisplayWindow

# 赤、青、緑を検出する
# ref: https://algorithm.joho.info/programming/python/opencv-color-detection/

def display(image)
  window = GUI::Window.new("OpenCV sample")
  window.show(image)
  GUI::wait_key
end

def detect_red_color(image)
  # HSV色空間に変換
  hsv = OpenCV::BGR2HSV(image)

  # 赤色のHSVの値域1
  hsv_min = OpenCV::CvScalar.new(0,45,0)
  hsv_max = OpenCV::CvScalar.new(30,255,255)
  red_mask1 = hsv.in_range(hsv_min, hsv_max)

  # 赤色のHSVの値域2
  hsv_min = OpenCV::CvScalar.new(150,30,0)
  hsv_max = OpenCV::CvScalar.new(179,255,255)
  red_mask2 = hsv.in_range(hsv_min, hsv_max)

  # 赤色領域のマスク
  mask = red_mask1 + red_mask2

  # マスキング処理
  # masked_image = image.and image, mask

  # NOTE:
  # 上記だと bitwise_and が正しく計算されない。
  # 一度 mask 画像を保存して、それを利用して bitwise_and することで意図した結果を得られた。
  mask.save 'mask_red.png'
  mask = OpenCV::IplImage::load 'mask_red.png'
  masked_image = image.and mask
end

def detect_green_color(image)
  # HSV色空間に変換
  hsv = OpenCV::BGR2HSV(image)

  # 緑色のHSVの値域
  # hsv_min = OpenCV::CvScalar.new(30, 64, 0)
  hsv_min = OpenCV::CvScalar.new(30, 30, 0) # Gの閾値を下げた
  hsv_max = OpenCV::CvScalar.new(90,255,255)
  mask = hsv.in_range(hsv_min, hsv_max)

  # マスキング処理
  # masked_image = image.and image, mask

  # NOTE:
  # 上記だと bitwise_and が正しく計算されない。
  # 一度 mask 画像を保存して、それを利用して bitwise_and することで意図した結果を得られた。
  mask.save 'mask_green.png'
  mask = OpenCV::IplImage::load 'mask_green.png'
  masked_image = image.and mask
end

# 入力画像の読み込み
input_filename = 'images/hotel.JPG'

image = OpenCV::IplImage::load input_filename, OpenCV::CV_LOAD_IMAGE_COLOR

# 色検出（赤、緑、青）
red_masked_image = detect_red_color(image)
green_masked_image = detect_green_color(image)

masked_image = red_masked_image.add green_masked_image

# 結果画像を保存
masked_image.save "masked_image.png"

# display masked_image
