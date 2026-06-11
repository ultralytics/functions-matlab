<a href="https://www.ultralytics.com/"><img src="https://raw.githubusercontent.com/ultralytics/assets/main/logo/Ultralytics_Logotype_Original.svg" width="320" alt="Ultralytics logo"></a>

# export_fig

A MATLAB toolbox for exporting figures to standard image and document formats with high fidelity.

## 🖼️ Overview

Exporting a figure from [MATLAB](https://www.mathworks.com/products/matlab.html) exactly as you intend (ideally, matching its on-screen appearance) can be challenging due to numerous settings and the quirks of functions like [`print`](https://www.mathworks.com/help/matlab/ref/print.html). The primary goal of `export_fig` is to simplify the process of transferring a plot from your screen to a document, ensuring it looks just as expected.

The secondary goal is to produce publication-quality output. This includes embedding fonts, setting image [compression levels](https://en.wikipedia.org/wiki/Image_compression) (including lossless), applying [anti-aliasing](https://en.wikipedia.org/wiki/Spatial_anti-aliasing), cropping, setting the [colourspace](https://en.wikipedia.org/wiki/Color_space), handling [alpha blending](https://en.wikipedia.org/wiki/Alpha_compositing), and achieving the correct [resolution](https://en.wikipedia.org/wiki/Image_resolution).

Let's explore what `export_fig` can do through some examples.

## ✨ Examples

### Visual Accuracy

MATLAB's built-in exporting functions, [`saveas`](https://www.mathworks.com/help/matlab/ref/saveas.html) and `print`, often alter visual properties like size, axes limits, ticks, and background color unexpectedly. `export_fig` aims to faithfully reproduce the figure as it appears on screen.

Consider this example:

```Matlab
% Create a simple plot
plot(cos(linspace(0, 7, 1000)));

% Set the figure size
set(gcf, 'Position', [100 100 150 150]); % gcf gets the current figure handle

% Export using saveas
saveas(gcf, 'test.png');

% Export using export_fig
export_fig test2.png
```

This code generates the following outputs:

|                                 Figure:                                 |                                test.png (saveas):                                |                               test2.png (export_fig):                                |
| :---------------------------------------------------------------------: | :-----------------------------------------------------------------------------: | :-----------------------------------------------------------------------: |
| ![](https://farm6.staticflickr.com/5616/15589249291_16e485c29a_o_d.png) | ![](https://farm4.staticflickr.com/3944/15406302850_4d2e1c7afa_o_d.png)         | ![](https://farm6.staticflickr.com/5607/15568225476_8ce9bd5f6b_o_d.png)   |

Notice that `test2.png` (from `export_fig`) retains the original size and background color, unlike `test.png`. If you prefer a white background (or any other color), set it before exporting:

```Matlab
set(gcf, 'Color', 'w'); % Set figure background to white
```

`export_fig` also crops and applies anti-aliasing (smoothing for [bitmap formats](https://en.wikipedia.org/wiki/Raster_graphics)) by default. These options can be disabled (see the Tips section).

### Resolution Control

By default, `export_fig` exports bitmaps at screen resolution. However, you can specify different resolutions:

-   `-m<val>`: Magnifies the figure by `<val>` (e.g., `-m2` doubles the pixel dimensions).
-   `-r<val>`: Sets the output bitmap resolution to `<val>` pixels per inch (PPI), based on the figure's on-screen dimensions in inches.

Using `-m2.5` on the previous example:

```Matlab
export_fig test.png -m2.5
```

Produces this higher-resolution image:

![](https://farm4.staticflickr.com/3937/15591910915_dc7040c477_o_d.png)

Consider a figure containing an image:

```Matlab
% Display an image
imshow(imread('cameraman.tif')); % imread reads the image file
hold on % Keep the image when adding the plot

% Add a plot overlay
plot(0:255, sin(linspace(0, 10, 256))*127+128); % linspace generates linear spacing

% Set figure size
set(gcf, 'Position', [100 100 150 150]);
```

This generates:

![](https://farm4.staticflickr.com/3942/15589249581_ff87a56a3f_o_d.png)

The image is displayed at a lower resolution than its native size. To export the figure ensuring the image is at its original pixel dimensions, use the `-native` option:

```Matlab
export_fig test.png -native
```

This produces:

![](https://farm6.staticflickr.com/5604/15589249591_da2b2652e4_o_d.png)

The image within `test.png` now matches the original `cameraman.tif` pixel dimensions. If you need an image to be a specific size (other than native), resize it in MATLAB first, then use `-native`.

All resolution options (`-m<val>`, `-q<val>`, `-native`) correctly embed resolution information in [PNG](https://en.wikipedia.org/wiki/PNG) and [TIFF](https://en.wikipedia.org/wiki/TIFF) files.

### Shrinking Dots & Dashes

When exporting figures with dashed or dotted lines using the ZBuffer or [OpenGL](https://www.opengl.org/) renderers (default for bitmaps), the dots and dashes can appear shortened or disappear, especially with thick lines or high resolution.

Example:

```Matlab
plot(sin(linspace(0, 10, 1000)), 'b:', 'LineWidth', 4);
hold on
plot(cos(linspace(0, 7, 1000)), 'r--', 'LineWidth', 3);
grid on
export_fig test.png
```

Generates:

![](https://farm4.staticflickr.com/3956/15592747732_f943d4aa0a_o_d.png)

Using the painters renderer often resolves this:

```Matlab
export_fig test.png -painters
```

Produces:

![](https://farm4.staticflickr.com/3945/14971168504_77692f11f5_o_d.png)

Note the correct appearance of both plot lines and grid lines. Learn more about MATLAB renderers [here](https://www.mathworks.com/help/matlab/creating_plots/specify-the-figure-renderer.html).

### Transparency

To make figure and axes backgrounds transparent (useful for overlaying on colored or textured document backgrounds), first set the axes color to 'none':

```Matlab
set(gca, 'Color', 'none'); % gca gets the current axes handle
```

Then, use the `-transparent` option during export:

```Matlab
export_fig test.png -transparent
```

This enables transparency for [PDF](https://en.wikipedia.org/wiki/PDF), [EPS](https://en.wikipedia.org/wiki/Encapsulated_PostScript), and PNG outputs. For PNG, you can also save fully alpha-blended semi-transparent objects.

Example:

```Matlab
logo; % MATLAB's built-in logo function
alpha(0.5); % Set transparency level
```

Generates:

![](https://farm4.staticflickr.com/3933/15405290339_b08de33528_o_d.png)

Exporting this with `-transparent` allows seamless blending onto other backgrounds, like a presentation slide:

![](https://farm6.staticflickr.com/5599/15406302920_59beaefff1_o_d.png)

### Image Quality

For publication, image quality is crucial. `export_fig` defaults to high quality (low compression) for lossy formats (PDF, EPS, [JPEG](https://en.wikipedia.org/wiki/JPEG)), unlike MATLAB's `print` and `saveas` which often use lower quality defaults.

Example with added noise:

```Matlab
% Load image and add noise
A = im2double(imread('peppers.png'));
B = randn(ceil(size(A, 1)/6), ceil(size(A, 2)/6), 3) * 0.1; % randn generates normal distribution
B = cat(3, kron(B(:,:,1), ones(6)), kron(B(:,:,2), ones(6)), kron(B(:,:,3), ones(6))); % kron is Kronecker product
B = A + B(1:size(A, 1),1:size(A, 2),:);
imshow(B);

% Export using MATLAB's print
print -dpdf test.pdf
```

Zooming into `test.pdf` reveals compression artifacts:

![](https://farm6.staticflickr.com/5613/15405290309_881b2774d6_o_d.png)

Using `export_fig`:

```Matlab
export_fig test.pdf
```

Produces a much better result:

![](https://farm4.staticflickr.com/3947/14971168174_687473133f_o_d.png)

While improved, some artifacts might remain. You can control the quality using `-q<val>` (0-100, 0=high compression, 100=high quality). For [lossless compression](https://en.wikipedia.org/wiki/Lossless_compression) in PDF, EPS, or JPEG, use a value > 100.

```Matlab
export_fig test.pdf -q101 % Lossless export
```

Results in a clean image with no compression noise:

![](https://farm6.staticflickr.com/5608/15405803908_934512c1fe_o_d.png)

## 💡 Tips

-   **Anti-aliasing Control**: Adjust anti-aliasing levels using `-a<val>` (1=none, 2, 3=default, 4=max). Disabling it (`-a1`) can speed up export and reduce blurring for certain images but may result in jagged lines.
-   **Cropping**: `export_fig` crops output by default. Use `-nocrop` to preserve the original border width as seen on screen.
-   **Colourspace**: Export in greyscale (`-grey` or `-gray`) or [CMYK](https://en.wikipedia.org/wiki/CMYK_color_model) (`-cmyk`) instead of the default [RGB](https://en.wikipedia.org/wiki/RGB_color_model). CMYK is supported for PDF, EPS, and TIFF, often required by publishers.
-   **Target Directory**: Specify a full or relative path in the filename to save to a specific directory:
    ```Matlab
    export_fig ../subdir/fig.png;
    export_fig('C:/Users/Me/Documents/figures/myfig', '-pdf', '-png');
    ```
-   **Variable File Names**: Use the functional form and [`sprintf`](https://www.mathworks.com/help/matlab/ref/sprintf.html) for dynamic filenames in loops:
    ```Matlab
    for a = 1:5
        plot(rand(5, 2)); % rand generates uniform distribution
        export_fig(sprintf('plot%d.png', a));
    end
    ```
    Remember quotes for string arguments in functional form:
    ```Matlab
    export_fig(sprintf('plot%d', a), '-a1', '-pdf', '-png');
    ```
-   **Specify Figure/Axes**: Export a specific figure or axes using its handle:
    ```Matlab
    fig_handle = figure; % Create a new figure and get its handle
    plot(1:10);
    export_fig(fig_handle, 'my_figure.png');

    ax_handle = gca; % Get handle to current axes
    export_fig(ax_handle, 'my_axes.pdf');
    ```
-   **Multiple Formats**: Export to several formats at once:
    ```Matlab
    export_fig filename -pdf -eps -png -jpg -tiff
    ```
-   **Other File Formats**: Output image data (and optionally alpha mask) to the workspace for use with other functions like [`imwrite`](https://www.mathworks.com/help/matlab/ref/imwrite.html):
    ```Matlab
    frame = export_fig; % Get image data
    [frame, alpha] = export_fig; % Get image data and alpha mask
    % Now use 'frame' and 'alpha' with imwrite or other functions
    ```
-   **Appending Files**: Use `-append` to add the figure to an existing PDF or TIFF file. For many appends to a PDF, saving separately and then merging (e.g., using `append_pdfs`) can be faster.
-   **Clipboard Output**: Copy the figure/axes to the system clipboard as a bitmap using `-clipboard` for easy pasting into applications like [Microsoft Word](https://www.microsoft.com/en-us/microsoft-365/word) or [PowerPoint](https://www.microsoft.com/en-us/microsoft-365/powerpoint).
-   **Font Size Consistency**: To ensure fonts appear at a specific size in your final document, set the font size correctly in the MATLAB figure *before* exporting. Ensure the figure's on-screen size matches the desired size in the document to avoid resizing the exported image.
-   **Renderers**: MATLAB offers painters, OpenGL, and ZBuffer renderers, each with different capabilities. Vector formats (PDF, EPS) default to painters; bitmaps default to OpenGL. Force a specific renderer using `-painters`, `-opengl`, or `-zbuffer`.
    ```Matlab
    export_fig test.png -painters
    ```
-   **Troubleshooting Artifacts**: If the output differs from the on-screen figure, ensure the on-screen renderer matches the export renderer. Set the on-screen renderer using:
    ```Matlab
    set(figure_handle, 'Renderer', 'opengl'); % Or 'painters', 'zbuffer'
    ```
    If artifacts persist on screen, fix the figure first. If artifacts only appear in the export, try a different export renderer or check the Known Issues below.
-   **Smoothed PDFs**: If images in exported PDFs look overly smoothed, it's likely your PDF viewer's setting. The image data itself is not smoothed. Check viewer settings or try a different viewer like [Adobe Acrobat Reader](https://get.adobe.com/reader/).
-   **Locating Dependencies**: `export_fig` relies on external applications: [Ghostscript](http://www.ghostscript.com) (for EPS/PDF processing) and `pdftops` (part of the [Xpdf package](http://www.xpdfreader.com), for PDF processing). If prompted, ensure these are installed and accessible via your system's PATH, or point `export_fig` to their location via the dialogue.
-   **Undefined Function Errors**: Errors like `??? Undefined function or method 'print2array' ...` mean you're missing files from the `export_fig` package. Download the complete package from [GitHub](https://github.com/altmany/export_fig) and ensure all files are extracted to the same directory and added to your MATLAB path.

## ⚠️ Known Issues

`export_fig` wraps MATLAB's `print` function and inherits some of its limitations:

-   **Fonts (Painters Renderer)**: The painters renderer supports limited fonts (see [MathWorks documentation](https://www.mathworks.com/help/matlab/creating_plots/choose-a-printer-driver.html#f3-96545)). `export_fig` attempts font name correction in EPS files, but it's not guaranteed, especially for LaTeX-interpreted text. Ghostscript errors like `/undefined in /findfont` might occur if font definition files are missing; ensure `EXPORT_FIG_PATH/.ignore/gs_font_path.txt` points to your TrueType font directories.
-   **RGB Color (Painters Renderer)**: A warning "RGB color data not yet supported in Painter's mode" occurs when exporting patches with direct RGB color specifications (e.g., from [`pcolor`](https://www.mathworks.com/help/matlab/ref/pcolor.html)) using the painters renderer. Use colormap-indexed colors or consider alternatives like `uimagesc` from the File Exchange.
-   **Dashed Contour Lines (Painters Renderer)**: Dashed lines created with [`contour`](https://www.mathworks.com/help/matlab/ref/contour.html) may appear solid due to a MATLAB limitation ([details](https://www.mathworks.com/matlabcentral/answers/94703)).
-   **Text Size (OpenGL/ZBuffer)**: Large text might resize unexpectedly when exporting at non-screen resolutions with OpenGL or ZBuffer. Try the `-painters` option.
-   **Lighting & Transparency (Painters Renderer)**: These effects are not supported by the painters renderer. For vector output with transparency, consider [plot2svg](https://www.mathworks.com/matlabcentral/fileexchange/7401-scalable-vector-graphics-svg-export-of-figures) and conversion tools like [Inkscape](https://inkscape.org/).
-   **Lines in Patch Objects (Painters Renderer)**: Thin lines (background color) might appear across patches in PDF output due to MATLAB rendering bugs. These can sometimes be removed using vector editing software like [Inkscape](https://inkscape.org/) or by disabling anti-aliasing in the PDF viewer ([discussion](https://github.com/altmany/export_fig/issues/44)).
-   **Out of Memory**: If memory issues occur, try:
    1.  Reducing anti-aliasing (`-a<val>`).
    2.  Reducing figure size (`set(gcf, 'Position', ...)`).
    3.  Reducing export resolution (`-m<val>` or `-r<val>`).
    4.  Changing the renderer (`-painters` or `-zbuffer`).
-   **OpenGL Errors**: These often stem from MATLAB bugs or graphics driver issues. Ensure your driver is up-to-date. If problems persist, try the `-zbuffer` renderer.

## 🐞 Raising Issues

If you encounter an issue **not listed above**:

1.  **Verify On-Screen Rendering**: Check if the figure looks correct on screen using the *same renderer* `export_fig` will use (Painters for vector, OpenGL for bitmap by default). If it's wrong on screen, the issue lies there.
2.  **Try Other Renderers**: If exporting to bitmap, test `-opengl`, `-zbuffer`, and `-painters` to see if one works correctly.
3.  **Use Latest Version**: Ensure you have the newest `export_fig` from [GitHub](https://github.com/altmany/export_fig).
4.  **Submit Issue**: If the problem persists only in the exported file, please raise an [issue on GitHub](https://github.com/altmany/export_fig/issues). Include:
    -   The `.fig` file.
    -   The exact `export_fig` command used.
    -   The incorrect output file.
    -   A description of the expected output.

While fixes aren't guaranteed (especially for underlying MATLAB bugs), clear reports help improve the toolbox. Feature requests are also welcome!

## 🎨 And Finally... The Logo Explained

![](https://farm4.staticflickr.com/3956/15591911455_b9008bd77e_o_d.jpg)

The `export_fig` logo demonstrates several features:

-   **Original Figure (Top Right)**: A translucent mesh.
-   **PDF Output (Bottom Center)**: Exported as a [vector graphic](https://en.wikipedia.org/wiki/Vector_graphics), allowing lossless zooming. However, translucency is lost, and thin white lines (gaps between patches) might appear depending on the PDF viewer.
-   **PNG Output (Top Left)**: Exported as a bitmap. Translucency is preserved (note the background showing through), and the image is anti-aliased. However, zooming reveals pixelation, and lines are less sharp than the PDF.

## 🤝 Contributing

Contributions are welcome! If you find bugs or have ideas for improvements, please open an issue or submit a pull request on the [GitHub repository](https://github.com/altmany/export_fig).
