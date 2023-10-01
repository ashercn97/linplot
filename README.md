# linplot
A very simple (one file) plotting module in the V language. This module **currently** takes two arrays, an x value one and a y value one, as input and outputs a JPEG of a graph of it. You can custumize the color, the dimensions, as well as if you want it to be traced out like in python's matplotlib.

To use it, clone the repo and move the example file out.

Then, initialize an image with the dimensions you want.
FOR EXAMPLE:
```
image := linplot.new_image(100, 100) // for the graph to be a 100x100 pixel image
```

get your x values and your y values in two arrays and convert them to F64Arrays
```
x_data := linplot.F64Array{data: x_value_array} // the x values of the points to plot
y_data := linplot.F64Array{data: y_value_array} // the y values of the points to plot
```

next, create a plot object
```
mut plot := linplot.Plot{x: x_data, y: y_data, colors: u32(0), connect_dots: true, image: &image} //connect dots
// says whether you want the lines connected (like in matplotlib function plotting)
//  or just there like a scatter plot
```


draw the function (NOTE: you can draw more than one functions on a plot before you save, just make a new plot object with the same image in the image field and run the following command with that plot object)
```
plot.draw(linplot.get_color(int(0))) // the get_color picks built in colors, to pick your own, either add colors to the get_color function in the file,
// or input a u32 as of 0x[your hex code]
```

finally to show your plot run
```
image.save_as_jpg("your_file_path.jpg")
```




