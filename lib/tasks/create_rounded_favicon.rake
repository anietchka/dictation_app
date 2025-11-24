namespace :assets do
  desc "Create rounded version of dictio_logo_plume.png"
  task create_rounded_favicon: :environment do
    require "image_processing/vips"

    input_path = Rails.root.join("app/assets/images/dictio_logo_plume.png")
    output_path = Rails.root.join("app/assets/images/dictio_logo_plume_rounded.png")

    unless File.exist?(input_path)
      puts "Error: #{input_path} not found"
      exit 1
    end

    begin
      # Read the image
      image = Vips::Image.new_from_file(input_path.to_s)

      # Get dimensions
      width = image.width
      height = image.height
      size = [ width, height ].min

      # Create a circular mask
      mask = Vips::Image.black(size, size)
      mask = mask.draw_circle([ 255, 255, 255 ], size / 2, size / 2, size / 2, fill: true)

      # Resize image to square if needed
      if width != height
        image = image.thumbnail_image(size, size: :force)
      end

      # Apply the mask
      if image.bands == 4 # Has alpha channel
        alpha = image.extract_band(3)
        alpha = alpha.composite2(mask, "multiply")
        rgb = image.extract_band(0, n: 3)
        result = rgb.bandjoin(alpha)
      else
        # Add alpha channel and apply mask
        alpha = mask
        rgb = image
        result = rgb.bandjoin(alpha)
      end

      # Write the result
      result.write_to_file(output_path.to_s)
      puts "✓ Created rounded favicon: #{output_path}"
    rescue LoadError => e
      puts "Error: Vips library not available. Install libvips:"
      puts "  macOS: brew install vips"
      puts "  Ubuntu: sudo apt-get install libvips-dev"
      puts "  #{e.message}"
      exit 1
    rescue => e
      puts "Error creating rounded favicon: #{e.message}"
      puts e.backtrace.first(5)
      exit 1
    end
  end
end
