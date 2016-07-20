/*

This is a prototype Javascript API for Sketch.

The intention is to make something which is:

- native Javascript
- an easily understandable subset of the full internals of Sketch
- fully supported by Bohemian between releases (ie we try not to change it, unlike our internal API which we can and do change whenever we need to)
- still allows you to drop down to our internal API when absolutely necessary.

Comments and suggestions for this API are welcome - send them to developer@sketchapp.com.

All code (C) 2016 Bohemian Coding.


** PLEASE NOTE: this API is not final, and should be used for testing & feedback purposes only. **
** The idea eventually is that it's fixed - but until we've got the design right, it WILL change. **



Example script:

var sketch = context.api(context);

log(sketch.version());

var app = sketch.application();
log(app.version());
log(app.build());
log(app.full_version());


var document = sketch.context_document();
var selection = document.selection();
var pages = document.pages();
var page = pages[0];

var group = page.add_group("Test", CGRectMake(0, 0, 100, 100));
var rect = group.add_rectangle("Rect", CGRectMake(10, 10, 80, 80));

log(selection.is_empty());
selection.iterate(function(item) { log(item.name); } );

selection.clear();
log(selection.is_empty());

group.select();
rect.add_to_selection();

app.input("Test", "default");
app.select("Test", ["One", "Two"], 1);
app.message("Hello mum!");
app.alert("Title", "message");



*/


"use strict";

function SketchAPIVersion1(context) {

  function Rectangle(x, y, w, h) {
    this.x = x;
    this.y = y;
    this.width = w;
    this.height = h;
  }

  Rectangle.prototype.asCGRect = function() {
    return CGRectMake(this.x, this.y, this.width, this.height);
  }

  /*
  Rectangle.prototype = Object.create();
  Rectangle.prototype.constructor = Rectangle;

*/

  function WrappedObject(object) {
    this.object = object;
  }


  Object.defineProperty(WrappedObject.prototype, 'id', {
    get: function() { return this.object.objectID(); }
  })

  // ********************************
  // Application support.
  // ********************************

  function Application() {
    WrappedObject.call(this, context);
    this.context = context
    this.metadata = MSApplicationMetadata.metadata();
  }

  Application.prototype = Object.create(WrappedObject.prototype);
  Application.prototype.constructor = Application;

  Application.prototype.version = function() {
    return this.metadata['appVersion'];
  }

  Application.prototype.build = function() {
    return this.metadata['build'];
  }

  Application.prototype.full_version = function() {
    return this.version() + " (" + this.build() + ")";
  }

  Application.prototype.get_setting = function(key) {
    return NSUserDefaults.standardUserDefaults().objectForKey_(key);
  }

  Application.prototype.set_setting = function(key, value) {
    NSUserDefaults.standardUserDefaults().setObject_forKey_(value, key);
  }

  Application.prototype.input = function(msg, initial) {
    return this.context.document.askForUserInput_initialValue(msg, initial);
  }

  Application.prototype.newDocument = function() {
    var app = NSDocumentController.sharedDocumentController();
    app.newDocument_(this);
    return new Document(app.currentDocument());

  }

  Application.prototype.select = function(msg, items, selectedItemIndex) {
    selectedItemIndex = selectedItemIndex || 0

    var accessory = NSComboBox.alloc().initWithFrame(NSMakeRect(0,0,200,25))
    accessory.addItemsWithObjectValues(items)
    accessory.selectItemAtIndex(selectedItemIndex)

    var alert = NSAlert.alloc().init()
    alert.setMessageText(msg)
    alert.addButtonWithTitle('OK')
    alert.addButtonWithTitle('Cancel')
    alert.setAccessoryView(accessory)

    var responseCode = alert.runModal()
    var sel = accessory.indexOfSelectedItem()

    return [responseCode, sel]
  }

  Application.prototype.message = function(msg) {
    this.context.document.showMessage(msg);
  }

  Application.prototype.alert = function(title, msg) {
    var app = NSApplication.sharedApplication()
    app.displayDialog_withTitle(title, msg);
  }

  // ********************************
  // Layer support.
  // TODO: split this functionality up properly into wrappers for the main layer classes
  // ********************************

  function Layer(layer) {
    WrappedObject.call(this, layer);
  }

  Layer.prototype = Object.create(WrappedObject.prototype);
  Layer.prototype.constructor = Layer;

  Layer.prototype.object = function() {
    return this.object;
  }

  Object.defineProperty(Layer.prototype, 'name', {
    get: function() { return this.object.name(); },
    set: function(value) { this.object.setName_(value); }
  });

  Object.defineProperty(Layer.prototype, 'frame', {
    get: function() {
      var f = this.object.frame();
      return new Rectangle(f.x(), f.y(), f.width(), f.height());
    },
    set: function(value) {
      var f = this.object.frame();
      f.setRect_(NSMakeRect(value.x, value.y, value.width, value.height));
     }
  });

  Layer.prototype.duplicate = function() {
    return new Layer(this.object.duplicate());
  }

  Layer.prototype.is_page = function() { return false; }
  Layer.prototype.is_artboard = function() { return false; }
  Layer.prototype.is_group = function() { return false; }
  Layer.prototype.is_text = function() { return false; }
  Layer.prototype.is_shape = function() { return false; }

  Layer.prototype.add_layer_with_name = function(newLayer, name) {
    if (newLayer) {
      newLayer.setName_(name);
      var layer = this.object;
      layer.addLayers_(NSArray.arrayWithObject_(newLayer));
      return new Layer(newLayer);
    }
  }

  Layer.prototype.add_rectangle = function(name, frame) {
    var newLayer = MSShapeGroup.shapeWithBezierPath_(NSBezierPath.bezierPathWithRect_(frame.asCGRect()));
    return this.add_layer_with_name(newLayer, name);
  }

  Layer.prototype.add_text = function(name, frame, text) {
    var newLayer = MSTextLayer.alloc().initWithFrame_(frame.asCGRect());
    newLayer.adjustFrameToFit();
    return this.add_layer_with_name(newLayer, name);
  }

  Layer.prototype.add_group = function(name, frame) {
    var newLayer = MSLayerGroup.alloc().initWithFrame_(frame.asCGRect());
    return this.add_layer_with_name(newLayer, name);
  }

  Layer.prototype.add_artboard = function(name, frame) {
    var newLayer = MSArtboardGroup.alloc().initWithFrame_(frame.asCGRect());
    return this.add_layer_with_name(newLayer, name);
  }

  Layer.prototype.add_image = function(name, frame) {
    var newLayer = MSLayerGroup.alloc().initWithFrame_(frame.asCGRect());
    return this.add_layer_with_name(newLayer, name);
  }

  Layer.prototype.remove = function() {
    var parent = this.object.parentGroup();
    if (parent) {
      parent.removeLayer_(layer);
    }
  }

  Layer.prototype.select = function() {
    this.object.select_byExpandingSelection(true, false);
  }

  Layer.prototype.deselect = function() {
    this.object.select_byExpandingSelection(false, true);
  }

  Layer.prototype.add_to_selection = function() {
    this.object.select_byExpandingSelection(true, true);
  }

  Layer.prototype.iterate = function(block) {
    var loop = this.object().layers().objectEnumerator();
    while (item = loop.nextObject()) {
      block(new Layer(item));
    }
  }

  // ********************************
  // Group support.
  // ********************************

  function Group(group) {
    Layer.call(this, group);
  }

  Group.prototype = Object.create(Layer.prototype);
  Group.prototype.constructor = Group;

  Group.prototype.is_group = function() {
    return true;
  }

  // ********************************
  // Page support.
  // ********************************

  function Page(page) {
    Group.call(this, page);
  }

  Page.prototype = Object.create(Group.prototype);
  Page.prototype.constructor = Page;

  Page.prototype.is_page = function() {
    return true;
  }

  // ********************************
  // Artboard support.
  // ********************************

  function Artboard(artboard) {
    Group.call(this, artboard);
  }

  Artboard.prototype = Object.create(Group.prototype);
  Artboard.prototype.constructor = Artboard;

  Artboard.prototype.is_artboard = function() {
    return true;
  }

  // ********************************
  // Text support.
  // ********************************

  function Text(text) {
    Layer.call(this, text);
  }

  Text.prototype = Object.create(Layer.prototype);
  Text.prototype.constructor = Text;

  Text.prototype.is_text = function() {
    return true;
  }

  // ********************************
  // Shape support.
  // ********************************

  function Shape(shape) {
    Layer.call(this, shape);
  }

  Shape.prototype = Object.create(Layer.prototype);
  Shape.prototype.constructor = Shape;

  Shape.prototype.is_shape = function() {
    return true;
  }

  // ********************************
  // Selection support.
  // ********************************

  function Selection(document) {
    WrappedObject.call(this, document);
  }

  Selection.prototype = Object.create(WrappedObject.prototype);
  Selection.prototype.constructor = Selection;

  Selection.prototype.is_empty = function() {
    return (this.object.selectedLayers().count() == 0);
  }

  Selection.prototype.iterateAndClear = function(block) {
    var layers = this.object.selectedLayers();
    this.clear();
    this.iterateWithLayers(layers, block);
  }

  Selection.prototype.iterate = function(block) {
    var layers = this.object.selectedLayers();
    this.iterateWithLayers(layers, block);
  }

  Selection.prototype.iterateWithLayers = function(layers, block) {
    var loop = layers.objectEnumerator();
    var item;
    while (item = loop.nextObject()) {
      block(new Layer(item));
    }
  }

  Selection.prototype.clear = function() {
    this.object.currentPage().deselectAllLayers();
  }


  // ********************************
  // Document support.
  // ********************************

  function Document(document) {
    WrappedObject.call(this, document);

  }

  Document.prototype = Object.create(WrappedObject.prototype);
  Document.prototype.constructor = Document;

  Object.defineProperty(Document.prototype, 'selection', {
    get: function() {     return new Selection(this.object); }
  });

  Document.prototype.pages = function() {
    var result = [];
    var loop = this.object.pages().objectEnumerator();
    var item;
    while (item = loop.nextObject()) {
      result.push(new Page(item));
    }
    return result;
  }

  Document.prototype.layer_with_id = function(layer_id) {
    return new Layer(this.object.documentData().layerWithID_(layer_id));
  }

  Document.prototype.layer_with_name = function(layer_id) {
    // as it happens, layerWithID also matches names
    var layer = this.object.documentData().layerWithID_(layer_id);
    if (layer)
      return new Layer(layer);
  }

  return {
    "version" : function() {
      return "1.0.0";
    },

    "application" : function() {
      return new Application(context);
    },

    "selected_document" : function() {
      return new Document(context.document);
    },

    "document" : function(document) {
      return new Document(document);
    },

    "Rectangle" : Rectangle
  }
}

function SketchAPIWithCapturedContext(context) {
    return (function() {
      return SketchAPIVersion1(context);
    });
}
