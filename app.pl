#!/usr/bin/env perl
use v5.10;
use Mojolicious::Lite;
use Mojo::Redis;
use Mojo::IOLoop;

# Выдача страницы по шаблону, определенному в секции __DATA__
get '/' => sub {
  my ($self) = @_;
  $self->render('index');
};

websocket '/pubsub/:channel' => sub {
    my ($self) = @_;

    my $pub_handler = sub {
        my ($sub, $message, $channel) = @_;
        $self->send($message);
    };

    my $sub = $self->redis($self->stash('channel'));
    $sub->on(message => $pub_handler);
    $self->on(finish => sub {
        $sub->unsubscribe(message => $pub_handler);
    });

    Mojo::IOLoop->stream($self->tx->connection)->timeout(600);
};

helper 'redis' => sub {
    my ($self, $channel) = @_;
    state %redis_connections;
    return $redis_connections{$channel} //= Mojo::Redis->new->subscribe($channel);
};

app->start;

__DATA__

@@ index.html.ep
<html>
    <head>
        <title>Websocket pub/sub example</title>
    </head>
    <body>
        <input style="width:500px;" value="<%= url_for("pubsubchannel", channel => "test")->to_abs %>" id="url">
        <button onclick="connect()">Connect</button>
        <div id="output"></div>
        <script>
            function connect() {
                var url = getUrl()
                var ws = new WebSocket(url)

                ws.onopen = function (event) {
                    displayMessage('Connected')
                }

                ws.onmessage = function (event) {
                    displayMessage(event.data)
                }
            }

            function getUrl() {
                return document.getElementById('url').value
            }

            function displayMessage(message) {
                var textContainer = document.getElementById('output')
                textContainer.innerHTML =  message + '<br>' + textContainer.innerHTML
            }
        </script>
    </body>
</html>
