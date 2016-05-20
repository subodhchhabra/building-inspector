class Sheet
  constructor: () ->
    @map = L.mapbox.map('map', 'nypllabs.g6ei9mm0',
      animate: true
      minZoom: 1
      maxZoom: 21
      attributionControl: false
    )

    tileset = $("#sheetdata").data("tiles")
    tiletype = $("#sheetdata").data("type")

    @overlay = Utils.addOverlay(@map, tileset, tiletype, 2)

    sheet = @
    @map.on 'load', () ->
      sheetdata = $("#sheetdata").data("sheet")

      bounds = Utils.parseBbox(sheetdata.bbox)

      console.log sheetdata.bbox, bounds

      sheet.map.fitBounds(bounds)
      sheet.getPolygons()

  getPolygons: () =>
    data = $('#sheetdata').data("map")


    no_color = '#AF2228'
    yes_color = '#609846'
    fix_color = '#FFB92D'
    nil_color = '#AAAAAA'

    return if data.nil_poly.features.length==0 && data.fix_poly.features.length==0 && data.no_poly.features.length==0 && data.yes_poly.features.length==0

    m = @map

    yes_json = L.geoJson(data.yes_poly,
      style: (feature) ->
        fillColor: yes_color
        opacity: 0
        fillOpacity: 0.7
        stroke: false
      onEachFeature: (f,l) ->
        out = for key, val of f.properties
          val = "<a href='/polygons/#{val}'>#{val}</a>" if key == "id"
          "<strong>#{key}:</strong> #{val}"
        l.bindPopup(out.join("<br />"))
        l.on 'click', ()->
          m.fitBounds(@.getBounds())
    )
    no_json = L.geoJson(data.no_poly,
      style: (feature) ->
        fillColor: no_color
        opacity: 0
        fillOpacity: 0.7
        stroke: false
      onEachFeature: (f,l) ->
        out = for key, val of f.properties
          val = "<a href='/polygons/#{val}'>#{val}</a>" if key == "id"
          "<strong>#{key}:</strong> #{val}"
        l.bindPopup(out.join("<br />"))
        l.on 'click', ()->
          m.fitBounds(@.getBounds())
    )
    fix_json = L.geoJson(data.fix_poly,
      style: (feature) ->
        fillColor: fix_color
        opacity: 0
        fillOpacity: 0.7
        stroke: false
      onEachFeature: (f,l) ->
        out = for key, val of f.properties
          val = "<a href='/polygons/#{val}'>#{val}</a>" if key == "id"
          "<strong>#{key}:</strong> #{val}"
        l.bindPopup(out.join("<br />"))
        l.on 'click', ()->
          m.fitBounds(@.getBounds())
    )
    nil_json = L.geoJson(data.nil_poly,
      style: (feature) ->
        fillColor: nil_color
        opacity: 0
        fillOpacity: 0.7
        stroke: false
      onEachFeature: (f,l) ->
        out = for key, val of f.properties
          val = "<a href='/polygons/#{val}'>#{val}</a>" if key == "id"
          "<strong>#{key}:</strong> #{val}"
        l.bindPopup(out.join("<br />"))
        l.on 'click', ()->
          m.fitBounds(@.getBounds())
    )

    # bounds = new L.LatLngBounds()

    if data.yes_poly.features.length>0
      yes_json.addTo(m)
      # bounds.extend(yes_json.getBounds())

    if data.no_poly.features.length>0
      no_json.addTo(m)
      # bounds.extend(no_json.getBounds())

    if data.fix_poly.features.length>0
      fix_json.addTo(m)
      # bounds.extend(fix_json.getBounds())

    if data.nil_poly.features.length>0
      nil_json.addTo(m)
      # bounds.extend(nil_json.getBounds())

$ ->
  window._s = new Sheet