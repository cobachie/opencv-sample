require 'opencv'

include OpenCV

def detect_red_color(image)
  # HSV色空間に変換
  hsv = OpenCV::BGR2HSV(image)

  # 赤色(値域1)を抽出
  hsv_min = CvScalar.new(0,45,0)
  hsv_max = CvScalar.new(30,255,255)
  mask1 = hsv.in_range(hsv_min, hsv_max)

  # 赤色(値域2)を抽出
  hsv_min = CvScalar.new(150,30,0)
  hsv_max = CvScalar.new(179,255,255)
  mask2 = hsv.in_range(hsv_min, hsv_max)

  # 赤色領域のマスク
  mask = mask1 + mask2

  mask.save 'mask_red.png'
  mask = IplImage::load 'mask_red.png'
  masked_image = image.and mask
end

def detect_green_color(image)
  # HSV色空間に変換
  hsv = BGR2HSV image

  # 緑色を抽出
  hsv_min = CvScalar.new(30, 45, 0)
  hsv_max = CvScalar.new(90,255,255)
  mask = hsv.in_range(hsv_min, hsv_max)
  mask.save 'mask_green.png'

  mask = IplImage::load 'mask_green.png'
  masked_image = image.and mask
end

# 画像を読み込む
input_filename = 'images/hotel.JPG'
image = CvMat.load(input_filename)

# 色検出（赤、緑、青）
red_masked_image = detect_red_color image
green_masked_image = detect_green_color image
masked_image = red_masked_image.add green_masked_image
masked_image.save 'masked_image.png'

# 色を抽出した画像を二値化
gray = BGR2GRAY masked_image

# 特異点を抽出
corners = gray.good_features_to_track(0.2, 10, :use_harris => true)

image2 = image.clone
font = CvFont.new :script_complex, hscale: 0.3, vscale: 0.3
corners.each do |point|
  image2.circle! point, 5, color: CvColor::Red, thickness: 1, line_type: :aa
  text = "#{point&.x}:#{point&.y}"
  text_point = CvPoint.new(point.x - 20, point.y - 5)
  image2.put_text! text, text_point, font, CvColor::Black
end

image2.save 'image.png'
