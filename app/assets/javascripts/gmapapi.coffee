#  ________  ________  ________          ___       _______   _______      
# |\   __  \|\   __  \|\   __  \        |\  \     |\  ___ \ |\  ___ \     
# \ \  \|\ /\ \  \|\  \ \  \|\ /_       \ \  \    \ \   __/|\ \   __/|    
#  \ \   __  \ \  \\\  \ \   __  \       \ \  \    \ \  \_|/_\ \  \_|/__  
#   \ \  \|\  \ \  \\\  \ \  \|\  \       \ \  \____\ \  \_|\ \ \  \_|\ \ 
#    \ \_______\ \_______\ \_______\       \ \_______\ \_______\ \_______\
#     \|_______|\|_______|\|_______|        \|_______|\|_______|\|_______|

jQuery ($) ->

    # Make the following global variables
    map = null 
    infowindow = null
    request = null
    icons = null
    specific_icon = null
    marker = null
    markers = null
    value = null
    collection = null
    getTypes = null
    place = null
    pois = null

    # main entry  
    init = () ->
        # Setup map options
        mapOptions =
            center: new google.maps.LatLng(47.5865, -122.150)
            zoom: 11
            streetViewControl: false
            panControl: false
            mapTypeId: google.maps.MapTypeId.ROADMAP
            zoomControlOptions: 
                style: google.maps.ZoomControlStyle.SMALL
            mapTypeControlOptions:
                mapTypeIds: [google.maps.MapTypeId.ROADMAP, 'map_style']
              
        # Setup POI types
        getTypes = (types=[]) ->
            icons =
                restaurant: 'http://maps.google.com/intl/en_us/mapfiles/ms/micons/blue.png'
                park: 'http://maps.google.com/intl/en_us/mapfiles/ms/micons/green.png'
                school:'http://maps.google.com/intl/en_us/mapfiles/ms/micons/orange.png'
                university:'http://maps.google.com/intl/en_us/mapfiles/ms/micons/orange.png'
                store: 'http://maps.google.com/intl/en_us/mapfiles/ms/micons/yellow.png'
                department_store: 'http://maps.google.com/intl/en_us/mapfiles/ms/micons/yellow.png'
                clothing_store: 'http://maps.google.com/intl/en_us/mapfiles/ms/micons/yellow.png'
                shopping_mall:'http://maps.google.com/intl/en_us/mapfiles/ms/micons/yellow.png'
                gym: 'http://maps.google.com/intl/en_us/mapfiles/ms/micons/red.png'
                health: 'http://maps.google.com/intl/en_us/mapfiles/ms/micons/red.png'
                museum:'http://maps.google.com/intl/en_us/mapfiles/ms/micons/purple.png'
                movie_theater:'http://maps.google.com/intl/en_us/mapfiles/ms/micons/purple.png'
                amusement_park: 'http://maps.google.com/intl/en_us/mapfiles/ms/micons/purple.png'
                art_gallery: 'http://maps.google.com/intl/en_us/mapfiles/ms/micons/purple.png'
            
            if not types.length
              for key of icons
                key
            else
              for icon in types
                if icon of icons
                  return icons[icon] 

        # Create the map with above options in div
        map = new google.maps.Map(document.getElementById("map"),mapOptions)

       
        # Drop marker in the same location
        marker = new google.maps.Marker
            map: map
            animation: google.maps.Animation.DROP
            position: new google.maps.LatLng(47.53772, -122.1153)
            icon: 'http://maps.google.com/mapfiles/arrow.png'
        
       
        # Create a request field to hold POIs
        request = 
            location: new google.maps.LatLng(47.58816, -122.16342)
            radius: '7000'
            types: getTypes()

        # Create the infowindow(popup over marker)
        infowindow = new google.maps.InfoWindow()

        # Setup places nearby search (it setups points near the center marker)
        service = new google.maps.places.PlacesService(map)
        service.nearbySearch(request, callback)
        
        # draw polyline
        drawPolyline()
        
        # draw path 
        drawPathPolyline()

    # Create the callback function to loop thru the places (object)
    callback = (results, status) ->
        pois = []
        if status is google.maps.places.PlacesServiceStatus.OK
            for index, attrs of results
                poi = results[index]
                pois.push(poi)
            
        all = document.getElementById('all')
        google.maps.event.addDomListenerOnce all, 'click', ->
            for index, v of pois
                createMarker v
                console.log v.types

        school = document.getElementById('school')
        google.maps.event.addDomListenerOnce school, 'click', ->
            for index, v of pois
                if v.types.indexOf('school') != -1
                    createMarker v

    # Create the actual markers for the looped places
    createMarker = (place) ->
        # Create markers for of the types assigned above in getTypes function
        marker = new google.maps.Marker
            map: map
            position: place.geometry.location
            icon:  getTypes(place.types)
       

        # Create a click listener that shows a info window with places name
        google.maps.event.addListener marker, 'click', ->
            infowindow.setContent(place.name)
            infowindow.open(map,@)
            
        placesList = document.getElementById('results')
        placesList.innerHTML += '<p class="' + place.types + '">' + place.name + '</p>';

    # sample code for draw polyline
    drawPolyline = () -> 
        # Showing the path
        flightPlanCoordinates = [
            {lat: 37.322701, lng: 127.022245},
            {lat: 33.395369, lng: 126.494901},
            {lat: 35.849403, lng: 128.553308}
        ]
        
        flightPath = new google.maps.Polyline({
            path: flightPlanCoordinates,
            geodesic: true,
            strokeColor: '#FF0000',
            strokeOpacity: 1.0,
            strokeWeight: 2
        })
    
        flightPath.setMap(map)
    
    # Define the symbol, using one of the predefined paths ('CIRCLE')
    # supplied by the Google Maps JavaScript API.
    drawPathPolyline = () ->
        lineSymbol = 
            path: google.maps.SymbolPath.CIRCLE,
            scale: 8,
            strokeColor: '#393'        
        
        # Create the polyline and add the symbol to it via the 'icons' property.
        line = new google.maps.Polyline({
            path: flightPlanCoordinates,
            icons: [{
                icon: lineSymbol,
                offset: '100%'
            }],
            map: map
        });
        
        animateCircle(line)
        
    # Use the DOM setInterval() function to change the offset of the symbol at fixed intervals.
    animateCircle = (line) ->
        count = 0;
        window.setInterval(() ->
            count = (count + 1) % 200
            
            icons = line.get('icons')
            icons[0].offset = (count / 2) + '%'
            line.set('icons', icons)
        , 20)


    # Create the click event handler
    $('#clear').click ->
        console.log "Clear button clicked!"
        clearList = document.getElementById('results')
        clearList.innerHTML = "<p></p>"

    # move to location    
    $('#transform').click ->
        console.log "transform button clicked!"
        
        transformToAxis()
    
    # transform address to axis
    transformToAxis = () -> 
        console.log "called transformToAxis"
        
        geocoder = new google.maps.Geocoder();
        address = document.getElementById("address").value;

        geocoder.geocode({'address': address}, (results, status) -> 
            if status == google.maps.GeocoderStatus.OK
                darwin = new google.maps.LatLng(results[0].geometry.location.lat(), results[0].geometry.location.lng());
                map.setCenter(darwin)
            else
                alert("Geocode was not successful for the following reason: " + status)
        )    
    
    # search into google spreadsheets
    $('#nearBySearch').click ->
        console.log "nearBySearch button click!"
        
        drawToIframe()
        drawMarkerToPlace()

    # draw to iframe tag
    drawToIframe = () -> 
        console.log "called redrawToIframe"
        
        key = '1n3uci3ucTqJOA1nIDO90ihfPPJkpM6JQRSdwZdLN6aQ'
        dat = document.getElementById("location").value

        sqlByCategory = {
            movie   : ['0', "SELECT B,C,D,E,F,G,H,I,J WHERE B CONTAINS '#{dat}'"],
            book    : ['325940056', "SELECT B,C,D,E,F,G,H,I WHERE B CONTAINS '#{dat}'"],
            concert : ['152989327', "SELECT B,C,D,E,F,G WHERE B CONTAINS '#{dat}'"],
            lecture : ['904106426', "SELECT B,C,D,E,F,G WHERE B CONTAINS '#{dat}'"],
            travel  : ['1432675087', "SELECT B,C,D,E,F,G WHERE B CONTAINS '#{dat}' OR G CONTAINS '#{dat}'"]
        }
        
        # reload source attribute of iframe.
        category = switch $('#category').val() 
            when 'Movie' then sqlByCategory.movie
            when 'Book' then sqlByCategory.book
            when 'Concert' then sqlByCategory.concert
            when 'Lecture' then sqlByCategory.lecture
            when 'Travel' then sqlByCategory.travel
            else sqlByCategory.travel
            
        $('#travelList').attr('src', makeQueryOutHTML(key, category[0], category[1]))

    # make a query string
    makeQueryOutHTML = (sheet_key, sheet_gid, sql_stmt) ->
        console.log "called makeQueryOutHTML : #{sql_stmt}"
        
        query = "https://spreadsheets.google.com/tq?tqx=out:html&tq=#{sql_stmt}&key=#{sheet_key}&gid=#{sheet_gid}"

    # draw marker to place
    drawMarkerToPlace = () -> 
        console.log "called drawMarkerToPlace"
        
        address = document.getElementById("location").value;
                
        geocoder = new google.maps.Geocoder();
        geocoder.geocode({'address': address}, (results, status) -> 
            if status == google.maps.GeocoderStatus.OK 
                darwin = new google.maps.LatLng(results[0].geometry.location.lat(), results[0].geometry.location.lng());
                
                # create marker object
                marker = new google.maps.Marker
                    map: map
                    animation: google.maps.Animation.DROP
                    position: darwin
                    icon: 'http://maps.google.com/intl/en_us/mapfiles/ms/micons/green.png'
                
                # Create the infowindow(popup over marker)
                infowindow = new google.maps.InfoWindow()
                
                # register click event handler
                google.maps.event.addListener marker, "click", () -> infowindow.open(map, marker)
                
                # move to center
                map.setCenter(darwin)
            else
                console.log "error"
        )
    
    
    init()