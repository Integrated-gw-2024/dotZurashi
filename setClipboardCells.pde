String svgTag[] = new String[2];
String DOCTYPE = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
String outputXML;
ArrayList<String> rectElements;


void setClipboardCells() {
  svgTag[0] = "<svg id=\"kokoninamae\" xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 2792.61 1041.11\">";
  svgTag[1] = "</svg>";

  rectElements = new ArrayList<String>();

  String rectTag = "";
  
  


  for (Cell c : Cells) {
    float sz = c.scale-(c.scale/2);
    rectElements.add("<circle class=\"cls-1\" cx=\"" + c.x + "\" cy=\"" + c.y + "\" r=\"" + sz + "\" fill=\"" + c.fill + "\" stroke=\"" + c.stroke + "\" stroke-width=\"" + c.strokeWeight + "\" />");
  }



  for (String str : rectElements) {
    rectTag += str;
  }

  outputXML = DOCTYPE + svgTag[0] + rectTag + svgTag[1];

  Clipboard cb = Toolkit.getDefaultToolkit().getSystemClipboard();
  StringSelection sel = new StringSelection(outputXML);
  cb.setContents(sel, null);
  
  println("set clipboard");

  //isViewCopiedText = true;
}
