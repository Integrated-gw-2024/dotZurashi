void autoResizeCells(XML x) {
  String viewBox = x.getString("viewBox");

  Pattern viewBoxPatt = Pattern.compile("\\b(?:0|(?:[1-9]\\d*))(\\.\\d+)?\\b");
  Matcher viewBoxMatc = viewBoxPatt.matcher(viewBox);

  String[] svgSizeString = new String[4];

  int a = 0;
  while (viewBoxMatc.find()) {
    svgSizeString[a] = viewBoxMatc.group();
    a++;
  }

  try {
    svgWidth = Float.parseFloat(svgSizeString[2]);
    svgHeight = Float.parseFloat(svgSizeString[3]);
  }
  catch (NumberFormatException e) {
    println("整数に変換できませんでした。");
  }

  float topValue = 0;


  if (svgWidth>svgHeight) {
    println(svgWidth);
    topValue = svgWidth;
  } else if (svgWidth<svgHeight) {
    println(svgHeight);
    topValue = svgHeight;
  } else {
    println("svgのサイズが取得されていません。サイズの比較に失敗しました。");
  }

  float scaleFactor = min(width / svgWidth, height / svgHeight);

  displayScale = scaleFactor * 0.65;
  println(displayScale);
}
