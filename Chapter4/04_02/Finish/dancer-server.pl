use Dancer;
use MongoDB;

my $client = MongoDB->connect();
my $quotes = $client->get_database('test')->get_collection('quotes');

get '/api/quotes' => sub {
    my $response = $quotes->find()->sort({'index' => -1})->limit(10);
    my @results = ();
    while(my $quote = $response->next) {
                push (@results,
                        {"content" => $quote->{'content'},
                         "index"   => $quote->{'index'},
                         "author"  => $quote->{'author'}
                         }
                );
        } 
        return \@results;
};

get '/api/quotes/random' => sub {
    my $max_item = $quotes->find()->sort({'index' => -1})->limit(1);
    my $quote = $max_item->next;
    my $max_id = $quote->{'index'};
    my $random = int(rand($max_id));
    my $response = $quotes->find_one({"index" => $random});
    return $response;
};

get '/api/quotes/:index' => sub {
    my $response = $quotes->find_one({"index" => int(params->{'index'})}); 
    if (!$response) {
        status 404;
        return;
    }
    return $response;
};


get '/' => sub{
    return {message => "Hello from Perl and Dancer"};
};

set public => path(dirname(__FILE__), '..', 'static');

get "/demo/?" => sub {
    send_file '/index.html'
};

dance;

