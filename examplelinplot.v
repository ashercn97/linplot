import linplot


// -----------------------//
// EXAMPLE OF PLOTTING 	  //
// POINTS				  //
// -----------------------//
image := linplot.new_image(100, 100) //initialize a new image

x_data := linplot.F64Array{data: [1.0, 2.0, 3.0]} // the x values of the points to plot
y_data := linplot.F64Array{data: [2.0, 9.0, 4.5]} // the y values of the points to plot

mut plot := linplot.Plot{x: x_data, y: y_data, colors: u32(0), connect_dots: false, image: $image} //making the plot, 'connect_dots' says whether to make a line connecting the dots 
// useful for plotting functions that would be easier to see with it being connected

plot.draw(linplot.get_color(int(0))) // get_color picks colors, you can also pick your own colors just make sure they are u32

// save the image!
image.save_as_jpg("random_plot.jpg")


