---
layout:     post
title:      "Generating GIFs with C#"
author:     "eridem"
featured-image: "img/featured/2015-07-04-generating-gifs-with-csharp.jpg"
permalink:  generating-gifs-with-csharp
---

I did these images during the Demoscene 2015. The code is not the best, just to do something quick and dirty.

| ![](img/posts/2015-07-04-generating-gifs-with-csharp/inc.gif) | ![](img/posts/2015-07-04-generating-gifs-with-csharp/logo.gif) |

| ![](img/posts/2015-07-04-generating-gifs-with-csharp/rand.gif) | ![](img/posts/2015-07-04-generating-gifs-with-csharp/static.gif) |

```csharp
using System;
using System.Collections.Generic;
using System.Drawing;
using ImageMagick;

namespace RandomPixel
{
    class Program
    {
        private static readonly Random Rand = new Random();

        private static readonly int WIDTH = 320;
        private static readonly int HEIGHT = 256;
        private static int SQUARE_SIZE = WIDTH / 50;
        private static bool REDUCE_COLORS = false;
        private static int NUMBER_OF_COLORS = 64;
        private static bool DRAW_BOXES = false;

        private static readonly Boolean USE_BORDERS = false;

        private static byte[,] LOGO = new byte[,]
        {
            {1, 0, 0, 0, 0, 1},
            {0, 1, 1, 1, 1, 0},
            {1, 0, 1, 1, 0, 1},
            {1, 1, 1, 1, 1, 1},
            {1, 0, 1, 1, 0, 1}
        };

        private static readonly int LOGO_1D = 5;
        private static readonly int LOGO_2D = 6;
        private static int LOGO_SQUARE_SIZE = SquareSize * 4;

        private static int SquareSize
        {
            get { return SQUARE_SIZE; }
            set { SQUARE_SIZE = value; }
        }

        private static int SquareContainerSize
        {
            get { return SquareSize - 2; }
        }

        private static int SquareContainerSizeHalf
        {
            get { return SquareContainerSize / 2; }
        }

        private static int LogoSquareSize {
            get { return LOGO_SQUARE_SIZE; }
            set { LOGO_SQUARE_SIZE = value; }
        }

        private static int LogoStartX
        {
            get { return (WIDTH - (LOGO_2D*LogoSquareSize))/2; }
        }

        private static int LogoStartY
        {
            get { return (HEIGHT - (LOGO_1D * LogoSquareSize)) / 2; }
        }

        private static void Main(string[] args)
        {
            List<Bitmap> bitmaps = new List<Bitmap>();

            for (var frame = 250; frame > 0; frame--)
            {
                // Personalize this for different results
                SquareSize = WIDTH/Rand.Next(15, 30);
                LogoSquareSize = SQUARE_SIZE*Rand.Next(1, 7);

                var bmp = new Bitmap(WIDTH, HEIGHT);
                using (Graphics g = Graphics.FromImage(bmp))
                {
                    if (DRAW_BOXES)
                    {
                        DrawBoxes(g);
                    }
                    DrawPatterns(g);
                    DrawLogo(g);
                }
                bitmaps.Add(bmp);
                Console.WriteLine("Frame: {0}", frame);
            }

            SaveToGif(bitmaps, String.Format(@"x-{0:yyyyMMddHHmmss}.gif", DateTime.Now));
        }

        private static void SaveToGif(List<Bitmap> bitmaps, string path)
        {
            using (MagickImageCollection collection = new MagickImageCollection())
            {
                for (var i = 0; i < bitmaps.Count; i++)
                {
                    collection.Add(new MagickImage(bitmaps[i]));
                    Console.WriteLine("Apending to GIF: {0}", i);
                }

                if (REDUCE_COLORS)
                {
                    // Optionally reduce colors
                    QuantizeSettings settings = new QuantizeSettings();
                    settings.Colors = NUMBER_OF_COLORS;
                    collection.Quantize(settings);
                }


                // Optionally optimize the images (images should have the same size).
                collection.Optimize();

                // Save gif
                collection.Write(path);
            }
        }

        private static void DrawLogo(Graphics graphics)
        {
            for (var ly = 0; ly < LOGO_1D; ly++)
            {
                for (var lx = 0; lx < LOGO_2D; lx++)
                {
                    bool activate = LOGO[ly, lx] == 1;

                    if (activate)
                    {
                        var color = Color.FromArgb(
                            Rand.Next(100, 155), 
                            Rand.Next(0, 155), Rand.Next(0, 155), Rand.Next(0, 155));

                        graphics.FillRectangle(new SolidBrush(color),
                            LogoStartX + (lx * LOGO_SQUARE_SIZE), 
                            LogoStartY + (ly * LOGO_SQUARE_SIZE), 
                            LOGO_SQUARE_SIZE, LOGO_SQUARE_SIZE);
                    }
                }
            }
        }

        private static void DrawPatterns(Graphics graphics)
        {
            for (var y = 0; y < HEIGHT; y += SquareSize + (USE_BORDERS ? 1 : 0))
            {
                for (var x = 0; x < WIDTH; x += SquareSize + (USE_BORDERS ? 1 : 0))
                {
                    DrawPatternAt(graphics, x , y);
                }
            }
        }

        private static void DrawPatternAt(Graphics graphics, int px, int py)
        {
            var color = Color.FromArgb(Rand.Next(0, 255), Rand.Next(0, 255), Rand.Next(0, 255));
            int x, xStart;
            for (x = px, xStart = px + SquareContainerSize - 1; 
                x < px + SquareContainerSizeHalf; 
                x++, xStart--)
            {
                for (var y = py; y < py + SquareContainerSize; y++)
                {
                    if (Rand.Next(0, 100) < 50)
                    {
                        graphics.DrawRectangle(new Pen(color), x, y, 1, 1);
                        graphics.DrawRectangle(new Pen(color), xStart, y, 1, 1);
                    }
                }

                xStart--;
            }
        }

        private static void DrawBoxes(Graphics graphics)
        {
            for (var y = 0; y < HEIGHT; y += SquareSize)
            {
                for (var x = 0; x < WIDTH; x += SquareSize)
                {
                    graphics.DrawRectangle(new Pen(Color.DarkGray), x, y, SquareSize, SquareSize);
                }
            }
        }
    }

}
```
