#mojo-websocket-pubsub

Websocket publish/subscribe example with Mojolicious and Redis.

### Installation

To run this application you need Redis and Perl 5 with some additional modules.

1. Install Redis with your system package manager.

2. Make sure you have Perl 5 installed by running ```perl -v```. Next, install the required modules by running ```sudo cpan Mojolicious Mojo::Redis```. Cpan will ask you a lot of questions which are all safe to be answered with defaults by pressing Enter. The first run of cpan will take some time to search for the nearest repository mirror, to load the modules list and other stuff, so be patient.

   Check the installation by running ```perl -MMojolicious -MMojo::Redis -e 'print "ok\n"'```.

### Running the application

```
git clone git@github.com:furagu/mojo-websocket-pubsub.git
mojo-websocket-pubsub/app.pl daemon
```

Target your browser at [127.0.0.1:3000](http://127.0.0.1:3000) and press "Connect" several times. Note the "Connected" messages.

Open ``redis-cli`` and type ```publish test Hey!```. Go to the browser and see "Hey!" message displayed several times.

Type ``info Clients`` in redis-cli to see that there are only two Redis connection used, no matter how many websocket connections are active (one for redis-cli and the other for the application).
