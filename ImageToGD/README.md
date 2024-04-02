# GtGD

Converts [Geometrize](https://www.geometrize.co.uk/) JSON file to a [spwn](https://github.com/Spu7Nix/SPWN-language/) file

Supports:
| Shape              | JSON | SVG |
|:-------------------|:----:|:---:|
| Circle             | ✔    | ✔  |
| Ellipses           | ✔    | ✔  |
| Lines              | ✘    | ✔  |
| Polylines          | ✘    | ✘  |
| Quadratic Beziers  | ✘    | ✘  |
| Rectangles         | ✔*   | ✘  |
| Rotated Ellipses   | ✘    | ✔  |
| Rotated Rectangles | ✘    | ✘  |
| Triangles          | ✘    | ✘  |

*Positions and scale are wrong

## Prerequisites

- [Geometrize](https://www.geometrize.co.uk/)
- [spwn](https://github.com/Spu7Nix/SPWN-language/)

## Usage

1. On Geometrize, make an image only using supported shapes above, when it looks good save image as "Geometry Data" (or "SVG")
2. Run the script and select the JSON file
3. Press "Yes" on the message box (or run the command listed in the message box)
4. Open the top level in the list on Geometry Dash, set the image colour channel to #000000 (Black) and 0.5 Opacity, and vertically flip the image

### Credits

I got the output of (circle only) geometry data from [frogserver.com](https://frogserver.com/geometrize.php), but all this code is written by me