# ThingSpeak

[ThingSpeak](https://thingspeak.com) is an open source Internet of Things application and API to store and retrieve data from things using HTTP over the Internet or via a Local Area Network. With ThingSpeak, you can create sensor logging applications, location tracking applications, and a social network of things with status updates.

In addition to storing and retrieving numeric and alphanumeric data, the ThingSpeak API allows for numeric data processing such as timescaling, averaging, median, summing, and rounding. Each ThingSpeak Channel supports data entries of up to 8 data fields, latitude, longitude, elevation, and status. The channel feeds support JSON, XML, and CSV formats for integration into applications.

The ThingSpeak application also features time zone management, read/write API key management, and JavaScript-based charts from Highcharts.

## Quick Start with Docker

The easiest way to run ThingSpeak locally is with Docker:

```bash
git clone https://github.com/iobridge/thingspeak.git
cd thingspeak
docker compose up
```

The app will be running at http://localhost:3000/

## Manual Setup

### Requirements

- Ruby 3.4
- Rails 8.0
- MySQL 5.6+
- Node.js (for asset compilation)

### Installation

```bash
git clone https://github.com/iobridge/thingspeak.git
cd thingspeak
bundle install
cp config/database.yml.example config/database.yml
# Edit config/database.yml with your database credentials
rake db:create
rake db:schema:load
rails server
```

Your application will now be running at http://localhost:3000/

## Configuration

### Changing Application Text

Make changes to `config/locales/en.yml`. To avoid errors, ensure your lines start with spaces, not tabs. Set your application name using the `application_name` key.

### Email Setup (Optional)

Set your domain, user_name, and password in `config/environment.rb`.

## Upgrading

```bash
git pull origin master
bundle install
rake db:migrate
rails server
```

## API

ThingSpeak provides a REST API for reading and writing data to channels. See the [documentation](http://localhost:3000/docs) for details.

### Post Data

```
GET http://localhost:3000/update?api_key=YOUR_API_KEY&field1=73
```

### Read Data

```
GET http://localhost:3000/channels/YOUR_CHANNEL_ID/feeds.json
```

Feeds are available in JSON, XML, and CSV formats.

## License

ThingSpeak is open source under the [GPL v3](http://www.gnu.org/licenses/gpl.html) license.
