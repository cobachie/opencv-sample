module DisplayWindow
  def display(image)
    window = GUI::Window.new("OpenCV sample")
    window.show(image)
    GUI::wait_key
  end
end
