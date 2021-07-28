abstract class LocationFetchEvents {}

class LocationFetched extends LocationFetchEvents {
  LocationFetched() {}
}

class LocationNotFetched extends LocationFetchEvents {
  LocationNotFetched() {}
}

class LocationLoading extends LocationFetchEvents {
  LocationLoading() {}
}
