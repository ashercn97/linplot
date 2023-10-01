module linplot

import math
import stbi

pub struct Image {
    width int
    height int
    mut:
        pixels []u32
}

pub fn new_image(w int, h int) Image {
    return Image{
        width: w,
        height: h,
        pixels: []u32{len: (w * h)},
    }
}

pub fn (mut img Image) set_pixel(x int, y int, col u32) {
    img.pixels[y * img.width + x] = col
}

pub struct F64Array {
    data []f64
}

pub fn (arr F64Array) max() f64 {
    mut max := arr.data[0]
    for x in arr.data {
        if x > max {
            max = x
        }
    }
    return max
}

pub struct Plot {
    x F64Array
    y F64Array
    colors []u32  // Store colors for each data point
    connect_dots bool  // Flag to connect the dots
    mut:
        image &Image
}

pub fn (mut p Plot) draw(color u32) {
    mut max_x := p.x.data[0]
    mut min_x := p.x.data[0]
    mut max_y := p.y.data[0]
    mut min_y := p.y.data[0]

    for i in 1 .. p.x.data.len {
        if p.x.data[i] > max_x {
            max_x = p.x.data[i]
        }
        if p.x.data[i] < min_x {
            min_x = p.x.data[i]
        }
        if p.y.data[i] > max_y {
            max_y = p.y.data[i]
        }
        if p.y.data[i] < min_y {
            min_y = p.y.data[i]
        }
    }

    // Calculate the buffer size (adjust as needed)
    buffer_size := 10 // Increase or decrease this value to add or reduce the buffer

    // Calculate the step sizes for x and y axes based on data range
    step_x := f64(p.image.width - 2 * buffer_size) / (max_x - min_x)
    step_y := f64(p.image.height - 2 * buffer_size) / (max_y - min_y)

    // Calculate the dot size based on the number of data points
    num_data_points := p.x.data.len
    max_dot_size := 20 // Adjust the maximum dot size as needed
    mut dot_size := int(f64(p.image.width) / f64(num_data_points + 1))
    dot_size = int(math.clamp(dot_size, 1, max_dot_size))

    // Draw horizontal and vertical axes
    for x in 0 .. p.image.width {
        p.image.set_pixel(x, p.image.height / 2, 0xffffff) // Set pixel color to black for the x-axis
    }
    for y in 0 .. p.image.height {
        p.image.set_pixel(p.image.width / 2, y, 0xffffff) // Set pixel color to black for the y-axis
    }

    // Draw the data points
    for i in 0 .. p.x.data.len {
        // Calculate the coordinates with an offset to center the dot within the buffer
        mut x := int((p.x.data[i] - min_x) * step_x) + buffer_size
        mut y := p.image.height - int((p.y.data[i] - min_y) * step_y) - buffer_size  // Invert Y-axis

        // Ensure the coordinates are within bounds
        x = int(math.clamp(x, buffer_size, p.image.width - buffer_size - dot_size))
        y = int(math.clamp(y, buffer_size, p.image.height - buffer_size - dot_size))

        // Draw a filled rectangle to represent the dot with the specified color
        for dx in 0 .. dot_size {
            for dy in 0 .. dot_size {
                p.image.set_pixel(x + dx, y + dy, color)
            }
        }

        // Connect the dots if the flag is set to true
        if p.connect_dots && i > 0 {
            mut prev_x := int((p.x.data[i - 1] - min_x) * step_x) + buffer_size + dot_size / 2
            mut prev_y := p.image.height - int((p.y.data[i - 1] - min_y) * step_y) - buffer_size - dot_size / 2

            for px in prev_x .. x {
                py := prev_y + (y - prev_y) * (px - prev_x) / (x - prev_x)
                for dy in 0 .. dot_size {
                    for dx in 0 .. dot_size {
                        p.image.set_pixel(px + dx, py + dy, color)
                    }
                }
            }
        }
    }
}

pub fn (img Image) save_as_jpg(path string) ! {
    stbi.stbi_write_jpg(
        path,
        img.width,
        img.height,
        4, // RGBA
        &u8(img.pixels.data),
        100, // JPEG quality (0-100)
    )!
}

pub fn draw_multiple_plots(image &Image, mut plots []Plot) {
    for mut plot in plots {
        color := plot.colors[0]
        plot.draw(color)
    }
}

// Example function to get custom colors based on plot index
pub fn get_color(color int) u32 {
    colors := [0xFF0000, 0x00FF00, 0x0000FF, 0xFFFF00, 0xFF00FF] // Add more colors as needed
    return u32(colors[u32(color) % u32(colors.len)])
}