# ncareol/mod_tile-docker

**Docker** image for running Apache w/ mod_tile, for serving static, pregenerated OSM tiles

## Usage

- map local port to container's port 80
- mount local volume of tiles to `/var/lib/mod_tile`

*e.g.*

```sh
docker run  -v /my/path/to/mod_tile:/var/lib/mod_tile -p 8080:80 ncareol/mod_tile
```

=> <http://localhost:8080>
