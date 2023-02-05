require 'opencv'
include OpenCV

# Load the human, dog and license plate cascade classifiers from the XML files
human_detector = CvHaarClassifierCascade::load('./haarcascade_fullbody.xml')
dog_detector = CvHaarClassifierCascade::load('./haarcascade_dog.xml')
plate_detector = CvHaarClassifierCascade::load('./haarcascade_plate.xml')

# Load the input image
img = IplImage.load('./image.jpg')

# Keep track of the objects detected in the image
detected_objects = []

# Detect humans in the image
human_detector.detect_objects(img).each do |region|
  # Draw a green rectangle around the detected human
  img.rectangle! region.top_left, region.bottom_right, :color => CvColor::Green
  # Add the detected object to the list
  detected_objects << { type: "human", region: region }
end

# Detect dogs in the image
dog_detector.detect_objects(img).each do |region|
  # Draw a blue rectangle around the detected dog
  img.rectangle! region.top_left, region.bottom_right, :color => CvColor::Blue
  # Add the detected object to the list
  detected_objects << { type: "dog", region: region }
end

# Detect license plates in the image
plate_detector.detect_objects(img).each do |region|
  # Draw a red rectangle around the detected license plate
  img.rectangle! region.top_left, region.bottom_right, :color => CvColor::Red
  # Add the detected object to the list
  detected_objects << { type: "license plate", region: region }
end

# Display the image
window = GUI::Window.new 'Object recognition'
window.show img
GUI::wait_key

# Log the detected objects
puts "Detected objects:"
detected_objects.each do |obj|
  puts "- #{obj[:type]} at top-left: (#{obj[:region].top_left.x}, #{obj[:region].top_left.y}) and bottom-right: (#{obj[:region].bottom_right.x}, #{obj[:region].bottom_right.y})"
end

# Write the log to a file
File.open("detected_objects.log", "w") do |f|
  f.puts "Detected objects:"
  detected_objects.each do |obj|
    f.puts "- #{obj[:type]} at top-left: (#{obj[:region].top_left.x}, #{obj[:region].top_left.y}) and bottom-right: (#{obj[:region].bottom_right.x}, #{obj[:region].bottom_right.y})"
  end
end
