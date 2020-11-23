# HVV GTFS MySQL import

The HVV public transport agency in Hamburg, Germany [publishes it's schedule data](https://www.hvv.de/de/fahrplaene/abruf-fahrplaninfos/datenabruf) in the [GTFS format](https://developers.google.com/transit/gtfs).

This Docker based import script imports the provided GTFS data inside a MySQL databse to be browsed with PHPMyAdmin.

This data can then be easily queried with scripts that call the MySQL database to extract data from the GTFS. Run the example script to extract stations for a route like: `python3 ./stations_from_route.py -r U2`.


## Import

- download the [GTFS data](https://suche.transparenz.hamburg.de/dataset?esq_type=app&esq_type=dataset&esq_type=document&f=PDF&f=HTML&f=ZIP&f=CSV&f=XML&f=xlsx&f=XLS&f=gml&f=wms&f=wfs&f=rar&f=TXT&f=jpg&f=jpeg&f=ascii&f=png&f=dxf&f=web&f=citygml&f=ert&f=docx&f=ov2&f=tiff&f=xsd&l=dl-de-by-2.0&l=dl-de-zero-2.0&esq_not_all_versions=true&esq_coverage_type=publication&e=vergleichbar&g=transport-und-verkehr&change_search=1&sort=publishing_date+desc%2Ctitle_sort+asc&esq_not_all_versions=true) you need
- extract them into the `./gtfs/` folder
- run `$ docker-compose up -d`
- the mysql database is now running on port `3306` and PHPMyAdmin is running on `http://localhost:8080`. Use `gtfs` / `secret` to login.
