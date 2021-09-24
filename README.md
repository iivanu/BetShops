# Betshops

"Betshops"  is a testing assignment to create one page application.

Please refer to the screenshots in folder `{platform}_screenshots`.

## Behavior:

* Application shows betshops for client on map (using default mapping library for platform) -> bet shops are located in Germany
* User can move the map and zoom-in/zoom-out
* When clicking on betshop icon, detail pops out and user can see the relevant information about the betshop
* When clicking on the "Route" button, user is transferred into default navigation application to navigate to betshop location

## Tips:

* User makes the defined API call and draws markers on the map
* If user denies the location, center of the map is set to center of Munich `48.137154, 11.576124`
* Working time - suppose that working time is 08:00 - 16:00
  * If betshop is OPEN at the moment, clock label should present `Open now until [END TIME]`
  * If betshop is CLOSED, clock label should present `Opens tomorrow at [START TIME]`
* Betshop detail data is presented in 3 rows:
  1. Name
  2. Address
  3. [City] - [County]
* Selected betshop has different asset (large green pin)

### Android tips:

* Use some common app architecture like architecture components, MVP, MVVM or something similar
* RxJava is a bonus but not mandatory

## Rest API:

**Host**:

* https://interview.superology.dev

**Resource**:

* `GET /betshops?boundingBox={0}`

**Query parameters**:

 * `boundingBox`
   * bounding box in CSV format "top-right latitude (lat1), top-right longitude (lon1), bottom-left latitude (lat2), bottom-left longitude (lon2)"
   * example: `48.16124,11.60912,48.12229,11.52741`

 **Response** : (HTTP 200)

```json
  {
    "count": 109,
    "betshops": [
      {
        "name": " Lenbachplatz 7",
        "location": {
          "lng": 11.5689638,
          "lat": 48.1405515
        },
        "id": 2350329,
        "county": "Bayern",
        "city_id": 80333,
        "city": "Muenchen",
        "address": "80333 Muenchen"
      },
      {
        "name": " St-Galler-Str 4",
        "location": {
          "lng": 11.5310798,
          "lat": 48.1600108
        },
        "id": 2350575,
        "county": "Bayern",
        "city_id": 80637,
        "city": "Muenchen",
        "address": "80637 Muenchen"
      },
      {
        "name": " Marienplatz 1/U-Bahn-Kiosk",
        "location": {
          "lng": 11.5754485,
          "lat": 48.1373932
        },
        "id": 2350022,
        "county": "Bayern",
        "city_id": 80331,
        "city": "Muenchen",
        "address": "80331 Muenchen"
      }
    ]
  }
```


Example CURL request and response is provided in `curl.log`.
