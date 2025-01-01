ArrayList<Tile> createTiles(PImage sourceImage, int tileWidth, int tileHeight) {
  ArrayList<Tile> tiles = new ArrayList<>();
  int cols = sourceImage.width / tileWidth;
  int rows = sourceImage.height / tileHeight;

  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      PImage tileImage = sourceImage.get(x * tileWidth, y * tileHeight, tileWidth, tileHeight);
      // Store tileWidth and tileHeight in the Tile itself for reference
      tiles.add(new Tile(x, y, tileWidth, tileHeight, tileImage));
    }
  }

  return tiles;
}
class Tile {
  int x, y;
  int originalWidth, originalHeight;
  PImage tileImage;

  Tile(int x, int y, int tileWidth, int tileHeight, PImage tileImage) {
    this.x = x;
    this.y = y;
    this.originalWidth = tileWidth;
    this.originalHeight = tileHeight;
    this.tileImage = tileImage;
  }

  // Draw at scale factor 'tileSize' (e.g. 1.0 = actual size, 0.5 = half-size, etc.)
  void draw(float tileSize) {
    float scaledWidth  = originalWidth  * tileSize;
    float scaledHeight = originalHeight * tileSize;

    float drawX = x * scaledWidth;
    float drawY = y * scaledHeight;

    image(tileImage, drawX, drawY, scaledWidth, scaledHeight);
  }

  
  void drawLineRepresentation(float tileSize, color backgroundColor, color lineColor) {
    float scaledWidth  = originalWidth  * tileSize;
    float scaledHeight = originalHeight * tileSize;

    float drawX = x * scaledWidth;
    float drawY = y * scaledHeight;

    // Determine if the tile is best represented by a vertical or horizontal line
    boolean isVertical = isVerticalLine();

    // Draw background
    pushMatrix();
    translate(drawX, drawY);
    noStroke();
    fill(backgroundColor);
    rect(0, 0, scaledWidth, scaledHeight);

    // Draw the line in the center
    stroke(lineColor);
    strokeWeight(2);

    if (isVertical) {
      // Vertical line in the middle
      line(scaledWidth / 2, 0, scaledWidth / 2, scaledHeight);
    } else {
      // Horizontal line in the middley
      line(0, scaledHeight / 2, scaledWidth, scaledHeight / 2);
    }
    popMatrix();
  }

  
  boolean isVerticalLine() {
    // Compute brightness difference left vs right
    float leftBrightness  = averageBrightness(tileImage, 0, 0, tileImage.width/2, tileImage.height);
    float rightBrightness = averageBrightness(tileImage, tileImage.width/2, 0, tileImage.width - tileImage.width/2, tileImage.height);

    // Compute brightness difference top vs bottom
    float topBrightness    = averageBrightness(tileImage, 0, 0, tileImage.width, tileImage.height/2);
    float bottomBrightness = averageBrightness(tileImage, 0, tileImage.height/2, tileImage.width, tileImage.height - tileImage.height/2);

    float diffLR = abs(leftBrightness - rightBrightness);
    float diffTB = abs(topBrightness - bottomBrightness);

    // If left-right difference >= top-bottom difference, we consider it vertical
    return (diffLR >= diffTB);
  }



  float averageBrightness(PImage img, int startX, int startY, int w, int h) {
    
    float total = 0;
    int count   = 0;

    // We must loadPixels() before we can read image pixels in PImage
    img.loadPixels();

    // Constrain region in case tileWidth / tileHeight is odd
    int endX = min(startX + w, img.width);
    int endY = min(startY + h, img.height);

    for (int y = startY; y < endY; y++) {
      for (int x = startX; x < endX; x++) {
        int loc = x + y * img.width;
        
        total += brightness(img.pixels[loc]);
        count++;
      }
    }

    if (count == 0) return 0;  // Avoid division by zero

    return total / count;
  }
}
