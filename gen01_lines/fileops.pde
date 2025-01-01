String[] getImageFiles(String directoryPath) {

  File dir = new File(directoryPath);

  // Check if the directory exists and is indeed a directory
  if (!dir.exists() || !dir.isDirectory()) {
    println("The provided path is not a valid directory: " + directoryPath);
    return new String[0];
  }

  // List all files in the directory and filter for supported image extensions
  File[] files = dir.listFiles((file) -> {
    if (file.isFile()) {
      String name = file.getName().toLowerCase();
      return name.endsWith(".jpg") || name.endsWith(".jpeg") || name.endsWith(".png");
    }
    return false;
  }
  );

  // Convert the File objects to their absolute paths as strings
  if (files != null) {
    String[] filePaths = new String[files.length];
    for (int i = 0; i < files.length; i++) {
      filePaths[i] = files[i].getAbsolutePath();
    }
    return filePaths;
  } else {
    return new String[0];
  }
}
